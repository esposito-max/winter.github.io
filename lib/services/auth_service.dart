import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define the clearance levels
enum ClearanceLevel {
  none,   // Not logged in
  level1, // Agents (View Missions, Reports)
  level2, // Directors (View Occult DB, Sensitive Info)
  level0  // Command/Ricci (Edit Everything)
}

class AuthService with ChangeNotifier {
  ClearanceLevel _currentClearance = ClearanceLevel.none;
  String? _currentAgentName;

  ClearanceLevel get currentClearance => _currentClearance;
  String get currentAgentName => _currentAgentName ?? "UNKNOWN";

  /// The Login Function
  /// Returns 'true' if successful, 'false' if failed.
  Future<bool> login(String accessCode, String password) async {
    // 1. CHECK HARDCODED MASTER KEYS (For the GM)
    if (accessCode == "ADAMAS-PRIME" && password == "ORIGIN") {
      _currentClearance = ClearanceLevel.level0;
      _currentAgentName = "LEANDRO RICCI";
      notifyListeners();
      return true;
    }
    
    if (accessCode == "DIRECTOR-RES" && password == "WINTER") {
      _currentClearance = ClearanceLevel.level2;
      _currentAgentName = "AURORA WINTER";
      notifyListeners();
      return true;
    }

    // 2. CHECK FIREBASE DATABASE (For Players)
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('personnel_database')
          .where('accessCode', isEqualTo: accessCode)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        
        // Map the stored role to a clearance level
        final int level = data['clearanceLevel'] ?? 1;
        switch (level) {
          case 0: _currentClearance = ClearanceLevel.level0; break;
          case 2: _currentClearance = ClearanceLevel.level2; break;
          default: _currentClearance = ClearanceLevel.level1;
        }

        _currentAgentName = data['name'];
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Database Login Error: $e");
    }

    // Login Failed
    _currentClearance = ClearanceLevel.none;
    notifyListeners();
    return false;
  }

  void logout() {
    _currentClearance = ClearanceLevel.none;
    _currentAgentName = null;
    notifyListeners();
  }
}