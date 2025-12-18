import 'package:flutter/material.dart';
import '../../../models/mission_model.dart';
import '../../../services/firestore_service.dart';

class MissionControlNode extends StatefulWidget {
  const MissionControlNode({super.key});

  @override
  State<MissionControlNode> createState() => _MissionControlNodeState();
}

class _MissionControlNodeState extends State<MissionControlNode> {
  final FirestoreService _db = FirestoreService();
  
  // Controllers
  final _codeNameController = TextEditingController();
  final _teamNameController = TextEditingController();
  final _handlerController = TextEditingController();
  final _locationController = TextEditingController();
  final _statusController = TextEditingController();
  final _securityController = TextEditingController();
  final _imageController = TextEditingController();
  final _briefController = TextEditingController();
  final _notesController = TextEditingController();

  // EDITOR POPUP
  void _showMissionEditor(BuildContext context, {MissionModel? existingMission}) {
    // Pre-fill if editing
    if (existingMission != null) {
      _codeNameController.text = existingMission.codeName;
      _teamNameController.text = existingMission.teamName;
      _handlerController.text = existingMission.handler;
      _locationController.text = existingMission.location;
      _statusController.text = existingMission.status;
      _securityController.text = existingMission.securityLevel;
      _imageController.text = existingMission.imageUrl;
      _briefController.text = existingMission.brief;
      _notesController.text = existingMission.directorNotes;
    } else {
      _clearControllers();
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0D1117),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.redAccent, width: 1),
          ),
          title: Text(
            existingMission == null ? "INITIATE PROTOCOL" : "UPDATE PROTOCOL", 
            style: const TextStyle(fontFamily: 'monospace', color: Colors.redAccent)
          ),
          content: SizedBox(
            width: 600, // Wide dialog
            child: SingleChildScrollView(
              child: Column(
                children: [
                   Row(children: [
                     Expanded(child: _buildCmdField("MISSION NAME", _codeNameController)),
                     const SizedBox(width: 10),
                     Expanded(child: _buildCmdField("TEAM NAME", _teamNameController)),
                   ]),
                   const SizedBox(height: 10),
                   Row(children: [
                     Expanded(child: _buildCmdField("HANDLER", _handlerController)),
                     const SizedBox(width: 10),
                     Expanded(child: _buildCmdField("LOCATION", _locationController)),
                   ]),
                   const SizedBox(height: 10),
                   Row(children: [
                     Expanded(child: _buildCmdField("STATUS (ACTIVE/COMPLETED)", _statusController)),
                     const SizedBox(width: 10),
                     Expanded(child: _buildCmdField("SECURITY LEVEL", _securityController)),
                   ]),
                   const SizedBox(height: 10),
                   _buildCmdField("IMAGE URL (Asset or Web Link)", _imageController),
                   const SizedBox(height: 10),
                   _buildCmdField("PUBLIC BRIEFING", _briefController, maxLines: 3),
                   const SizedBox(height: 10),
                   _buildCmdField("DIRECTOR NOTES (HIDDEN)", _notesController, maxLines: 2, isSecret: true),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.2), 
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
              ),
              onPressed: () {
                _saveMission(existingMission?.id);
                Navigator.pop(context);
              },
              child: const Text("EXECUTE"),
            ),
          ],
        );
      },
    );
  }

  void _saveMission(String? docId) {
    final newMission = MissionModel(
      id: docId, 
      codeName: _codeNameController.text,
      teamName: _teamNameController.text,
      handler: _handlerController.text,
      location: _locationController.text,
      status: _statusController.text.toUpperCase(),
      priority: "HIGH", 
      securityLevel: _securityController.text.toUpperCase(),
      imageUrl: _imageController.text,
      brief: _briefController.text,
      directorNotes: _notesController.text,
    );
    _db.saveMission(newMission);
  }

  void _deleteMission(String docId) {
    _db.deleteMission(docId);
  }

  void _clearControllers() {
    _codeNameController.clear();
    _teamNameController.clear();
    _handlerController.clear();
    _locationController.clear();
    _statusController.text = "ACTIVE";
    _securityController.text = "LEVEL 1";
    _imageController.clear();
    _briefController.clear();
    _notesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        title: const Text("TACTICAL COMMAND"),
        shape: const Border(bottom: BorderSide(color: Colors.redAccent, width: 1)),
        iconTheme: const IconThemeData(color: Colors.redAccent),
      ),
      // REAL-TIME LISTENER
      body: StreamBuilder<List<MissionModel>>(
        stream: _db.getMissions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
          final missions = snapshot.data!;
          
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, 
              childAspectRatio: 0.65, 
              crossAxisSpacing: 16, 
              mainAxisSpacing: 16,
            ),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              return _buildAdminCard(context, missions[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        onPressed: () => _showMissionEditor(context),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  // --- ADMIN CARD (View + Controls) ---
  Widget _buildAdminCard(BuildContext context, MissionModel mission) {
    return Stack(
      children: [
        // The Visual Card
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Image.network(
                  mission.imageUrl.isNotEmpty ? mission.imageUrl : "https://placehold.co/400x300/1C222B/00E5FF.png?text=NO+IMAGE",
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(color: Colors.grey[900], child: const Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mission.teamName.toUpperCase(), 
                        style: const TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(mission.codeName, 
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                      const Divider(color: Colors.white12, height: 16),
                      Text("HANDLER: ${mission.handler}", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      Text("STATUS: ${mission.status}", style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Overlay Controls
        Positioned(
          top: 8, right: 8,
          child: Row(
            children: [
              InkWell(
                onTap: () => _showMissionEditor(context, existingMission: mission),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                  child: const Icon(Icons.edit, size: 16, color: Colors.blueAccent),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _deleteMission(mission.id!),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                  child: const Icon(Icons.delete, size: 16, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCmdField(String label, TextEditingController c, {int maxLines = 1, bool isSecret = false}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      style: TextStyle(color: isSecret ? Colors.purpleAccent : Colors.white, fontFamily: 'monospace', fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isSecret ? Colors.purpleAccent : Colors.redAccent, fontSize: 10),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: isSecret ? Colors.purpleAccent : Colors.redAccent),
        ),
      ),
    );
  }
}