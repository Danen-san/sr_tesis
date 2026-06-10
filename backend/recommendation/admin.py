# C:\Users\Pc\Documents\UCI\sr_tesis\backend\recommendation\admin.py
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, StudentProfile, LearningObject, Recommendation

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


@admin.register(LearningObject)
class LearningObjectAdmin(admin.ModelAdmin):
    list_display = ['title', 'topic', 'difficulty', 'created_at']
    list_filter = ['difficulty', 'topic']
    search_fields = ['title', 'description']


@admin.register(Recommendation)
class RecommendationAdmin(admin.ModelAdmin):
    list_display = ['student', 'learning_object', 'confidence_score', 'is_consumed', 'feedback_rating']
    list_filter = ['is_consumed', 'feedback_rating']