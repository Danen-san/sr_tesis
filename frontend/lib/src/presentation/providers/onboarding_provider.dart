import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  // 1. Estilo cognitivo dominante
  String _estiloCognitivo = '';
  
  // 2. Nivel de dominio autodeclarado por tema
  final Map<String, String> _nivelesDominio = {
    'Variables': 'Básico',
    'Bucles': 'Básico',
    'Matrices': 'Básico',
    'Funciones': 'Básico',
  };

  // 3. Temas de interés seleccionados (Chips)
  final List<String> _temasInteres = [];

  // Getters
  String get estiloCognitivo => _estiloCognitivo;
  Map<String, String> get nivelesDominio => _nivelesDominio;
  List<String> get temasInteres => _temasInteres;

  // Setters y métodos de actualización
  void setEstiloCognitivo(String estilo) {
    _estiloCognitivo = estilo;
    notifyListeners();
  }

  void setNivelDominio(String tema, String nivel) {
    _nivelesDominio[tema] = nivel;
    notifyListeners();
  }

  void toggleTemaInteres(String tema) {
    if (_temasInteres.contains(tema)) {
      _temasInteres.remove(tema);
    } else {
      _temasInteres.add(tema);
    }
    notifyListeners();
  }
}