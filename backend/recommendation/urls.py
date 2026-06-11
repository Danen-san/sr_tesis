# C:\Users\Pc\Documents\UCI\sr_tesis\backend\recommendation\urls.py
from django.urls import path
from .views import LoginAPIView, TargetRecommendationsAPIView, ConsumeRecommendationAPIView

urlpatterns = [
    path('auth/login/', LoginAPIView.as_view(), name='api_login'),
    path('recommendations/', TargetRecommendationsAPIView.as_view(), name='api_recommendations'),
    path('recommendations/<int:pk>/consume/', ConsumeRecommendationAPIView.as_view(), name='api_consume_recommendation'),
]