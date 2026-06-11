# C:\Users\Pc\Documents\UCI\sr_tesis\backend\recommendation\serializers.py
from rest_framework import serializers
from .models import Recommendation, LearningObject, StudentProfile

class LearningObjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = LearningObject
        fields = ['id', 'title', 'description', 'topic', 'difficulty', 'content_url', 'metadata']

class RecommendationSerializer(serializers.ModelSerializer):
    learning_object = LearningObjectSerializer(read_only=True)

    class Meta:
        model = Recommendation
        fields = ['id', 'student', 'learning_object', 'confidence_score', 'is_consumed', 'feedback_rating', 'generated_at']