// lib/src/presentation/views/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/profile/attention_required_card.dart';
import '../widgets/profile/badge_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    // Disparamos la consulta al backend al inicializar la pantalla
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _profileFuture = authProvider.fetchStudentProfile();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    // Datos básicos del Login local
    final String username = authProvider.currentUser?.username ?? "Usuario";

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            // 1. Estado de Espera (Cargando datos desde Django)
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF001489)),
                ),
              );
            }

            // 2. Estado de Fallo o datos nulos (Tratamiento offline o error)
            if (snapshot.hasError || snapshot.data == null) {
              return _buildErrorState();
            }

            // 3. Éxito: Mapeo de variables reales desde PostgreSQL
            final profileData = snapshot.data!;
            final double academicRisk = (profileData['academic_risk'] ?? 0.0)
                .toDouble();
            final int completedModules = profileData['completed_modules'] ?? 0;
            final double progressPercentage =
                (profileData['progress_percentage'] ?? 0.0).toDouble();

            // Cálculo dinámico para la barra de XP simulada basada en el progreso real
            final int currentXp = completedModules * 200;
            final double progressValue = progressPercentage / 100.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre extraído directamente del Auth
                  Center(
                    child: Text(
                      "¡Hola, $username!",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Racha fija por el momento
                  _buildStreakChip("5 días"),
                  const SizedBox(height: 28),

                  // Tarjeta de Nivel vinculada a los datos de la BD
                  _buildLevelProgressCard(
                    completedModules,
                    currentXp,
                    progressValue,
                  ),
                  const SizedBox(height: 28),

                  // Lógica Adaptativa: Si el riesgo académico en Django supera 0.3, se despliega la alerta
                  if (academicRisk > 0.3) ...[
                    AttentionRequiredCard(
                      title: "Reforzamiento Requerido",
                      subtitle:
                          "Riesgo detectado: ${(academicRisk * 100).toStringAsFixed(0)}%",
                      onTap: () {
                        debugPrint(
                          "Navegando a la ruta de remediación de la IA",
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                  ],

                  // Sección de Insignias ganadas basadas en tus módulos completados
                  _buildInsigniasSection(completedModules),
                  const SizedBox(height: 36),

                  // Botón de acción
                  _buildSubmitButton(context),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- SUBWIDGETS ADAPTADOS A LOS DATOS ---

  Widget _buildStreakChip(String dias) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE8EAF6),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Color(0xFFFD7E14),
              size: 22,
            ),
            const SizedBox(width: 6),
            Text(
              "Racha de $dias",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F51B5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelProgressCard(int modules, int xp, double progressValue) {
    // Título dinámico del rango según los módulos completados en PostgreSQL
    String rango = "Explorador de Datos";
    if (modules >= 5) rango = "Desarrollador Junior";
    if (modules >= 10) rango = "Arquitecto de Código";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MÓDULOS COMPLETADOS: $modules",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rango,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001489),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE0B2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFFE65100),
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 14,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF66BB6A),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$xp XP acumulados",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),
              Text(
                "${(progressValue * 100).toStringAsFixed(0)}% Completado",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsigniasSection(int modules) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Tus Insignias",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Ver todas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001489),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const BadgeItem(
              label: "Primer Código",
              assetPath: "assets/images/badges/badge1.png",
            ),
            // Desbloqueado dinámicamente si completó al menos un módulo
            BadgeItem(
              label: "Lógica Pura",
              assetPath: "assets/images/badges/badge2.png",
              isLocked: modules < 1,
            ),
            // Desbloqueado dinámicamente si completó más de 4 módulos
            BadgeItem(
              label: "Maestro Python",
              assetPath: "assets/images/badges/badge3.png",
              isLocked: modules < 4,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF8F00),
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Continuar Aprendiendo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "Error de conexión local",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "No pudimos sincronizar tus métricas con el servidor de la UCI.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() {
                _profileFuture = context
                    .read<AuthProvider>()
                    .fetchStudentProfile();
              }),
              child: const Text("Reintentar"),
            ),
          ],
        ),
      ),
    );
  }
}
