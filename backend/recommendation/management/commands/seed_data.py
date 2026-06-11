# C:\Users\Pc\Documents\UCI\sr_tesis\backend\recommendation\management\commands\seed_data.py
from django.core.management.base import BaseCommand
from recommendation.models import User, StudentProfile, LearningObject, Recommendation
from django.contrib.auth import get_user_model

class Command(BaseCommand):
    help = 'Pobla la base de datos con objetos de aprendizaje y perfiles de prueba para la UCI'

    def handle(self, *args, **options):
        self.stdout.write('Iniciando el poblado de datos...')

        # 1. Crear Objetos de Aprendizaje (ROA) para Introducción a la Programación
        los_data = [
            # Nivel Fácil
            {'title': 'Introducción a las Variables', 'topic': 'Sintaxis Básica', 'difficulty': 'easy', 'description': 'Concepto de asignación de memoria, tipos de datos primitivos (int, float, char).'},
            {'title': 'Condicionales Simples (If-Else)', 'topic': 'Estructuras de Control', 'difficulty': 'easy', 'description': 'Uso de operadores lógicos y relacionales para bifurcar el flujo del programa.'},
            # Nivel Medio
            {'title': 'Bucles Contador (For)', 'topic': 'Estructuras de Control', 'difficulty': 'medium', 'description': 'Diseño de iteraciones definidas, manipulación de índices y rangos.'},
            {'title': 'Bucles Condicionales (While)', 'topic': 'Estructuras de Control', 'difficulty': 'medium', 'description': 'Control de flujos iterativos indefinidos y prevención de bucles infinitos.'},
            {'title': 'Funciones y Paso de Parámetros', 'topic': 'Modularidad', 'difficulty': 'medium', 'description': 'Modularización de código, ámbito de variables, paso por valor y por referencia.'},
            # Nivel Difícil
            {'title': 'Vectores y Matrices (Arreglos)', 'topic': 'Estructuras de Datos', 'difficulty': 'hard', 'description': 'Declaración, recorrido e inicialización de arreglos multidimensionales.'},
            {'title': 'Algoritmos de Ordenamiento Básicos', 'topic': 'Algoritmia', 'difficulty': 'hard', 'description': 'Implementación y análisis de los métodos de la Burbuja y Selección.'},
        ]

        for lo in los_data:
            LearningObject.objects.get_or_create(
                title=lo['title'],
                defaults={
                    'topic': lo['topic'],
                    'difficulty': lo['difficulty'],
                    'description': lo['description'],
                    'metadata': {'tags': [lo['topic'].lower(), 'programacion', 'uci']}
                }
            )
        self.stdout.write(self.style.SUCCESS(f'Se crearon/verificaron {len(los_data)} Objetos de Aprendizaje.'))

        # 2. Crear Estudiante 1: Alumno en Riesgo Académico (Necesita refuerzo)
        u1, created = User.objects.get_or_create(
            username='estudiante.riesgo',
            defaults={'email': 'riesgo@estudiantes.uci.cu', 'first_name': 'Juan', 'last_name': 'Pérez', 'role': 'student'}
        )
        if created:
            u1.set_password('Uci.2026*')
            u1.save()
        
        p1, _ = StudentProfile.objects.get_or_create(
            user=u1,
            defaults={'academic_risk': 0.75, 'performance_score': 2.8, 'completed_modules': 1}
        )

        # 3. Crear Estudiante 2: Alumno de Alto Rendimiento (Listo para desafíos)
        u2, created = User.objects.get_or_create(
            username='estudiante.excelente',
            defaults={'email': 'excelente@estudiantes.uci.cu', 'first_name': 'Maria', 'last_name': 'Gómez', 'role': 'student'}
        )
        if created:
            u2.set_password('Uci.2026*')
            u2.save()
            
        p2, _ = StudentProfile.objects.get_or_create(
            user=u2,
            defaults={'academic_risk': 0.10, 'performance_score': 4.7, 'completed_modules': 5}
        )

        self.stdout.write(self.style.SUCCESS('Usuarios y perfiles académicos de prueba creados con éxito.'))
        self.stdout.write(self.style.SUCCESS('Contraseña asignada para ambos: Uci.2026*'))