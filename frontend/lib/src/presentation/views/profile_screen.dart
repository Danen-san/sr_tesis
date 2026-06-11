import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/profile/cognitive_chart.dart';
import '../widgets/profile/badge_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            color: AppColors.navyBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header: Foto con Nivel
            _buildProfileHeader(),
            const SizedBox(height: 20),

            // Barra de Progreso XP
            _buildXpSection(),
            const SizedBox(height: 30),

            // Perfil Cognitivo
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Perfil Cognitivo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const CognitiveChart(),

            const SizedBox(height: 30),

            // Insignias
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Insignias',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                BadgeItem(
                  label: 'Racha',
                  color: AppColors.successGreen,
                  icon: Icons.bolt,
                ),
                BadgeItem(
                  label: 'Debugger',
                  color: AppColors.primaryOrange,
                  icon: Icons.bug_report,
                ),
                BadgeItem(
                  label: 'Top #1',
                  color: AppColors.navyBlue,
                  icon: Icons.emoji_events,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile/avatar.png'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'LVL 12',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Text(
          'Mateo Fernández',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Estudiante de Ingeniería',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildXpSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [Text('850 XP'), Text('1000 XP')],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 0.85,
          color: AppColors.successGreen,
          backgroundColor: Colors.grey.shade200,
        ),
      ],
    );
  }
}
