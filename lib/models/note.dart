final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, title, description, time
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class Note {
  final int? id;
  final bool isImportant;
  final String title;
  final String description;
  final DateTime modifiedTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.title,
    required this.description,
    required this.modifiedTime,
  });

  Note copy({
    int? id,
    bool? isImportant,
    String? title,
    String? description,
    DateTime? modifiedTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        title: title ?? this.title,
        description: description ?? this.description,
        modifiedTime: modifiedTime ?? this.modifiedTime,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
    id: json[NoteFields.id] as int?,
    isImportant: json[NoteFields.isImportant] == 1,
    title: json[NoteFields.title] as String,
    description: json[NoteFields.description] as String,
    modifiedTime: DateTime.parse(json[NoteFields.time] as String),
  );

  Map<String, Object?> toJson() => {
    NoteFields.id: id,
    NoteFields.title: title,
    NoteFields.isImportant: isImportant ? 1 : 0,
    NoteFields.description: description,
    NoteFields.time: modifiedTime.toIso8601String(),
  };
}