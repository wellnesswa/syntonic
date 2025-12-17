class Habit {
  final String id;
  final String name;
  final String? description;
  final String icon;
  final String color;
  final List<int> targetDays; // 0-6 (Monday-Sunday)
  final DateTime createdAt;
  final bool isActive;

  Habit({
    required this.id,
    required this.name,
    this.description,
    required this.icon,
    required this.color,
    required this.targetDays,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'targetDays': targetDays.join(','),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      icon: map['icon'],
      color: map['color'],
      targetDays: (map['targetDays'] as String)
          .split(',')
          .map((e) => int.parse(e))
          .toList(),
      createdAt: DateTime.parse(map['createdAt']),
      isActive: map['isActive'] == 1,
    );
  }
}

class HabitCompletion {
  final String id;
  final String habitId;
  final DateTime date;
  final bool completed;

  HabitCompletion({
    required this.id,
    required this.habitId,
    required this.date,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date.toIso8601String(),
      'completed': completed ? 1 : 0,
    };
  }

  factory HabitCompletion.fromMap(Map<String, dynamic> map) {
    return HabitCompletion(
      id: map['id'],
      habitId: map['habitId'],
      date: DateTime.parse(map['date']),
      completed: map['completed'] == 1,
    );
  }
}
