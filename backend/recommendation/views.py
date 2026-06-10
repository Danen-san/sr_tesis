from django.shortcuts import render

# Create your views here.
# C:\Users\Pc\Documents\UCI\sr_tesis\backend\recommendation\views.py
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate
from rest_framework.permissions import IsAuthenticated
from .models import StudentProfile, LearningObject, Recommendation
from .serializers import RecommendationSerializer
from .engine import HybridRecommendationEngine
from .risk import RiskEvaluator
from .factories import ResourceFactory


class LoginAPIView(APIView):
    """
    Cumplimiento de RF01: Valida credenciales de usuario de la UCI 
    y retorna el token junto con el rol institucional.
    """
    permission_classes = []  

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        if not username or not password:
            return Response(
                {'error': 'Debe proporcionar un usuario de red y contraseña.'},
                status=status.HTTP_400_BAD_REQUEST
            )

        user = authenticate(username=username, password=password)

        if user is not None:
            token, _ = Token.objects.get_or_create(user=user)
            return Response({
                'token': token.key,
                'role': user.role,
                'username': user.username,
                'email': user.email
            }, status=status.HTTP_200_OK)
            
        return Response(
            {'error': 'Credenciales incorrectas o usuario inexistente.'},
            status=status.HTTP_401_UNAUTHORIZED
        )

class TargetRecommendationsAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        try:
            profile = user.student_profile
        except StudentProfile.DoesNotExist:
            return Response({'error': 'Perfil inválido.'}, status=status.HTTP_400_BAD_REQUEST)

        # 1. Preparamos los datos para la IA
        all_learning_objects = list(LearningObject.objects.all().values(
            'id', 'topic', 'difficulty', 'title', 'description'
        ))
        
        student_profile_data = {
            'weak_topics': [t.name for t in profile.weak_topics.all()],
            'current_risk': float(profile.academic_risk)
        }

        # 2. Invocamos al motor de IA
        engine = HybridRecommendationEngine()
        recommendations_data = engine.get_recommendations_for_student(student_profile_data, all_learning_objects)

        # 3. Guardamos las recomendaciones generadas en la DB
        for item in recommendations_data:
            lo = LearningObject.objects.get(id=item['id'])
            Recommendation.objects.get_or_create(
                student=profile,
                learning_object=lo,
                defaults={'confidence_score': item['score']}
            )

        # 4. Retornamos usando tu serializer actual
        active_recommendations = Recommendation.objects.filter(student=profile, is_consumed=False)
        serializer = RecommendationSerializer(active_recommendations, many=True)
        
        return Response(serializer.data, status=status.HTTP_200_OK)
class ConsumeRecommendationAPIView(APIView):
    """
    Registra la interacción del estudiante con el objeto didáctico 
    e invoca al evaluador de riesgo para notificar a los profesores.
    """
    permission_classes = [IsAuthenticated]

    def patch(self, request, pk):
        profile = request.user.student_profile
        try:
            recommendation = Recommendation.objects.get(pk=pk, student=profile)
        except Recommendation.DoesNotExist:
            return Response({'error': 'Recomendación no encontrada'}, status=status.HTTP_404_NOT_FOUND)

        rating = request.data.get('feedback_rating')
        if rating is None or not (1 <= int(rating) <= 5):
            return Response({'error': 'Calificación inválida.'}, status=status.HTTP_400_BAD_REQUEST)

        # 1. Guardar feedback
        rating_int = int(rating)
        recommendation.is_consumed = True
        recommendation.feedback_rating = rating_int
        recommendation.save()

        # 2. Lógica de "Aprendizaje" sobre el perfil existente
        current_weak = [t.strip() for t in profile.weak_topics.split(',')] if profile.weak_topics else []
        topic = recommendation.learning_object.topic.strip()

        changed = False # Bandera para saber si guardamos cambios
        
        if rating_int <= 2:
            # Si le fue mal, aumentamos el riesgo y añadimos a debilidades
            if topic not in current_weak:
                current_weak.append(topic)
                profile.weak_topics = ','.join(current_weak)
            
            # Incremento de riesgo por desempeño bajo
            profile.academic_risk = min(1.0, profile.academic_risk + 0.15)
            changed = True
            
            # LÍNEA CRUCIAL: Patrón Observer
            # El Sujeto (RiskEvaluator) analiza y notifica a los observadores (profesores)
            RiskEvaluator.evaluate_and_notify(profile)

        elif rating_int >= 4:
            # Si le fue bien, reducimos el riesgo y eliminamos de debilidades
            if topic in current_weak:
                current_weak.remove(topic)
                profile.weak_topics = ','.join(current_weak)
                changed = True
            
            if profile.academic_risk > 0:
                profile.academic_risk = max(0.0, profile.academic_risk - 0.05)
                changed = True

        if changed:
            profile.save()

        return Response({
            'message': 'Perfil de estudiante actualizado correctamente.',
            'current_risk': profile.academic_risk
        }, status=status.HTTP_200_OK)
class StudentProfileAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        profile = request.user.student_profile
        return Response({
            'academic_risk': profile.academic_risk,
            'performance_score': profile.performance_score,
            'completed_modules': profile.completed_modules,
            # Calculamos el progreso porcentual (ejemplo: basado en módulos)
            'progress_percentage': min(profile.completed_modules * 10, 100) 
        })
    
def get_learning_data(learning_obj):
    # La API ahora usa la fábrica, ignorando si es video o texto
    return ResourceFactory.get_resource(learning_obj)