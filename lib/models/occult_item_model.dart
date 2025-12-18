class OccultItemModel {
  final String? id;
  final String name;
  final String category; // RITUAL, ITEM, ENTITY
  final String dangerLevel; // LOW, MEDIUM, CRITICAL, EXTREME
  final String description;
  final String containment; // Special procedures
  final String imageUrl;

  OccultItemModel({
    this.id,
    required this.name,
    required this.category,
    required this.dangerLevel,
    required this.description,
    required this.containment,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'category': category,
    'dangerLevel': dangerLevel,
    'description': description,
    'containment': containment,
    'imageUrl': imageUrl,
  };

  factory OccultItemModel.fromMap(Map<String, dynamic> map, String id) => OccultItemModel(
    id: id,
    name: map['name'] ?? 'UNKNOWN ARTIFACT',
    category: map['category'] ?? 'ITEM',
    dangerLevel: map['dangerLevel'] ?? 'LOW',
    description: map['description'] ?? '',
    containment: map['containment'] ?? '',
    imageUrl: map['imageUrl'] ?? '',
  );
}