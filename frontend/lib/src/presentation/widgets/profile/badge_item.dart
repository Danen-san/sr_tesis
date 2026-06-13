// lib/src/presentation/widgets/profile/badge_item.dart
import 'package:flutter/material.dart';

class BadgeItem extends StatelessWidget {
  final String label;
  final String assetPath;
  final bool isLocked;

  const BadgeItem({
    Key? key,
    required this.label,
    required this.assetPath,
    this.isLocked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isLocked
                  ? const Color(0xFFE0E0E0)
                  : const Color(0xFFB3E5FC),
              width: 3,
            ),
            color: isLocked ? const Color(0xFFF5F5F5) : Colors.white,
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLocked
                  ? const Color(0xFFE0E0E0)
                  : const Color(0xFF0A192F),
            ),
            clipBehavior: Clip.antiAlias,
            child: isLocked
                ? const Icon(Icons.lock_outline, color: Colors.orange, size: 36)
                : Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                  ), // Carga tus renders 2.5D aquí
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 80,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isLocked ? Colors.grey : const Color(0xFF2D3748),
            ),
          ),
        ),
      ],
    );
  }
}
