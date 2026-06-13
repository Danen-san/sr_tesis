import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../providers/onboarding_provider.dart';

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
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    
    // Cambiar la IP por tu host de producción o el túnel local de desarrollo de la UCI
    final Uri url = Uri.parse('http://10.0.2.2:8000/api/recommendation/diagnostico_inicial/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'estilo_cognitivo': provider.estiloCognitivo,
          'matriz_conocimiento': provider.nivelesDominio,
          'intereses': provider.temasInteres,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint("Motor de IA Inicializado de manera exitosa.");
        // Aquí rediriges a la pantalla principal de tu app ya cargada:
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationHub()));
      } else {
        throw Exception("Respuesta inesperada del servidor: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error crítico en sincronización de Onboarding: $e");
      // Tratamiento de fallos o estrategia offline alternativo si es requerido
    }
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF001489)),
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