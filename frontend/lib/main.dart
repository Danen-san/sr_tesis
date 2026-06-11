// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/core/network/api_client.dart';
import 'src/presentation/providers/auth_provider.dart';
import 'src/presentation/providers/recommendation_provider.dart';
import 'src/presentation/views/splash_screen.dart';
import 'src/core/storage/hive_storage_repository.dart';

void main() async {
  // LÍNEA CRUCIAL: Inicializa los servicios nativos de Android (como SQLite) antes de levantar la UI
  WidgetsFlutterBinding.ensureInitialized();

  final storage = HiveStorageRepository();
  await storage.initStorage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(create: (_) => ApiClient()),
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
        title: 'SR Tesis',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0B1F8F),
            brightness: Brightness.light,
          ),
        ),
        home: const SplashScreen(), // Arranca desde el Splash seguro
      ),
    );
  }
}
