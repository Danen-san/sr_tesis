# C:\Users\Pc\Documents\UCI\sr_tesis\backend\recommendation\admin.py
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, StudentProfile, LearningObject, Recommendation, Topic

class CustomUserAdmin(UserAdmin):
    fieldsets = UserAdmin.fieldsets + (
        ('Roles Académicos', {'fields': ('role',)}),
    )
    list_display = ['username', 'email', 'role', 'is_staff']

# Registrar el modelo User personalizado con su panel adaptado
admin.site.register(User, CustomUserAdmin)


@admin.register(StudentProfile)
class StudentProfileAdmin(admin.ModelAdmin):  # <-- Corregido aquí
    list_display = ['user', 'academic_risk', 'performance_score', 'completed_modules']
    list_filter = ['academic_risk']
    search_fields = ['user__username', 'user__first_name', 'user__last_name']


@admin.register(Topic)
class TopicAdmin(admin.ModelAdmin):
    list_display = ('name', 'description')
    search_fields = ('name',)

@admin.register(LearningObject)
class LearningObjectAdmin(admin.ModelAdmin):
    # 1. Cambiamos 'topic' por nuestra función personalizada 'get_topics'
    list_display = ('title', 'resource_type', 'difficulty', 'get_topics')
    
    # 2. El filtro lateral ahora debe apuntar a la tabla relacional de temas
    list_filter = ('resource_type', 'difficulty', 'topics')
    
    search_fields = ('title', 'description')

    # 3. Función auxiliar para mostrar los temas como texto separado por comas en el panel
    def get_topics(self, obj):
        return ", ".join([t.name for t in obj.topics.all()])
    
    # Le ponemos un título limpio a la columna en el panel de Django
    get_topics.short_description = 'Temas Evaluados'

@admin.register(Recommendation)
class RecommendationAdmin(admin.ModelAdmin):
    list_display = ['student', 'learning_object', 'confidence_score', 'is_consumed', 'feedback_rating']
    list_filter = ['is_consumed', 'feedback_rating']