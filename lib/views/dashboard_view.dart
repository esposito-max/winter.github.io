import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/winter_ui_components.dart';
import 'reports_view.dart';
import 'mission_register_view.dart';
import 'agents_registry_view.dart';
import 'occultist_database_view.dart';
import 'control_center/control_center_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user's clearance level to determine access
    final authService = Provider.of<AuthService>(context);
    final isDirector = authService.currentClearance == ClearanceLevel.level2 || 
                       authService.currentClearance == ClearanceLevel.level0;

    return Scaffold(
      // Background: Deep gradient mimicking the dark space behind the logo
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF020406), // Void Black
              Color(0xFF0A0E14), // Metallic Dark Grey
              Color(0xFF0F0B18), // Subtle Purple Tint (Ritual undertone)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 20),
              
              // Status Monitor: Blumenau <-> St. Killian
              WinterUI.nodeStatusHeader(location: "BLUMENAU HQ <-> ST. KILLIAN NODE [SYNCED]"),
              
              const SizedBox(height: 30),

              // The Main Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: GridView.count(
                    crossAxisCount: 2, // 2 Columns for that sturdy "Shield" look
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.3,
                    children: [
                      // ACCESS: All Agents
                      _buildMenuCard(
                        context,
                        title: "REPORTS",
                        icon: Icons.history_edu,
                        color: Colors.cyanAccent, // Frost Blue
                        targetView: ReportsView(),
                      ),
                      _buildMenuCard(
                        context,
                        title: "MISSIONS",
                        icon: Icons.radar, // Tracking/Radar for Equipe Olimpo
                        color: Colors.cyanAccent,
                        targetView: MissionRegisterView(),
                      ),
                      _buildMenuCard(
                        context,
                        title: "AGENTS",
                        icon: Icons.badge,
                        color: Colors.cyanAccent,
                        targetView: const AgentsRegistryView(),
                      ),
                      
                      // ACCESS: Directors Only (Occultism is sensitive)
                      _buildMenuCard(
                        context,
                        title: "DATABASE",
                        icon: Icons.auto_stories, // Grimoire/Book look
                        color: Colors.purpleAccent, // Ritual Purple
                        targetView: const OccultistDatabaseView(),
                        isLocked: !isDirector, 
                      ),

                      // ACCESS: Command Only (Control Center)
                      if (isDirector)
                        _buildMenuCard(
                          context,
                          title: "CONTROL",
                          icon: Icons.settings_input_component,
                          color: Colors.redAccent, // Critical/Command
                          targetView: const ControlCenterView(),
                        ),
                    ],
                  ),
                ),
              ),
              
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  /// The Top Bar with the Logo and User Info
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Small Logo Integration
          Row(
            children: [
              Image.asset('assets/winter_logo.png', height: 40), // Your Logo Asset
              const SizedBox(width: 12),
            ],
          ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context); // Go back to Landing Page
            },
          ),
        ],
      ),
    );
  }

  /// A specific card widget that mimics the "Shield" shape of the logo
  Widget _buildMenuCard(BuildContext context, {
    required String title, 
    required IconData icon, 
    required Color color, 
    Widget? targetView,
    bool isLocked = false,
  }) {
    return InkWell(
      onTap: isLocked ? null : () {
        if (targetView != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetView));
        }
      },
      child: WinterUI.crystalFrame( // Using the "Glass" border we created
        child: Container(
          decoration: BoxDecoration(
            // Subtle gradient overlay on cards to make them pop
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1), // Tinted with the category color
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isLocked ? Icons.lock : icon, 
                size: 40, 
                color: isLocked ? Colors.grey : color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: isLocked ? Colors.grey : Colors.white,
                  fontFamily: 'Courier',
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "SYSTEM VERSION 2.4.1 | AUTH: AURORA WINTER",
        style: TextStyle(
          color: Colors.white.withOpacity(0.2),
          fontSize: 10,
          fontFamily: 'Courier',
        ),
      ),
    );
  }
}