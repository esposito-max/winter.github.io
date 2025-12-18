import 'package:flutter/material.dart';

// --- IMPORTS FOR YOUR NEW NODES ---
import 'nodes/mission_control_node.dart';
import 'nodes/agents_control_node.dart';
import 'nodes/reports_control_node.dart';
import 'nodes/occult_control_node.dart';

class ControlCenterView extends StatelessWidget {
  const ControlCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        title: const Text("ADAMAS CONTROL CENTER", style: TextStyle(letterSpacing: 2)),
        backgroundColor: const Color(0xFF0A0E14),
        centerTitle: true,
        // The "Command" Red border
        shape: const Border(bottom: BorderSide(color: Colors.redAccent, width: 1)), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            // 1. AGENTS CONTROL
            _buildNodeButton(
              context,
              "AGENTS CONTROL",
              Icons.people_outline,
              Colors.blue,
              const AgentsControlNode(), // NOW LINKED
            ),

            // 2. REPORTS CONTROL
            _buildNodeButton(
              context,
              "REPORTS CONTROL",
              Icons.description_outlined,
              Colors.purple,
              const ReportsControlNode(), // NOW LINKED
            ),

            // 3. OCCULTIST CONTROL
            _buildNodeButton(
              context,
              "OCCULTIST CONTROL",
              Icons.auto_fix_high,
              Colors.teal,
              const OccultControlNode(), // NOW LINKED
            ),

            // 4. MISSION CONTROL (Already Linked)
            _buildNodeButton(
              context,
              "MISSION CONTROL",
              Icons.track_changes,
              Colors.redAccent,
              const MissionControlNode(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeButton(BuildContext context, String label, IconData icon, Color color, Widget destination) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          border: Border.all(color: color.withOpacity(0.5)),
          // Sharp corners for the "Adamas/Diamond" theme
          borderRadius: BorderRadius.zero, 
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'monospace', // Consistent Hacker Font
              ),
            ),
          ],
        ),
      ),
    );
  }
}