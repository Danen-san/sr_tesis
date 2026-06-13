from django.db import models

# Create your models here.
# C:\Users\Pc\Documents\UCI\sr_tesis\backend\recommendation\models.py
from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    """
    Extensión del usuario base de Django para diferenciar roles académicos.
    """
    ROLE_CHOICES = (
        ('student', 'Estudiante'),
        ('teacher', 'Profesor'),
    )
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, default='student')

    def __str__(self):
        return f"{self.username} ({self.get_role_display()})"


class StudentProfile(models.Model):
    """
    Expediente Histórico del Estudiante. Base para el análisis de alertas y rendimiento.
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='student_profile')
    academic_risk = models.FloatField(default=0.0)  # Nivel de riesgo calculado (0.0 a 1.0)
    completed_modules = models.IntegerField(default=0)
    performance_score = models.FloatField(default=0.0)  # Nota promedio actual
    weak_topics = models.TextField(default="", blank=True)

    def __str__(self):
        return f"Expediente: {self.user.get_full_name() or self.user.username}"


class Topic(models.Model):
    """
    Modelo independiente para los temas/conceptos del plan de estudio (ej: bucles, condicionales).
    Ayuda al motor de recomendación a indexar los recursos correctamente.
    """
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.name
class LearningObject(models.Model):
    """
    Repositorio de Objetos de Aprendizaje (ROA) para Introducción a la Programación.
    """
    DIFFICULTY_CHOICES = (
        ('easy', 'Fácil'),
        ('medium', 'Medio'),
        ('hard', 'Difícil'),
    )
    FORMAT_CHOICES = (
        ('PDF', 'Documento / Conferencia'),
        ('AUDIO', 'Audio / Podcast'),
        ('VIDEO', 'Tutorial / Video'),
        ('EJERCICIO', 'Práctica / Ejercicio Práctico'),
        ('EXAMEN', 'Examen de Años Anteriores')
    )
    
    
    title = models.CharField(max_length=255)
    description = models.TextField()
    topics = models.ManyToManyField(Topic, related_name='learning_objects')
    difficulty = models.CharField(max_length=10, choices=DIFFICULTY_CHOICES, default='easy')
    content_url = models.URLField(blank=True, null=True)
    metadata = models.JSONField(default=dict, blank=True)  # Pesos o vectores del recomendador
    created_at = models.DateTimeField(auto_now_add=True)
    resource_type = models.CharField(max_length=10, choices=FORMAT_CHOICES, default='PDF')
    url = models.URLField(blank=True, null=True) # Para videos de YouTube o enlaces externos
    file = models.FileField(upload_to='resources/', blank=True, null=True) # Para tus PDFs y Audios locales
    def __str__(self):
        return f"[{self.difficulty.upper()}] {self.title} ({self.topic})"


class Recommendation(models.Model):
    """
    Historial y efectividad de las recomendaciones emitidas por el sistema.
    """
    student = models.ForeignKey(StudentProfile, on_delete=models.CASCADE, related_name='recommendations')
    learning_object = models.ForeignKey(LearningObject, on_delete=models.CASCADE)
    confidence_score = models.FloatField()  # Grado de compatibilidad calculado
    is_consumed = models.BooleanField(default=False)
    feedback_rating = models.IntegerField(blank=True, null=True)  # Evaluación del alumno (1-5)
    generated_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-confidence_score', '-generated_at']