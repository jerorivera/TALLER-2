enum NoteType { text, checklist }

NoteType _parseType(String typeStr) {
  return typeStr == 'checklist' ? NoteType.checklist : NoteType.text;
}

class Note {
  final String id;
  String title;
  String content;
  NoteType type;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'type': type.toString().split('.').last,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        type: _parseType(json['type']),
      );
}
