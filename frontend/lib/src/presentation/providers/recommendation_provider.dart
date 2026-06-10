import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';
import '../../data/models/recommendation_model.dart';

class RecommendationProvider extends ChangeNotifier {
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
