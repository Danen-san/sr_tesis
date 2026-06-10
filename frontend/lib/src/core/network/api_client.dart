// lib/src/core/network/api_client.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiClient {
  // Gracias al puente de adb reverse, apuntamos directamente a tu PC
  final String _baseUrl = 'http://localhost:8000/api';
  String? _token;

  void updateToken(String? token) {
    _token = token;
  }

  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Token $_token';
    }
    return headers;
  }

  /// Petición POST Asíncrona (Para el Login)
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw const HttpException(
        'No hay conexión con el servidor. Verifica el puente ADB.',
      );
    }
  }

  /// Petición GET Asíncrona (Para obtener Recomendaciones)
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.get(url, headers: _getHeaders());
      return _processResponse(response);
    } on SocketException {
      throw const HttpException(
        'Error de red al intentar conectar con el backend.',
      );
    }
  }

  dynamic _processResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));

    if (statusCode >= 200 && statusCode < 300) {
      return decodedBody;
    } else if (statusCode == 401) {
      throw const HttpException('Sesión inválida o credenciales incorrectas.');
    } else {
      final errorMessage =
          decodedBody['error'] ?? 'Ocurrió un error en el servidor.';
      throw HttpException(errorMessage.toString());
    }
  }
}
