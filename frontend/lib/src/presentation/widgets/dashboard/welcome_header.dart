// lib/src/presentation/widgets/dashboard/welcome_header.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../providers/recommendation_provider.dart';

class WelcomeHeader extends StatelessWidget {
  final String name;
  const WelcomeHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<RecommendationProvider>().progressPercentage;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          CrossAxisAlignment.start, // Alinea arriba para mejor flujo visual
      children: [
        // El Expanded obliga a la columna de texto a ocupar solo el espacio disponible
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenido de nuevo,',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                'Hola de nuevo, $name',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navyBlue,
                ),
                maxLines: 1, // Evita que nombres largos rompan el diseño
                overflow: TextOverflow.ellipsis, // Si no cabe, añade '...'
              ),
              const SizedBox(height: 12),

              // Contenedor de Racha adaptativo
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize
                          .min, // Ocupa solo el espacio de su contenido interno
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: AppColors.primaryOrange,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '5 días seguidos',
                          style: TextStyle(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 65,
              width: 65,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                color: AppColors.successGreen,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(progress * 100).toInt()}%', // <--- AQUÍ SE MUESTRA EL PORCENTAJE REAL
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  'META',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
