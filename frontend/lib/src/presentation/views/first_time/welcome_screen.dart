import 'package:flutter/material.dart';
import 'onboarding_flow.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001489),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.terminal_rounded, size: 72, color: Color(0xFF001489)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "EduCode AI",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 48),
              const Text(
                "Programación Inteligente",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                "Tu camino al éxito adaptado por IA",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFD7E14),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingFlow()));
                },
                child: const Text(
                  "CREAR MI PERFIL →",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Al continuar, aceptas nuestros términos de servicio",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white38),
              )
            ],
          ),
        ),
      ),
    );
  }
}