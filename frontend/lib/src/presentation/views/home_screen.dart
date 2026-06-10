import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/recommendation_provider.dart';
import '../widgets/dashboard/welcome_header.dart';
import '../widgets/dashboard/lesson_card.dart';
import 'login_screen.dart';
import 'lesson_view_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;
    final recProvider = context.watch<RecommendationProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header superior: Logo, Badge de base de datos y Botón de Logout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/logo_edu.png',
                height: 30,
                errorBuilder: (_, __, ___) => const Text(
                  'Educode AI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.navyBlue,
                  ),
                ),
              ),
              const _HiveBadge(),
              IconButton(
                icon: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.navyBlue,
                ),
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Widget dinámico con el progreso real
          WelcomeHeader(name: user?.username ?? 'Mateo'),

          const SizedBox(height: 40),

          // Título de sección de aprendizaje
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Continuar aprendiendo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navyBlue,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Ver todo',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Lista de lecciones conectada al motor de IA en Django
          if (recProvider.isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange),
            )
          else
            ...recProvider.recommendations.map(
              (rec) => LessonCard(
                title: rec.learningObject.title,
                level: rec.learningObject.difficulty,
                duration: '15 MIN',
                imagePath: rec.learningObject.difficulty == 'hard'
                    ? 'assets/images/lessons/lesson_arrays.png'
                    : 'assets/images/lessons/lesson_for.png',
                buttonText: rec.learningObject.difficulty == 'hard'
                    ? 'Continuar'
                    : 'Iniciar Lección',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LessonViewScreen(recommendation: rec),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 24),

          // Tip del día
          const _TipCard(),
        ],
      ),
    );
  }
}

// Widgets privados encapsulados
class _HiveBadge extends StatelessWidget {
  const _HiveBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 14),
          SizedBox(width: 4),
          Text(
            'Hive OK',
            style: TextStyle(
              color: Colors.green,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: AppColors.primaryOrange, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tip de hoy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.navyBlue,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Las matrices te permiten organizar datos de forma eficiente en memoria. Úsalas para iterar con bucles for.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
