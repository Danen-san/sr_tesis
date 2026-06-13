// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import 'src/core/network/api_client.dart';
import 'src/presentation/providers/auth_provider.dart';
import 'src/presentation/providers/recommendation_provider.dart';
import 'src/presentation/providers/onboarding_provider.dart';
import 'src/presentation/views/splash_screen.dart';
import 'src/core/storage/hive_storage_repository.dart';

void main() async {
  // Inicializa los bindings nativos indispensables antes de la UI
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa tu repositorio de Hive adaptado
  final storage = HiveStorageRepository();
  await storage.initStorage();

  // Precarga de la caja de preferencias globales en memoria
  await Hive.openBox('user_preferences');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(create: (_) => ApiClient()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProxyProvider<ApiClient, AuthProvider>(
          create: (context) =>
              AuthProvider(apiClient: context.read<ApiClient>()),
          update: (_, apiClient, authProvider) =>
              authProvider ?? AuthProvider(apiClient: apiClient),
        ),
        ChangeNotifierProxyProvider<ApiClient, RecommendationProvider>(
          create: (context) =>
              RecommendationProvider(apiClient: context.read<ApiClient>()),
          update: (_, apiClient, recProvider) =>
              recProvider ?? RecommendationProvider(apiClient: apiClient),
        ),
      ],
      child: MaterialApp(
        title: 'EduCode AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0B1F8F),
            brightness: Brightness.light,
          ),
        ),
        home: const SplashScreen(), // Punto de arranque obligatorio
      ),
    );
  }
}
