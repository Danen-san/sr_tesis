import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../providers/recommendation_provider.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryOrange,
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: Colors.white,
        elevation: 12,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded),
            label: 'Aprender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Progreso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_off_rounded),
            label: 'Offline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
