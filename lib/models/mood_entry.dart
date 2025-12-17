class MoodEntry {
  final String id;
  final DateTime timestamp;
  final int moodScore; // 1-5 scale
  final String? note;
  final List<String> tags;

  MoodEntry({
    required this.id,
    required this.timestamp,
    required this.moodScore,
    this.note,
    this.tags = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'moodScore': moodScore,
      'note': note,
      'tags': tags.join(','),
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'],
      timestamp: DateTime.parse(map['timestamp']),
      moodScore: map['moodScore'],
      note: map['note'],
      tags: map['tags'] != null && map['tags'].isNotEmpty
          ? (map['tags'] as String).split(',')
          : [],
    );
  }

  MoodEntry copyWith({
    String? id,
    DateTime? timestamp,
    int? moodScore,
    String? note,
    List<String>? tags,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      moodScore: moodScore ?? this.moodScore,
      note: note ?? this.note,
      tags: tags ?? this.tags,
    );
  }
}
