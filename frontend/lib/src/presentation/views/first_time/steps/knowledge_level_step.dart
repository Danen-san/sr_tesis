import 'package:flutter/material.dart';

class KnowledgeLevelStep extends StatelessWidget {
  final VoidCallback onNext;
  KnowledgeLevelStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tu nivel actual"), elevation: 0),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Aquí irían tus widgets de Selección (Básico/Intermedio/Avanzado)
            Text("Marca los temas que ya dominas"),
            // ... (Tu implementación de tarjetas con botones de estado)
            Spacer(),
            ElevatedButton(onPressed: onNext, child: Text("Continuar")),
          ],
        ),
      ),
    );
  }
}