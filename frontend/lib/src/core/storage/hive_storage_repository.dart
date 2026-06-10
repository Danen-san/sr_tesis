import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

class HiveStorageRepository {
  // 1. Instancia estática y privada en memoria
  static final HiveStorageRepository _instance =
      HiveStorageRepository._internal();

  // 2. Constructor de fábrica: Dart intercepta la creación y devuelve la instancia existente
  factory HiveStorageRepository() {
    return _instance;
  }

  // 3. Constructor interno privado (solo se llama la primera vez)
  HiveStorageRepository._internal();

  bool _isInitialized = false;

  /// Inicializa Hive y abre las cajas. Debe llamarse en el main.dart
  Future<void> initStorage() async {
    if (!_isInitialized) {
      await Hive.initFlutter();

      // Abre aquí todas las cajas que necesite tu sistema offline
      await Hive.openBox('authBox');
      await Hive.openBox('recommendationsBox');

      _isInitialized = true;
      debugPrint(
        "HiveStorageRepository: Singleton inicializado correctamente.",
      );
    }
  }

  // --- Métodos centralizados de acceso seguro ---

  Box get authBox {
    if (!_isInitialized) throw Exception("Hive no ha sido inicializado.");
    return Hive.box('authBox');
  }

  Box get recommendationsBox {
    if (!_isInitialized) throw Exception("Hive no ha sido inicializado.");
    return Hive.box('recommendationsBox');
  }

  // Ejemplo de método de negocio encapsulado
  Future<void> saveToken(String token) async {
    await authBox.put('token', token);
  }

  String? getToken() {
    return authBox.get('token');
  }
}
