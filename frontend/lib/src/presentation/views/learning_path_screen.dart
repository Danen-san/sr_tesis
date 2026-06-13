import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Ruta correcta// Asegúrate de tener la extensión context.watch()
// Importa tus repositorios o providers reales aquí
// import '../../data/providers/recommendation_provider.dart';
import '../../data/models/path_node.dart';
import 'resources_screen.dart'; // Asegúrate de que esta ruta es correcta

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  // Estructura maestra de la ruta pedagógica definida en tu tesis
  List<PathNode> _getMasterPath() {
    return [
      // Fase 1
      PathNode(
        id: 'conceptos_iniciales',
        title: 'Conceptos Iniciales',
        phase: 1,
        phaseName: 'Fundamentos de Algoritmia',
      ),
      PathNode(
        id: 'caracteristicas_algoritmos',
        title: 'Características',
        phase: 1,
        phaseName: 'Fundamentos de Algoritmia',
      ),
      PathNode(
        id: 'representacion',
        title: 'Representación',
        phase: 1,
        phaseName: 'Fundamentos de Algoritmia',
      ),
      // Fase 2
      PathNode(
        id: 'tipos_datos',
        title: 'Variables y Datos',
        phase: 2,
        phaseName: 'Estructuras Básicas y Metodología',
      ),
      PathNode(
        id: 'operadores',
        title: 'Operadores',
        phase: 2,
        phaseName: 'Estructuras Básicas y Metodología',
      ),
      // Fase 3
      PathNode(
        id: 'expresiones_logicas',
        title: 'Lógica Pura',
        phase: 3,
        phaseName: 'Estructuras de Control de Flujo',
      ),
      PathNode(
        id: 'condicionales',
        title: 'Condicionales',
        phase: 3,
        phaseName: 'Estructuras de Control de Flujo',
      ),
      PathNode(
        id: 'bucles',
        title: 'Bucles',
        phase: 3,
        phaseName: 'Estructuras de Control de Flujo',
      ),
      // Fase 4
      PathNode(
        id: 'objeto_clase',
        title: 'Clases y Objetos',
        phase: 4,
        phaseName: 'Paradigma POO',
      ),
      PathNode(
        id: 'uml_implementacion',
        title: 'Modelación UML',
        phase: 4,
        phaseName: 'Paradigma POO',
      ),
      // Fase 5
      PathNode(
        id: 'herencia_polimorfismo',
        title: 'Herencia',
        phase: 5,
        phaseName: 'Conceptos Avanzados de POO',
      ),
      // Fase 6
      PathNode(
        id: 'interfaces_recursividad',
        title: 'Recursividad',
        phase: 6,
        phaseName: 'Abstracción y Técnicas',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 1. CONEXIÓN BASE DE DATOS: Consumimos el perfil del estudiante desde tu arquitectura Provider
    // Asumiendo que manejas un AuthProvider o RecommendationProvider que tiene el perfil con los temas completados
    // final authProvider = context.watch<AuthProvider>();
    // final completedTopics = authProvider.studentProfile?.completedTopicsList ?? [];

    // Simulación de datos reales basados en el usuario 'drst' que acabamos de inicializar (Ruta en 0)
    final List<String> completedTopicsFromDB = [];
    final String currentActiveTopic =
        'conceptos_iniciales'; // Primer nodo activo

    // 2. Mapeo dinámico del estado de los nodos combinando la estructura estática con la BD
    final List<PathNode> nodes = _getMasterPath();
    bool foundationalPassed = true;

    for (var node in nodes) {
      if (completedTopicsFromDB.contains(node.id)) {
        node.isCompleted = true;
        node.isLocked = false;
        node.isCurrent = false;
      } else if (node.id == currentActiveTopic) {
        node.isCompleted = false;
        node.isLocked = false;
        node.isCurrent = true;
        foundationalPassed =
            false; // Todo lo que venga después de este se queda bloqueado
      } else {
        node.isCompleted = false;
        node.isCurrent = false;
        node.isLocked = !foundationalPassed;
      }
    }

    // Encontrar qué unidad/fase mostrar en el encabezado basándonos en el nodo actual
    final currentNode = nodes.firstWhere(
      (n) => n.isCurrent,
      orElse: () => nodes.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildUnitHeader(currentNode.phase, currentNode.phaseName),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _SinuousLearningPath(nodes: nodes),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitHeader(int phaseNumber, String phaseName) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(
          0xFFF1F3F5,
        ), // Color gris claro idéntico al fondo del contenedor superior de la imagen
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xEFEFEFEF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Unidad $phaseNumber",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            phaseName,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
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
    const double nodeSpacing =
        130.0; // Espaciado vertical optimizado para móviles
    final double totalHeight = nodes.length * nodeSpacing + 140;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Pintor de la línea conectora sinuosa y el grid de fondo
        CustomPaint(
          size: Size(screenWidth, totalHeight),
          painter: PathPainter(nodesCount: nodes.length, spacing: nodeSpacing),
        ),
        // Generador de Nodos Dinámicos
        ...List.generate(nodes.length, (index) {
          final double y = (index * nodeSpacing) + 60;
          // Ecuación matemática senoidal para calcular la coordenada X exacta sobre la línea trazada
          final double x = screenWidth / 2 + math.sin(y / 70) * 65;

          // Define si la etiqueta flotante se renderiza a la izquierda o a la derecha según la curva
          final bool isRightSide = math.cos(y / 70) > 0;

          return Positioned(
            left:
                x -
                125, // Ajuste para centrar el contenedor del nodo de ancho 250
            top: y,
            child: SizedBox(
              width: 250,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isRightSide)
                    _buildLabel(nodes[index].title, nodes[index].isLocked),
                  _buildNodeButton(
                    context,
                    nodes[index],
                  ), // Le pasamos el context de primero
                  if (isRightSide)
                    _buildLabel(nodes[index].title, nodes[index].isLocked),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNodeButton(BuildContext context, PathNode node) {
    // 1. Primero se declaran e inicializan las variables de diseño
    Color backgroundColor = const Color(
      0xFFE2E4E8,
    ); // Gris por defecto (Bloqueado)
    Widget iconChild = const Icon(
      Icons.lock,
      color: Color(0xFF8E94A0),
      size: 26,
    );
    List<BoxShadow> shadows = [];

    // 2. Evaluamos el estado según las reglas de tu tesis
    if (node.isCompleted) {
      backgroundColor = const Color(0xFF0D1B70); // Azul Marino (Completado)
      iconChild = const Icon(Icons.check, color: Colors.white, size: 28);
    } else if (node.isCurrent) {
      backgroundColor = const Color(0xFFFF9100); // Naranja (Nodo Activo)
      iconChild = const Icon(Icons.star, color: Colors.white, size: 30);
      shadows = [
        BoxShadow(
          color: const Color(0xFFFF9100).withValues(alpha: 0.45),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ];
    }

    // 3. Al final, retornamos el árbol de widgets usando las variables de arriba
    return GestureDetector(
      onTap: () {
        if (!node.isLocked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResourceScreen(topicId: node.id),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "⚠️ Este tema está bloqueado hasta completar los anteriores.",
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: backgroundColor, // ✅ Ahora ya no saldrá undefined
          shape: BoxShape.circle,
          boxShadow: shadows,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Center(child: iconChild),
      ),
    );
  }

  Widget _buildLabel(String title, bool isLocked) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: isLocked ? const Color(0xFF9CA3AF) : const Color(0xFF1F2937),
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
    final centerX = size.width / 2;

    // 1. DIBUJAR EL GRID DE PUNTOS DE FONDO (Idéntico a la cuadrícula de la captura)
    final dotPaint = Paint()
      ..color = const Color(0xFFD1D5DB).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    for (double i = 10; i < size.width; i += 18) {
      for (double j = 10; j < size.height; j += 18) {
        canvas.drawCircle(Offset(i, j), 1.2, dotPaint);
      }
    }

    // 2. DIBUJAR EL CAMINO SINUOSO AZUL OSCURO
    final linePaint = Paint()
      ..color =
          const Color(0xFF0D1B70) // Color exacto de la línea guía de tu Mockup
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final path = Path();
    const double startY = 60.0;

    path.moveTo(centerX + math.sin(startY / 70) * 65, startY + 34);

    // Iteración de alta definición para dibujar curvas perfectas sin saltos angulares
    for (double y = startY; y < size.height - 100; y += 1) {
      double x = centerX + math.sin(y / 70) * 65;
      path.lineTo(x, y + 34);
    }
    canvas.drawPath(path, linePaint);

    // 3. INDICADOR ROJO NOTIFICADOR (El punto de alerta sobre la sección activa)
    final notificationDotPaint = Paint()..color = const Color(0xFFDC2626);
    // Posicionado exactamente arriba del tercer nodo (el activo por defecto en la simulación)
    double activeNodeY = (2 * spacing) + 60;
    double activeNodeX = centerX + math.sin(activeNodeY / 70) * 65;
    canvas.drawCircle(
      Offset(activeNodeX, activeNodeY - 2),
      5,
      notificationDotPaint,
    );

    // 4. NODO META FINAL (El círculo verde de cierre de la ruta)
    final endNodePaint = Paint()..color = const Color(0xFF4B6E59);
    final double endY = size.height - 65;
    final double endX = centerX + math.sin(endY / 70) * 65;
    canvas.drawCircle(Offset(endX, endY), 34, endNodePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
