import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'dashboard_view.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false; // New state to show a spinner while checking DB

  void _showLoginPopup(BuildContext context) {
    _codeController.clear();
    _passwordController.clear();
    _errorMessage = '';
    _isLoading = false;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) {
        // StatefulBuilder allows us to update the UI *inside* the popup
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0D1117),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, 
                side: BorderSide(color: Color(0xFF00E5FF), width: 1), 
              ),
              title: const Text(
                "W.I.N.T.E.R. AUTHENTICATION",
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.redAccent, 
                          fontFamily: 'monospace',
                          fontSize: 12
                        ),
                      ),
                    ),
                  
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(color: Colors.cyanAccent),
                    )
                  else ...[
                    // INPUT: ACCESS CODE
                    TextField(
                      controller: _codeController,
                      style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                      decoration: const InputDecoration(
                        labelText: "ACCESS CODE",
                        labelStyle: TextStyle(color: Colors.cyanAccent),
                      ),
                      autofocus: true,
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // INPUT: PASSWORD
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                      decoration: const InputDecoration(
                        labelText: "PASSWORD",
                        labelStyle: TextStyle(color: Colors.cyanAccent),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                if (!_isLoading) ...[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("ABORT", style: TextStyle(fontFamily: 'monospace', color: Colors.grey)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                      foregroundColor: Colors.cyanAccent,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      side: const BorderSide(color: Colors.cyanAccent),
                    ),
                    onPressed: () => _attemptLogin(context, setState),
                    child: const Text("INITIALIZE", style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                  ),
                ]
              ],
            );
          },
        );
      },
    );
  }

  // UPDATED: Now supports Async Login (waiting for Firebase)
  Future<void> _attemptLogin(BuildContext context, StateSetter setState) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    // 1. Show Loading Indicator inside popup
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    // 2. Wait for Firebase to check credentials
    bool success = await authService.login(
      _codeController.text.trim(), 
      _passwordController.text.trim()
    );

    // 3. Handle Result
    if (!mounted) return; // Safety check: is the screen still there?

    if (success) {
      Navigator.pop(context); // Close popup
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const DashboardView())
      );
    } else {
      // Show error inside popup
      setState(() {
        _isLoading = false;
        _errorMessage = "ACCESS DENIED: INVALID CREDENTIALS";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The "Void" Gradient Background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF020406), // Void Black
              Color(0xFF0A0E14), // Metallic Dark Grey
              Color(0xFF0F0B18), // Subtle Purple Tint
            ],
          ),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showLoginPopup(context),
          child: Focus(
            autofocus: true,
            onKeyEvent: (node, event) {
               if (event is KeyDownEvent) { 
                 _showLoginPopup(context);
               }
              return KeyEventResult.handled;
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  // --- LOGO BLENDING ---
                  // Uses 'Screen' mode to hide the black background of the image
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.black, 
                      BlendMode.screen, 
                    ),
                    child: Image.asset(
                      'assets/winter_logo.png',
                      width: 350,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // --- ANIMATED PROMPT ---
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: const Text(
                          "APERTE QUALQUER TECLA PARA CONTINUAR...",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12, 
                            color: Colors.cyanAccent,
                            letterSpacing: 2
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}