import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // REQUIRED
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'views/landing_page.dart';
import 'firebase_options.dart'; // Created by "flutterfire configure"

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const WinterSystem(),
    ),
  );
}

class WinterSystem extends StatelessWidget {
  const WinterSystem({super.key});

  // THEME COLORS
  static const Color _iceCyan = Color(0xFF00E5FF);
  static const Color _neonPurple = Color(0xFFD500F9);
  static const Color _shieldGrey = Color(0xFF1C222B);
  static const Color _voidBlack = Color(0xFF05070A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'W.I.N.T.E.R.',
      debugShowCheckedModeBanner: false,
      
      // GLOBAL THEME CONFIGURATION
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        primaryColor: _iceCyan,
        scaffoldBackgroundColor: _voidBlack,
        fontFamily: 'monospace', // The Hacker Font
        
        colorScheme: const ColorScheme.dark(
          primary: _iceCyan,
          secondary: _neonPurple,
          surface: _shieldGrey,
          onSurface: Colors.white,
          error: Colors.redAccent,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: _voidBlack,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: _iceCyan),
          titleTextStyle: TextStyle(
            fontFamily: 'monospace',
            color: Colors.white,
            fontSize: 18, 
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
          shape: Border(bottom: BorderSide(color: _iceCyan, width: 1)),
        ),

        // Default input decoration for all forms
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _shieldGrey,
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: _iceCyan.withOpacity(0.3)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: _neonPurple, width: 2),
          ),
        ),
      ),
      home: const LandingPage(),
    );
  }
}