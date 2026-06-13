# C:\Users\Pc\Documents\UCI\sr_tesis\backend\recommendation\urls.py
from django.urls import path
from .views import LoginAPIView, TargetRecommendationsAPIView, ConsumeRecommendationAPIView, StudentProfileAPIView,DiagnosticoInicialAPIView

urlpatterns = [
    path('auth/login/', LoginAPIView.as_view(), name='api_login'),

    path('recommendation/diagnostico_inicial/', DiagnosticoInicialAPIView.as_view(), name='diagnostico_inicial'),

    path('recommendations/', TargetRecommendationsAPIView.as_view(), name='api_recommendations'),
    path('recommendations/<int:pk>/consume/', ConsumeRecommendationAPIView.as_view(), name='api_consume_recommendation'),

    path('student/profile/', StudentProfileAPIView.as_view(), name='student_profile'),
]