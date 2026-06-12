import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/onboarding_provider.dart';
import '../loading_ai_screen.dart';

class InterestTopicsStep extends StatelessWidget {
  const InterestTopicsStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);
    final List<String> intereses = ['#Lógica', '#Python', '#Algoritmos', '#Estructuras', '#Optimización', '#BasesDeDatos', '#WebDev'];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("¿Qué quieres lograr hoy?", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Selecciona los temas que más te interesan para personalizar tu experiencia.", style: TextStyle(fontSize: 15, color: Colors.black54)),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: intereses.map((tema) {
              bool isSelected = provider.temasInteres.contains(tema);
              return FilterChip(
                label: Text(tema, style: TextStyle(fontSize: 15, color: isSelected ? Colors.white : Colors.black87)),
                selected: isSelected,
                selectedColor: const Color(0xFF001489),
                checkmarkColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onSelected: (_) => provider.toggleTemaInteres(tema),
              );
            }).toList(),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFD7E14),
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            onPressed: provider.temasInteres.isNotEmpty
                ? () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoadingAiScreen()),
                      (route) => false,
                    )
                : null,
            child: const Text("GENERAR RUTA PERSONALIZADA ✨", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}