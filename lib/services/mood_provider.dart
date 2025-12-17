import 'package:flutter/foundation.dart';
import '../models/mood_entry.dart';
import 'database_service.dart';

class MoodProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  List<MoodEntry> _entries = [];
  bool _isLoading = false;

  List<MoodEntry> get entries => _entries;
  bool get isLoading => _isLoading;

  Future<void> loadEntries() async {
    _isLoading = true;
    notifyListeners();

    _entries = await _db.getMoodEntries(limit: 30);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEntry(MoodEntry entry) async {
    await _db.createMoodEntry(entry);
    await loadEntries();
  }

  Future<List<MoodEntry>> getEntriesInRange(DateTime start, DateTime end) async {
    return await _db.getMoodEntriesInRange(start, end);
  }

  double get averageMood {
    if (_entries.isEmpty) return 0;
    final sum = _entries.fold<int>(0, (prev, entry) => prev + entry.moodScore);
    return sum / _entries.length;
  }
}
