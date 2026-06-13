import 'package:flutter/material.dart';

// Modelo local para tipar la respuesta de la base de datos
class LearningResource {
  final String title;
  final String description;
  final String type;
  final String filePath;
  final String? url;

  LearningResource({
    required this.title,
    required this.description,
    required this.type,
    required this.filePath,
    this.url,
  });
}

class ResourceScreen extends StatelessWidget {
  final String topicId;

  const ResourceScreen({super.key, required this.topicId});

  // Simulador de consulta a la Base de Datos (PostgreSQL mediante tu API o caché local SQLite)
  // Aquí se filtran los materiales usando el topicId recibido
  List<LearningResource> _fetchResourcesFromDB(String topic) {
    // Datos reales inyectados previamente en tu script backend
    final allResources = [
      LearningResource(
        title: 'Conceptos iniciales de programación',
        description:
            'Documento con explicación de los conceptos iniciales que todo programador debe conocer. De la idea a la máquina.',
        type: 'PDF',
        filePath:
            'resources/conferencias/Conceptos iniciales de programacion-De la idea a la maquina.pdf',
      ),
      LearningResource(
        title: 'Cómo dar instrucciones precisas al ordenador',
        description:
            'Audio explicativo diseñado para estudiantes con estilo de aprendizaje auditivo.',
        type: 'AUDIO',
        filePath:
            'resources/audios/Cómo_dar_instrucciones_precisas_al_ordenador.m4a',
      ),
      LearningResource(
        title: 'Lógica Algorítmica Avanzada',
        description:
            'Domina los bucles anidados y las condicionales complejas para optimizar el flujo de tus algoritmos.',
        type: 'VIDEO',
        filePath: 'resources/videos/Lógica_algorítmica.mp4',
      ),
    ];

    // En producción: return provider.getResourcesByTopic(topic);
    // Para esta prueba, si el usuario pulsa en un tema relacionado, destacamos el material de video/audio correspondiente
    return allResources;
  }

  @override
  Widget build(BuildContext context) {
    final resources = _fetchResourcesFromDB(topicId);

    // Tomamos el primer recurso disponible para la sección destacada superior
    // Si el usuario viene de un tema avanzado, usará el video correspondiente
    final destacado = resources.firstWhere(
      (r) => r.type == 'VIDEO',
      orElse: () => resources.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        // Removidos AppBar y BottomNavigationBar según las directrices estéticas solicitadas
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildTopNavigationRow(context),
              const SizedBox(height: 20),
              _buildMainTitle(destacado.title, destacado.description),
              const SizedBox(height: 20),
              _buildVideoPlayerMock(destacado),
              const SizedBox(height: 16),
              _buildPerformanceCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Fila superior con el botón de retorno y la etiqueta de estado de red
  Widget _buildTopNavigationRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: const [
                Icon(Icons.arrow_back, color: Color(0xFF4B5563), size: 22),
                SizedBox(width: 8),
                Text(
                  "Volver a la Ruta",
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Indicador de modo sin conexión idéntico a la referencia
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.cloud_off, color: Color(0xFF991B1B), size: 16),
                SizedBox(width: 6),
                Text(
                  "MODO OFFLINE ACTIVO",
                  style: TextStyle(
                    color: Color(0xFF991B1B),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTitle(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Contenedor del reproductor multimedia con la estética exacta de la imagen
  Widget _buildVideoPlayerMock(LearningResource recurso) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Área del Frame de Video/Miniatura
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                ),
                child: Container(
                  height: 210,
                  width: double.infinity,
                  color: const Color(
                    0xFF1F2937,
                  ), // Fondo oscuro representativo del IDE
                  child: Center(
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(
                        recurso.type == 'AUDIO' ? Icons.audiotrack : Icons.code,
                        size: 140,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // Botón de reproducción flotante naranja
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9100),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ],
          ),
          // Barra de herramientas inferior del reproductor
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.save_alt, color: Color(0xFF4B5563), size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Guardado localmente (Alta calidad)",
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // Botón de acceso a las transcripciones generadas por la IA
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    "Transcripción",
                    style: TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta informativa de analítica de aprendizaje (Sección Ritmo Óptimo)
  Widget _buildPerformanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(
          0xFF1E3A8A,
        ), // Azul oscuro institucional idéntico a tu mockup de progreso
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.flash_on, color: Color(0xFF4ADE80), size: 24),
              SizedBox(width: 8),
              Text(
                "Ritmo Óptimo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Has completado los últimos 3 módulos más rápido que el promedio. Te sugerimos realizar el ejercicio de código a continuación para consolidar.",
            style: TextStyle(
              color: Color(0xFF93C5FD),
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Progreso de Sesión",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "75%",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Barra de progreso interna lineal
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.75,
              backgroundColor: Color(0xFF172554),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ADE80)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
