// lib/src/presentation/views/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import '../providers/auth_provider.dart';
import 'first_time/welcome_screen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Ejecutamos la verificación después del primer renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ejecutarEnrutamientoContextual();
    });
  }

  Future<void> _ejecutarEnrutamientoContextual() async {
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    debugPrint("--- [SPLASH] INICIANDO VERIFICACIÓN DE CONTEXTO ---");

    // 1. Forzar la lectura de la base de datos local SQLite
    bool tieneSesionLocal = await authProvider.checkLocalSession();
    debugPrint("[SPLASH] ¿Tiene sesión activa en SQLite?: $tieneSesionLocal");

    // 2. Tomar decisión basada estrictamente en la existencia del usuario
    if (tieneSesionLocal && authProvider.isAuthenticated) {
      debugPrint(
        "[SPLASH] Usuario Autenticado. Evaluando estado de Onboarding...",
      );

      try {
        final Box box = await Hive.openBox('user_preferences');
        bool esPrimeraVez = box.get('is_first_time', defaultValue: true);
        debugPrint("[SPLASH] Valor de 'is_first_time' en Hive: $esPrimeraVez");

        if (esPrimeraVez) {
          debugPrint("[SPLASH] Enrutando hacia -> WelcomeScreen (Onboarding)");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          );
        } else {
          debugPrint("[SPLASH] Enrutando hacia -> DashboardScreen (Home)");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      } catch (e) {
        debugPrint(
          "[SPLASH] Error al leer Hive: $e. Enviando a Dashboard por seguridad.",
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } else {
      // Si no hay sesión local (el flag es false), va directo al login
      debugPrint(
        "[SPLASH] No se detectó sesión activa. Enrutando hacia -> LoginScreen",
      );
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1F8F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.terminal_rounded,
                size: 72,
                color: Color(0xFF0B1F8F),
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
