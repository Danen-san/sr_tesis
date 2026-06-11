// lib/src/presentation/views/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  void _initApp() async {
    // Esperamos un instante simulado para que la animación fluya
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // Leemos la sesión local de SQLite
    final hasSession = await context.read<AuthProvider>().checkLocalSession();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              hasSession ? const DashboardScreen() : const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.navyBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology, size: 80, color: Colors.white),
            SizedBox(height: 24),
            CircularProgressIndicator(color: AppColors.primaryOrange),
          ],
        ),
      ),
    );
  }
}
