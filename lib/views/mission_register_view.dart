import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/mission_model.dart';

class MissionRegisterView extends StatelessWidget {
  MissionRegisterView({super.key});
  
  final FirestoreService _db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    // Determine Access Level
    final isCommand = authService.currentClearance == ClearanceLevel.level0; // Riccis
    final isDirector = authService.currentClearance == ClearanceLevel.level2; // Aurora/Others

    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        title: const Text("ACTIVE OPERATIONS", style: TextStyle(letterSpacing: 3)),
        backgroundColor: const Color(0xFF0A0E14),
      ),
      // LISTEN TO FIREBASE
      body: StreamBuilder<List<MissionModel>>(
        stream: _db.getMissions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("CONNECTION ERROR", style: TextStyle(color: Colors.red)));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));

          final missions = snapshot.data!;
          
          if (missions.isEmpty) {
             return const Center(child: Text("NO ACTIVE OPERATIONS FOUND", style: TextStyle(color: Colors.grey, fontFamily: 'monospace')));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 Cards Wide
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: missions.length,
              itemBuilder: (context, index) {
                return _buildMissionCard(context, missions[index], isCommand, isDirector);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, MissionModel mission, bool isCommand, bool isDirector) {
    final bool canSeeNotes = isCommand || isDirector;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117), // Card Background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. IMAGE
          Expanded(
            flex: 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  mission.imageUrl.isNotEmpty ? mission.imageUrl : "https://placehold.co/400x300/1C222B/00E5FF.png?text=NO+IMAGE",
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(color: Colors.grey[900], child: const Icon(Icons.broken_image, color: Colors.grey)),
                ),
                // Gradient for readability
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xFF0D1117)], stops: [0.7, 1.0]
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. INFO
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_moon, size: 16, color: Colors.cyanAccent),
                      const SizedBox(width: 6),
                      Text(mission.teamName.toUpperCase(), 
                        style: const TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
                  ),
                  
                  const SizedBox(height: 6),
                  
                  Text(
                    mission.codeName,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                  ),
                  
                  const Divider(color: Colors.white12, height: 16),

                  _infoRow("HANDLER:", mission.handler),
                  _infoRow("STATUS:", mission.status, color: _getStatusColor(mission.status)),
                  
                  const SizedBox(height: 8),

                  Text("SECURITY:", style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isCommand ? Colors.red.withOpacity(0.2) : Colors.blueGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: isCommand ? Colors.redAccent : Colors.blueGrey, width: 0.5)
                    ),
                    child: Text(
                      isCommand ? "FULL ACCESS [${mission.securityLevel}]" : "RESTRICTED [${mission.securityLevel}]", 
                      style: TextStyle(fontSize: 9, color: isCommand ? Colors.redAccent : Colors.white70, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Director Notes (Hidden for agents)
                  if (canSeeNotes && mission.directorNotes.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        border: Border(left: BorderSide(color: Colors.purpleAccent, width: 2)),
                      ),
                      child: Text(
                        "NOTE: ${mission.directorNotes}",
                        style: const TextStyle(color: Colors.purpleAccent, fontSize: 9, fontStyle: FontStyle.italic),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color color = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 10))),
          Expanded(child: Text(value, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "ACTIVE": return Colors.greenAccent;
      case "IN PROGRESS": return Colors.orangeAccent;
      case "COMPLETED": return Colors.grey;
      case "STANDBY": return Colors.blueAccent;
      default: return Colors.white;
    }
  }
}