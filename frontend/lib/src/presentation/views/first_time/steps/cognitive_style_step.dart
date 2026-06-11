import 'package:flutter/material.dart';

class KnowledgeLevelStep extends StatelessWidget {
  final VoidCallback onNext;
  KnowledgeLevelStep({required this.onNext});

  final List<String> topics = ["Variables", "Bucles", "Matrices", "Funciones"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (_, i) => ExpansionTile(
          title: Text(topics[i]),
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              FilterChip(label: Text("Básico"), onSelected: (_){}),
              FilterChip(label: Text("Intermedio"), onSelected: (_){}),
              FilterChip(label: Text("Avanzado"), onSelected: (_){}),
            ])
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(onPressed: onNext, child: Text("Continuar")),
    );
  }
}