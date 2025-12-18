class AgentModel {
  final String? id;
  final String name;
  final String role;
  final String division; // COMMAND, RESEARCH, COMBAT, INFILTRATION, OCCULTISM
  final String status;   // ACTIVE, MIA, KIA, RETIRED
  final String imageUrl;
  final int clearanceLevel; // 0, 1, 2

  AgentModel({
    this.id,
    required this.name,
    required this.role,
    required this.division,
    required this.status,
    required this.imageUrl,
    required this.clearanceLevel,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'role': role,
    'division': division,
    'status': status,
    'imageUrl': imageUrl,
    'clearanceLevel': clearanceLevel,
  };

  factory AgentModel.fromMap(Map<String, dynamic> map, String id) => AgentModel(
    id: id,
    name: map['name'] ?? '',
    role: map['role'] ?? '',
    division: map['division'] ?? 'COMBAT',
    status: map['status'] ?? 'ACTIVE',
    imageUrl: map['imageUrl'] ?? '',
    clearanceLevel: map['clearanceLevel'] ?? 1,
  );
}