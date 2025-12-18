import 'package:flutter/material.dart';

class WinterUI {
  // Ordo Adamas Color Palette
  static const Color primaryBlue = Color(0xFF42A5F5);
  static const Color accentPurple = Color(0xFFAB47BC);
  static const Color terminalBlack = Color(0xFF05070A);
  static const Color panelGrey = Color(0xFF0D1117);

  /// A frame that adds a "Crystalline" border to any widget, 
  /// representing the Adamas (Diamond) strength.
  static Widget crystalFrame({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: panelGrey,
        border: Border.all(color: primaryBlue.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: child,
    );
  }

  /// The standard terminal-style text for data readouts
  static TextStyle terminalText({double size = 12, Color color = Colors.white70}) {
    return TextStyle(
      fontFamily: 'Courier',
      fontSize: size,
      color: color,
      letterSpacing: 1.2,
    );
  }

  /// A status header used to show current node connection 
  /// (e.g., Blumenau Bunker or St. Killian Cathedral).
  static Widget nodeStatusHeader({required String location}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: primaryBlue.withOpacity(0.1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lan, size: 14, color: primaryBlue),
          const SizedBox(width: 8),
          Text(
            "CONNECTED: ${location.toUpperCase()}",
            style: terminalText(size: 10, color: primaryBlue),
          ),
        ],
      ),
    );
  }

  /// A custom button for the Control Center
  static Widget controlButton({
    required String label, 
    required VoidCallback onTap, 
    IconData? icon
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white12),
          gradient: LinearGradient(
            colors: [panelGrey, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 10)],
            Text(label, style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}