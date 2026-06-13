# backend/seed_resources.py
import os
import django

# Asegúrate de colocar el nombre correcto de tu settings (ej: core.settings o backend.settings)
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from recommendation.models import LearningObject, Topic

def cargar_recursos():
    recursos = [
        # --- PDFs (Conferencias) ---
        {
            'title': 'Conceptos iniciales de programacion-De la idea a la maquina',
            'description': 'Documento con explicacion de los conceptos iniciales que todo programador debe conocer',
            'topics_list': ['conceptos_iniciales'],
            'difficulty': 'Fácil',
            'resource_type': 'PDF',
            'file': 'resources/conferencias/Conceptos iniciales de programacion-De la idea a la maquina.pdf'
        },
        # --- AUDIOS ---
        {
            'title': 'Cómo_dar_instrucciones_precisas_al_ordenador',
            'description': 'Audio explicativo diseñado para estudiantes con estilo de aprendizaje auditivo.',
            'topics_list': ['conceptos_iniciales'],
            'difficulty': 'Medio',
            'resource_type': 'AUDIO',
            'file': 'resources/audios/Cómo_dar_instrucciones_precisas_al_ordenador.m4a'
        },
        # --- TUTORIALES / VIDEOS ---
        {
            'title': 'backend/media/resources/videos/Lógica_algorítmica.mp4',
            'description': 'Video eXplicativo de la lógica algorítmica.',
            'topics_list': ['conceptos_iniciales'],
            'difficulty': 'Fácil',
            'resource_type': 'VIDEO',
            'file': 'resources/videos/Lógica_algorítmica.mp4',
        },
        # --- EJERCICIOS ---
        {
            'title': 'Ejercicios basicos de programacion lenguaje c++',
            'description': 'Guía de ejercicios para principiantes en c++',
            'topics_list': ['conceptos_iniciales'],
            'difficulty': 'Fácil',
            'resource_type': 'EJERCICIO',
            'file': 'resources/ejercicios/Ejercicios basicos de programacion lenguaje c++.pdf'
        },
        {
            'title': 'Ejercicios de seudocodigo e implementacion basicos',
            'description': 'Guía de ejercicios de pseudocódigo e implementación básicos',
            'topics_list': ['conceptos_iniciales'],
            'difficulty': 'Fácil',
            'resource_type': 'EJERCICIO',
            'file': 'resources/ejercicios/Ejercicios de seudocodigo e implementacion basicos.pdf'
        },
        {
            'title': 'Examenes Extraordinarios',
            'description': 'Examenes extraordinarios de años anteriores.',
            'topics_list': ['conceptos_iniciales', 'logica_algoritmica', 'estructuras_de_control','bucles'],
            'difficulty': 'Difícil',
            'resource_type': 'EXAMEN',
            'file': 'resources/ejercicios/Examenes Extraordinarios.pdf'
        },
        {
            'title': 'Examenes Ordinarios',
            'description': 'Guía de ejercicios con casos reales de bugs en bucles para solucionar.',
            'topics_list': ['conceptos_iniciales', 'logica_algoritmica', 'estructuras_de_control','bucles'],
            'difficulty': 'Difícil',
            'resource_type': 'EXAMEN',
            'file': 'resources/ejercicios/Examenes Ordinarios.pdf'
        }
    ]

    print("[SEED] Iniciando la inyección multitemática de tus recursos reales...")
    
    for item in recursos:
        # 1. ⚠️ OPERACIÓN CRUCIAL: Extraer la lista antes de que Django lea el diccionario
        lista_temas = item.pop('topics_list', [])
        
        # 2. Ahora item solo contiene campos válidos (title, description, file, etc.)
        obj, created = LearningObject.objects.get_or_create(
            title=item['title'],
            defaults=item
        )
        
        # 3. Crear o buscar las instancias de temas en su propia tabla relacional
        objetos_tema = []
        for nombre_tema in lista_temas:
            tema, _ = Topic.objects.get_or_create(name=nombre_tema.strip().lower())
            objetos_tema.append(tema)
        
        # 4. Asignar las relaciones a la tabla intermedia ManyToMany
        obj.topics.set(objetos_tema)
        
        if created:
            print(f"✅ Recurso registrado: '{obj.title}' -> Temas asociados: {lista_temas}")
        else:
            print(f"⚠️ Ya existía en la base de datos: '{obj.title}'")

    print("[SEED] Proceso completado de forma limpia en PostgreSQL.")

if __name__ == '__main__':
    cargar_recursos()