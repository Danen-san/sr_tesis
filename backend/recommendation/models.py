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
        ('video', 'VideoResource'),
        ('text', 'TextResource'),
        ('code', 'CodeResource'),
    )
    
    title = models.CharField(max_length=255)
    description = models.TextField()
    topic = models.CharField(max_length=100)  # Ej. "Bucles For", "Condicionales"
    difficulty = models.CharField(max_length=10, choices=DIFFICULTY_CHOICES, default='easy')
    content_url = models.URLField(blank=True, null=True)
    metadata = models.JSONField(default=dict, blank=True)  # Pesos o vectores del recomendador
    created_at = models.DateTimeField(auto_now_add=True)
    resource_type = models.CharField(max_length=10, choices=FORMAT_CHOICES, default='text')
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