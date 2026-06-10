# backend/recommendation/risk.py
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

class RiskEvaluator:
    """
    Patrón Observer: Actúa como el Sujeto Observable (Subject).
    Evalúa el riesgo y notifica asíncronamente al TeacherDashboardController.
    """
    @staticmethod
    def evaluate_and_notify(student_profile):
        # Lógica de evaluación del umbral crítico (ej: riesgo > 0.75)
        if student_profile.academic_risk > 0.75:
            
            channel_layer = get_channel_layer()
            
            # Formateamos los datos para la alerta
            student_data = {
                "username": student_profile.user.username,
                "risk_score": student_profile.academic_risk,
                "weak_topics": student_profile.weak_topics
            }

            # Notificamos de forma inmediata a todos los observadores registrados en 'teacher_alerts'
            async_to_sync(channel_layer.group_send)(
                "teacher_alerts",
                {
                    "type": "risk_alert", # Esto llama al método risk_alert en el Consumer
                    "message": "¡Alerta Crítica! Alumno en riesgo de reprobación.",
                    "student_data": student_data
                }
            )
            print(f"Alerta enviada: {student_profile.user.username} está en riesgo crítico.")