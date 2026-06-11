import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/network/api_client.dart';
import '../../data/models/learning_path_model.dart';
import '../../data/models/recommendation_model.dart';

class RecommendationProvider extends ChangeNotifier {
  List<LearningPathNode> _learningPath = [];
  bool _isLoadingPath = false;

  List<LearningPathNode> get learningPath => _learningPath;
  bool get isLoadingPath => _isLoadingPath;

  final ApiClient apiClient;

  double _progressPercentage = 0.0;
  double get progressPercentage => _progressPercentage;

  List<RecommendationModel> _recommendations = [];
  bool _isLoading = false;
  String? _errorMessage;

  RecommendationProvider({required this.apiClient});

  List<RecommendationModel> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRecommendations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await apiClient.get('/recommendations/');
      final List<dynamic> data = response as List<dynamic>;

      _recommendations = data
          .map((json) => RecommendationModel.fromJson(json))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('HttpException: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLearningPath() async {
    _isLoadingPath = true;
    notifyListeners();

    try {
      // Ajusta la URL según tu configuración de Django
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/learning-path/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _learningPath = data
            .map((item) => LearningPathNode.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint("Error al cargar la ruta: $e");
    } finally {
      _isLoadingPath = false;
      notifyListeners();
    }
  }

  /// Registra de forma asíncrona que el alumno completó la lección
  Future<bool> completeLesson(int recommendationId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Enviamos el ID de la recomendación al endpoint de progreso en Django
      await apiClient.post('/recommendations/$recommendationId/complete/', {});

      // Refrescamos la lista local para actualizar el Dashboard con las nuevas sugerencias de la IA
      await fetchRecommendations();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('HttpException: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchProfile() async {
    try {
      final response = await apiClient.get(
        '/profile/',
      ); // Llama al endpoint de perfil
      _progressPercentage =
          (response['progress_percentage'] as num).toDouble() / 100;
      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando perfil: $e');
    }
  }
}
