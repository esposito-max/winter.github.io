class MissionModel {
  final String? id; // Firestore Document ID
  final String codeName;
  final String teamName;
  final String handler;
  final String location;
  final String status;
  final String priority;
  final String securityLevel;
  final String imageUrl;
  final String brief;
  final String directorNotes;

  MissionModel({
    this.id,
    required this.codeName,
    required this.teamName,
    required this.handler,
    required this.location,
    required this.status,
    required this.priority,
    required this.securityLevel,
    required this.imageUrl,
    required this.brief,
    required this.directorNotes,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'codeName': codeName,
      'teamName': teamName,
      'handler': handler,
      'location': location,
      'status': status,
      'priority': priority,
      'securityLevel': securityLevel,
      'imageUrl': imageUrl,
      'brief': brief,
      'directorNotes': directorNotes,
    };
  }

  // Create Object from Firebase Data
  factory MissionModel.fromMap(Map<String, dynamic> map, String docId) {
    return MissionModel(
      id: docId,
      codeName: map['codeName'] ?? '',
      teamName: map['teamName'] ?? '',
      handler: map['handler'] ?? '',
      location: map['location'] ?? '',
      status: map['status'] ?? 'PENDING',
      priority: map['priority'] ?? 'STANDARD',
      securityLevel: map['securityLevel'] ?? 'LEVEL 1',
      imageUrl: map['imageUrl'] ?? '',
      brief: map['brief'] ?? '',
      directorNotes: map['directorNotes'] ?? '',
    );
  }
}