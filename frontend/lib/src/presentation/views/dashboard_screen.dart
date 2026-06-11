import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../providers/recommendation_provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Lista de las pantallas que conforman la navegación principal
  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(
      child: Text(
        "Pantalla de Progreso en construcción",
        style: TextStyle(
          fontSize: 18,
          color: AppColors.navyBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    const Center(
      child: Text(
        "Modo Offline en construcción",
        style: TextStyle(
          fontSize: 18,
          color: AppColors.navyBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Cargamos las recomendaciones y el perfil desde la API al montar el contenedor principal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecommendationProvider>().fetchRecommendations();
      context.read<RecommendationProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Color de fondo base de la aplicación
      body: SafeArea(
        // IndexedStack evita que las pantallas se reconstruyan al cambiar de pestaña
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actionsIconTheme: const IconThemeData(color: AppColors.navyBlue),

        leading: IconButton(
          onPressed: () => setState(() => _selectedIndex = 3),
          icon: Icon(Icons.person, color: AppColors.navyBlue),
        ),
        title: const Text(
          "EduCode AI",
          style: TextStyle(
            color: AppColors.navyBlue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      /* Acción de notificaciones */
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.navyBlue,
                      size: 28,
                    ),
                  ),
                  // Badge pequeño de notificación
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.navyBlue,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryOrange, // Naranja de tu diseño
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 0, // Quitamos la sombra nativa para usar la del contenedor
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline_rounded),
              label: 'Ruta',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_rounded),
              label: 'Recursos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
