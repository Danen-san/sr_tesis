import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/onboarding_provider.dart';

class KnowledgeLevelStep extends StatelessWidget {
  final VoidCallback onNext;
  const KnowledgeLevelStep({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);
    final List<String> temas = ['Variables', 'Bucles', 'Matrices', 'Funciones'];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Tu nivel actual", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Marca los temas que ya dominas o conoces", style: TextStyle(fontSize: 15, color: Colors.black54)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: temas.length,
              itemBuilder: (context, index) {
                String tema = temas[index];
                return _buildTemaSelector(provider, tema);
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFD7E14),
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            onPressed: onNext,
            child: const Text("CONTINUAR", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTemaSelector(OnboardingProvider provider, String tema) {
    String nivelActual = provider.nivelesDominio[tema] ?? 'Básico';
    List<String> niveles = ['Básico', 'Intermedio', 'Avanzado'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tema, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF001489))),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: niveles.map((nivel) {
              bool isSelected = nivelActual == nivel;
              return ChoiceChip(
                label: Text(nivel),
                selected: isSelected,
                selectedColor: _getNivelColor(nivel),
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                onSelected: (bool selected) {
                  if (selected) provider.setNivelDominio(tema, nivel);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getNivelColor(String nivel) {
    if (nivel == 'Básico') return Colors.green;
    if (nivel == 'Intermedio') return Colors.orange;
    return Colors.red;
  }
}