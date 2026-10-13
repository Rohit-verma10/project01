import 'package:flutter/material.dart';

import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/farm_registration/farm_registration_screen.dart'; 
import 'screens/weather/weather_screen.dart';
import 'screens/disease/disease_detection_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/yield_prediction/yield_prediction_screen.dart';
import 'screens/news/news_screen.dart';
import 'screens/assistant/assistant_screen.dart';
import 'services/storage_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();

  runApp(const AgriVisionAI());
}

class AgriVisionAI extends StatelessWidget {
  const AgriVisionAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriVision AI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D4F),
          brightness: Brightness.light,
          surface: const Color(0xFFFCFDF9),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7F1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7F1),
          foregroundColor: Color(0xFF173D2A),
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF173D2A),
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFCFDF9),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFDDE5DA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFDDE5DA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF2E7D4F), width: 1.6),
          ),
          prefixIconColor: const Color(0xFF5C8064),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D4F),
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 52),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFCFDF9),
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      home: StorageService.getLogin()
    ? const DashboardScreen()
    : const LoginScreen(),

     routes: {
  
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/Farm Registration': (context) => const FarmRegistrationScreen(),
  '/weather': (context) => const WeatherScreen(),
  '/disease': (context) => const DiseaseDetectionScreen(),
  '/reports': (context) => const ReportsScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/yield': (context) => const YieldPredictionScreen(),
  '/news': (context) => const NewsScreen(),
  '/assistant': (context) => const AssistantScreen(),
},
    );
  }
}
