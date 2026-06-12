import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/onboarding_provider.dart';

class CognitiveStyleStep extends StatelessWidget {
  final VoidCallback onNext;
  const CognitiveStyleStep({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "¿Cómo prefieres aprender?",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          const Text(
            "Personalizaremos tu ruta de aprendizaje basada en tu estilo cognitivo dominante.",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 32),
          _buildStyleCard(context, provider, "Visual", "Prefiero videos y diagramas", Icons.auto_graph_rounded),
          const SizedBox(height: 16),
          _buildStyleCard(context, provider, "Lectura", "Prefiero guías y documentación", Icons.menu_book_rounded),
          const SizedBox(height: 16),
          _buildStyleCard(context, provider, "Práctico", "Prefiero escribir código", Icons.terminal_rounded),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFD7E14),
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            onPressed: provider.estiloCognitivo.isNotEmpty ? onNext : null,
            child: const Text("SIGUIENTE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleCard(BuildContext context, OnboardingProvider provider, String value, String description, IconData icon) {
    bool isSelected = provider.estiloCognitivo == value;
    return GestureDetector(
      onTap: () => provider.setEstiloCognitivo(value),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF001489) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isSelected ? const Color(0xFF001489) : const Color(0xFFF1F3F5),
              child: Icon(icon, color: isSelected ? Colors.white : const Color(0xFF495057)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF001489))),
                  Text(description, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: Color(0xFF001489))
          ],
        ),
      ),
    );
  }
}