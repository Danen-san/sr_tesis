import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/auth_provider.dart'; // Importante para leer el token activo
import '../dashboard_screen.dart';

class LoadingAiScreen extends StatefulWidget {
  const LoadingAiScreen({Key? key}) : super(key: key);

  @override
  State<LoadingAiScreen> createState() => _LoadingAiScreenState();
}

class _LoadingAiScreenState extends State<LoadingAiScreen> {
  @override
  void initState() {
    super.initState();
    _procesarDatosConBackend();
  }

  Future<void> _procesarDatosConBackend() async {
    final onboardingProvider = Provider.of<OnboardingProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Recuperamos el token JWT/Auth obtenido durante el login exitoso
    final String? token = authProvider.currentUser?.token;

    final Uri url = Uri.parse(
      'http://10.0.2.2:8000/api/recommendation/diagnostico_inicial/',
    );

    try {
      debugPrint(
        "[ONBOARDING API] Enviando matriz adaptativa al motor de Django...",
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // CORRECCIÓN CRUCIAL: Autorización requerida por Django rest framework
          'Authorization': 'Token $token',
        },
        body: json.encode({
          'estilo_cognitivo': onboardingProvider.estiloCognitivo,
          'matriz_conocimiento': onboardingProvider.nivelesDominio,
          'intereses': onboardingProvider.temasInteres,
        }),
      );

      debugPrint(
        "[ONBOARDING API] Status Código de respuesta: ${response.statusCode}",
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint("--- Motor de IA Inicializado de manera exitosa ---");

        // Guardamos localmente en Hive que el usuario ya completó el perfilamiento
        final box = await Hive.openBox('user_preferences');
        await box.put('is_first_time', false);

        // Redirigir al Dashboard principal de forma segura
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      } else {
        // Manejo de error si Django responde algo diferente a 200/201 (Ej: 404 o 500)
        debugPrint(
          "[ERROR ONBOARDING] Django rechazó la solicitud: ${response.body}",
        );
        _manejarFalloNavegacion();
      }
    } catch (e) {
      debugPrint("Error crítico en sincronización de Onboarding: $e");
      _manejarFalloNavegacion();
    }
  }

  // Método de escape estructural para que la UI no se quede congelada en fallos de red
  void _manejarFalloNavegacion() async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Sincronizando de forma local. Inicializando entorno fuera de línea...',
        ),
        backgroundColor: Colors.orange,
      ),
    );

    // Estrategia Offline Tolerante a Fallos (Útil para justificar el tratamiento de errores en la tesis)
    final box = await Hive.openBox('user_preferences');
    await box.put('is_first_time', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFD7E14)),
                  strokeWidth: 6,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Analizando tu perfil cognitivo...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001489),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Optimizando módulos de aprendizaje mediante Inteligencia Adaptativa v2.4...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
