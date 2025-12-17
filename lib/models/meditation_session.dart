class MeditationSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final String type; // 'guided', 'breathing', 'silent'
  final String? notes;

  MeditationSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.durationSeconds,
    required this.type,
    this.notes,
  });

  bool get isCompleted => endTime != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'durationSeconds': durationSeconds,
      'type': type,
      'notes': notes,
    };
  }

  factory MeditationSession.fromMap(Map<String, dynamic> map) {
    return MeditationSession(
      id: map['id'],
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      durationSeconds: map['durationSeconds'],
      type: map['type'],
      notes: map['notes'],
    );
  }
}
