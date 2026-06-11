import 'package:flutter/material.dart';
import 'onboarding_flow.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001489),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.terminal, size: 100, color: Colors.white),
            Text("EduCode AI", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.all(20), child: Text("Tu camino al éxito adaptado por IA", style: TextStyle(color: Colors.white70))),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OnboardingFlow())),
              child: Text("CREAR MI PERFIL"),
            )
          ],
        ),
      ),
    );
  }
}