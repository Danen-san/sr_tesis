import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CognitiveChart extends StatelessWidget {
  const CognitiveChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CustomPaint(painter: RadarChartPainter()),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Lógica para dibujar el triángulo de aprendizaje (Visual, Auditivo, Kinestésico)
    final paint = Paint()
      ..color = AppColors.navyBlue.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    final path = Path();

    final center = Offset(size.width / 2, size.height / 2);
    // Coordenadas calculadas para el triángulo
    path.moveTo(center.dx, center.dy - 60); // Vértice superior
    path.lineTo(center.dx + 60, center.dy + 40); // Derecha
    path.lineTo(center.dx - 60, center.dy + 40); // Izquierda
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
