// lib/src/presentation/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../../core/database/db_helper.dart';
import '../../core/network/api_client.dart';
import '../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient apiClient;
  final DbHelper dbHelper = DbHelper(); // Instancia del gestor SQLite

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  AuthProvider({required this.apiClient});

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  /// Verifica de forma asíncrona si hay una sesión activa al arrancar la app
  Future<bool> checkLocalSession() async {
    final localUser = await dbHelper.getUser();
    if (localUser != null) {
      _currentUser = localUser;
      apiClient.updateToken(
        localUser.token,
      ); // Inyecta el token al cliente HTTP
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await apiClient.post('/auth/login/', {
        'username': username,
        'password': password,
      });

      _currentUser = UserModel.fromJson(response);
      apiClient.updateToken(_currentUser!.token);

      // PERSISTENCIA: Guardamos el usuario localmente en el teléfono
      await dbHelper.saveUser(_currentUser!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('HttpException: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    apiClient.updateToken(null);
    // PERSISTENCIA: Borramos el rastro de la base de datos de Android
    await dbHelper.deleteUser();
    notifyListeners();
  }
}
