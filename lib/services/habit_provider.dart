import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import 'database_service.dart';

class HabitProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  List<Habit> _habits = [];
  Map<String, List<HabitCompletion>> _completions = {};
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    _habits = await _db.getActiveHabits();

    // Load completions for all habits
    for (final habit in _habits) {
      _completions[habit.id] = await _db.getHabitCompletions(habit.id);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await _db.createHabit(habit);
    await loadHabits();
  }

  Future<void> toggleCompletion(String habitId, DateTime date) async {
    final completion = HabitCompletion(
      id: '${habitId}_${date.toIso8601String()}',
      habitId: habitId,
      date: date,
      completed: true,
    );

    await _db.toggleHabitCompletion(completion);
    await loadHabits();
  }

  Future<bool> isCompletedOnDate(String habitId, DateTime date) async {
    return await _db.isHabitCompletedOnDate(habitId, date);
  }

  int getCompletionStreak(String habitId) {
    final completions = _completions[habitId] ?? [];
    if (completions.isEmpty) return 0;

    completions.sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime currentDate = DateTime.now();

    for (int i = 0; i < 30; i++) {
      final dateToCheck = currentDate.subtract(Duration(days: i));
      final hasCompletion = completions.any((c) =>
          c.date.year == dateToCheck.year &&
          c.date.month == dateToCheck.month &&
          c.date.day == dateToCheck.day);

      if (hasCompletion) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }

    return streak;
  }
}
