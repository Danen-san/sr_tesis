// lib/src/data/models/recommendation_model.dart

class LearningObjectModel {
  final String title;
  final String topic;
  final String difficulty;
  final String description;

  LearningObjectModel({
    required this.title,
    required this.topic,
    required this.difficulty,
    required this.description,
  });

  factory LearningObjectModel.fromJson(Map<String, dynamic> json) {
    return LearningObjectModel(
      title: json['title'] as String,
      topic: json['topic'] as String,
      difficulty: json['difficulty'] as String,
      description: json['description'] as String,
    );
  }
}

class RecommendationModel {
  final int id;
  final LearningObjectModel learningObject;
  final double confidenceScore;

  RecommendationModel({
    required this.id,
    required this.learningObject,
    required this.confidenceScore,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'] as int,
      learningObject: LearningObjectModel.fromJson(json['learning_object']),
      confidenceScore: (json['confidence_score'] as num).toDouble(),
    );
  }
}
