from django.test import TestCase
from recommendation.models import User, StudentProfile, LearningObject
# Asumiendo que el motor está en un archivo engine.py o ia.py dentro de recommendation
from recommendation.engine import HybridRecommendationEngine 

class RecommendationEngineTests(TestCase):
    
    def setUp(self):
        """
        Preparación del entorno. Crea los perfiles de prueba y el Repositorio 
        de Objetos de Aprendizaje (ROA).
        """
        # 1. Crear usuarios y perfiles
        self.user_normal = User.objects.create_user(
            username="estudiante_1", password="123", role="student"
        )
        self.perfil_normal = StudentProfile.objects.create(
            user=self.user_normal,
            academic_risk=0.2, # Riesgo bajo
            weak_topics="Condicionales" # Se almacena como texto según el modelo
        )

        self.user_riesgo = User.objects.create_user(
            username="estudiante_2", password="123", role="student"
        )
        self.perfil_riesgo = StudentProfile.objects.create(
            user=self.user_riesgo,
            academic_risk=0.85, # Riesgo alto (> 0.7 activa la penalización del motor)
            weak_topics="Matrices, Tensores"
        )

        # 2. Poblar el catálogo (ROA)
        self.obj_condicionales = LearningObject.objects.create(
            title="If/Else en Profundidad",
            description="Uso de condicionales.",
            topic="Condicionales",
            difficulty="medium",
            resource_type="video"
        )
        self.obj_matrices_facil = LearningObject.objects.create(
            title="Introducción a Matrices",
            description="Conceptos básicos.",
            topic="Matrices",
            difficulty="easy",
            resource_type="text"
        )
        self.obj_matrices_dificil = LearningObject.objects.create(
            title="Álgebra Lineal con Matrices",
            description="Operaciones complejas.",
            topic="Matrices complejas y tensores",
            difficulty="hard",
            resource_type="code"
        )

        # 3. Inicializar el Singleton del motor
        self.motor = HybridRecommendationEngine()

    def _preparar_datos_para_motor(self, perfil):
        """
        Helper para serializar los QuerySets de Django al formato (dict/list) 
        que espera el método get_recommendations_for_student y Pandas.
        """
        # Convierte el string de temas débiles a una lista
        temas_lista = [t.strip() for t in perfil.weak_topics.split(',')] if perfil.weak_topics else []
        
        perfil_dict = {
            'weak_topics': temas_lista,
            'current_risk': perfil.academic_risk # Mapeo de la base de datos al motor
        }
        
        # Convierte los objetos a una lista de diccionarios
        objetos_dict = list(LearningObject.objects.values(
            'id', 'title', 'topic', 'difficulty', 'resource_type'
        ))
        
        return perfil_dict, objetos_dict

    def test_patron_singleton_motor(self):
        """
        Validación de Arquitectura: Verifica que el motor no duplique instancias en memoria.
        """
        motor_secundario = HybridRecommendationEngine()
        self.assertIs(
            self.motor, motor_secundario,
            "El patrón Singleton ha fallado. Se están creando múltiples instancias en memoria."
        )

    def test_similitud_coseno_temas_debiles(self):
        """
        Prueba de NLP (TF-IDF): Verifica que el sistema recomienda objetos 
        cuyo 'topic' coincide con los 'weak_topics' del estudiante.
        """
        perfil_dict, objetos_dict = self._preparar_datos_para_motor(self.perfil_normal)
        
        recomendaciones = self.motor.get_recommendations_for_student(perfil_dict, objetos_dict)
        
        self.assertTrue(len(recomendaciones) > 0, "No se generaron recomendaciones.")
        self.assertEqual(
            recomendaciones[0]['id'], self.obj_condicionales.id,
            "TF-IDF no priorizó el objeto de aprendizaje correcto basado en el texto del tema."
        )

    def test_penalizacion_por_riesgo_academico(self):
        """
        Prueba de Lógica Condicional: Un estudiante con alto riesgo (>0.7) 
        que necesita aprender Matrices debe recibir el objeto 'fácil' primero, 
        ya que el motor reduce a la mitad el score de los objetos 'hard'.
        """
        perfil_dict, objetos_dict = self._preparar_datos_para_motor(self.perfil_riesgo)
        
        recomendaciones = self.motor.get_recommendations_for_student(perfil_dict, objetos_dict)
        
        id_top_recomendacion = recomendaciones[0]['id']
        
        # Aunque obj_matrices_dificil puede tener mayor similitud de texto por la palabra "tensores",
        # la penalidad de dificultad='hard' * 0.5 debe forzar a que el 'easy' quede en primer lugar.
        self.assertEqual(
            id_top_recomendacion, self.obj_matrices_facil.id,
            "La lógica de contención de riesgo académico falló al no penalizar la dificultad."
        )

    def test_retorno_por_defecto_sin_debilidades(self):
        """
        Prueba de Borde: Si el estudiante no tiene temas débiles registrados,
        el sistema debe retornar elementos genéricos sin fallar.
        """
        # Limpiamos los temas débiles
        self.perfil_normal.weak_topics = ""
        self.perfil_normal.save()
        
        perfil_dict, objetos_dict = self._preparar_datos_para_motor(self.perfil_normal)
        recomendaciones = self.motor.get_recommendations_for_student(perfil_dict, objetos_dict)
        
        # El motor debería devolver un máximo de 3 elementos si está vacío
        self.assertTrue(len(recomendaciones) <= 3)