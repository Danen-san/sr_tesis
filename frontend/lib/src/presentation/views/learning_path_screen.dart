import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/path_node.dart';

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Estos datos idealmente vendrán de tu RecommendationProvider
    final List<PathNode> nodes = [
      PathNode("Fundamentos", isCompleted: true),
      PathNode("Variables", isCompleted: true),
      PathNode("Bucles", isCurrent: true, isLocked: false),
      PathNode("Funciones", isLocked: true),
      PathNode("Matrices", isLocked: true),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopStats(),
            _buildUnitHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: _SinuousLearningPath(nodes: nodes),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
              ],
            ),
            child: Row(
              children: [
                const Text("12", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "450",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Unidad 1",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF001489),
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Variables y Tipos de Datos",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _SinuousLearningPath extends StatelessWidget {
  final List<PathNode> nodes;
  const _SinuousLearningPath({required this.nodes});

  @override
  Widget build(BuildContext context) {
    const double nodeSpacing = 160.0;
    final double totalHeight = nodes.length * nodeSpacing + 100;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // 1. El camino dibujado con CustomPaint
        CustomPaint(
          size: Size(screenWidth, totalHeight),
          painter: PathPainter(nodesCount: nodes.length, spacing: nodeSpacing),
        ),
        // 2. Los nodos posicionados sobre la misma curva
        ...List.generate(nodes.length, (index) {
          final double y = (index * nodeSpacing) + 80;
          // Función senoidal para la curva X: centro + sin(y) * amplitud
          final double x = screenWidth / 2 + math.sin(y / 80) * 80;
          final bool isRightSide = math.cos(y / 80) > 0;

          return Positioned(
            left:
                x -
                100, // Ajuste para centrar el widget del nodo (que mide 200 de ancho)
            top: y,
            child: SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isRightSide) _buildLabel(nodes[index].title),
                  _buildNodeIcon(nodes[index]),
                  if (isRightSide) _buildLabel(nodes[index].title),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNodeIcon(PathNode node) {
    Color color = Colors.grey.shade300;
    IconData icon = Icons.lock;
    if (node.isCompleted) {
      color = const Color(0xFF001489);
      icon = Icons.check;
    } else if (node.isCurrent) {
      color = const Color(0xFFFD7E14);
      icon = Icons.star;
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }

  Widget _buildLabel(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final int nodesCount;
  final double spacing;
  PathPainter({required this.nodesCount, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF001489).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Dibujar fondo de puntos (Grid)
    for (double i = 0; i < size.width; i += 20) {
      for (double j = 0; j < size.height; j += 20) {
        canvas.drawCircle(Offset(i, j), 1, dotPaint);
      }
    }

    final path = Path();
    final double startY = 80;
    final double centerX = size.width / 2;

    path.moveTo(centerX + math.sin(startY / 80) * 80, startY + 30);

    // Dibujar la curva senoidal de forma continua
    for (double y = startY; y < size.height - 50; y++) {
      double x = centerX + math.sin(y / 80) * 80;
      path.lineTo(x, y + 30);
    }

    canvas.drawPath(path, paint);

    // Dibujar el punto final (el círculo verde grande de la imagen)
    final endPointPaint = Paint()..color = const Color(0xFF43766C);
    canvas.drawCircle(
      Offset(
        centerX + math.sin((size.height - 60) / 80) * 80,
        size.height - 60,
      ),
      35,
      endPointPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
