// lib/data/models/path_node.dart
class PathNode {
  final String id; // Identificador que coincide con el backend (ej: 'bucles')
  final String
  title; // Nombre legible para mostrar en la etiqueta (ej: 'Bucles')
  final int phase; // Fase a la que pertenece (1 a 6)
  final String phaseName; // Nombre de la fase para el Header
  bool isCompleted;
  bool isCurrent;
  bool isLocked;

  PathNode({
    required this.id,
    required this.title,
    required this.phase,
    required this.phaseName,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isLocked = true,
  });
}
