import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// Asegúrate de importar tu Provider
import '../../providers/onboarding_provider.dart'; 

class LoadingAiScreen extends StatefulWidget {
  @override
  _LoadingAiScreenState createState() => _LoadingAiScreenState();
}

class _LoadingAiScreenState extends State<LoadingAiScreen> {
  
  @override
  void initState() {
    super.initState();
    _enviarDiagnosticoAlBackend();
  }

  Future<void> _enviarDiagnosticoAlBackend() async {
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    
    // URL de tu servidor (usa 10.0.2.2 si estás en emulador de Android)
    final url = Uri.parse('http://10.0.2.2:8000/api/recommendation/diagnostico/');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'cognitive_style': provider.cognitiveStyle,
          'knowledge_levels': provider.knowledgeLevels,
          'interests': provider.selectedTopics,
        }),
      );

      if (response.statusCode == 200) {
        // Éxito: Navegar al Dashboard principal
        debugPrint("Diagnóstico enviado correctamente");
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainDashboard()));
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error de conexión: $e");
      // Aquí podrías mostrar un SnackBar de error o reintentar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFFFD7E14))),
            SizedBox(height: 20),
            Text("Analizando tu perfil cognitivo...", style: TextStyle(fontSize: 18)),
            Text("Optimizando módulos de aprendizaje...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}