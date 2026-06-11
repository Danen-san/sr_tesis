// lib/src/presentation/views/lesson_view_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/recommendation_model.dart';
import '../providers/recommendation_provider.dart';

class LessonViewScreen extends StatefulWidget {
  final RecommendationModel recommendation;

  const LessonViewScreen({super.key, required this.recommendation});

  @override
  State<LessonViewScreen> createState() => _LessonViewScreenState();
}

class _LessonViewScreenState extends State<LessonViewScreen> {
  bool _isSubmitting = false;

  void _onComplete() async {
    setState(() => _isSubmitting = true);

    final success = await context.read<RecommendationProvider>().completeLesson(
      widget.recommendation.id,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '¡Lección completada con éxito! Tu perfil IA ha sido actualizado.',
            ),
            backgroundColor: AppColors.successGreen,
          ),
        );
        Navigator.of(context).pop(); // Regresa al Dashboard automáticamente
      } else {
        final error = context.read<RecommendationProvider>().errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Error al registrar el progreso.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lo = widget.recommendation.learningObject;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          lo.topic.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  // <-- Añadimos esta columna que faltaba para agrupar los hijos
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lo.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.navyBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            lo.difficulty.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.navyBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.psychology_rounded,
                          size: 16,
                          color: AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Confianza IA: ${(widget.recommendation.confidenceScore * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Divider(color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),
                    Text(
                      lo.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textDark,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
