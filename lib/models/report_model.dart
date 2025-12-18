class ReportModel {
  final String? id;
  final String title;
  final String author;
  final String date;
  final String content;
  final bool isSensitive; // If true, blurs out for low clearance
  final String type;      // MISSION, RESEARCH, INCIDENT

  ReportModel({
    this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.content,
    required this.isSensitive,
    required this.type,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'author': author,
    'date': date,
    'content': content,
    'isSensitive': isSensitive,
    'type': type,
  };

  factory ReportModel.fromMap(Map<String, dynamic> map, String id) => ReportModel(
    id: id,
    title: map['title'] ?? 'REDACTED',
    author: map['author'] ?? 'UNKNOWN',
    date: map['date'] ?? '',
    content: map['content'] ?? '',
    isSensitive: map['isSensitive'] ?? false,
    type: map['type'] ?? 'INCIDENT',
  );
}