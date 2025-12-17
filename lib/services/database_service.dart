import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/mood_entry.dart';
import '../models/habit.dart';
import '../models/meditation_session.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('syntonic_wellness.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE mood_entries (
        id $idType,
        timestamp $textType,
        moodScore $intType,
        note TEXT,
        tags TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE habits (
        id $idType,
        name $textType,
        description TEXT,
        icon $textType,
        color $textType,
        targetDays $textType,
        createdAt $textType,
        isActive $intType
      )
    ''');

    await db.execute('''
      CREATE TABLE habit_completions (
        id $idType,
        habitId $textType,
        date $textType,
        completed $intType,
        FOREIGN KEY (habitId) REFERENCES habits (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE meditation_sessions (
        id $idType,
        startTime $textType,
        endTime TEXT,
        durationSeconds $intType,
        type $textType,
        notes TEXT
      )
    ''');
  }

  // Mood Entry methods
  Future<void> createMoodEntry(MoodEntry entry) async {
    final db = await database;
    await db.insert('mood_entries', entry.toMap());
  }

  Future<List<MoodEntry>> getMoodEntries({int? limit}) async {
    final db = await database;
    final result = await db.query(
      'mood_entries',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return result.map((map) => MoodEntry.fromMap(map)).toList();
  }

  Future<List<MoodEntry>> getMoodEntriesInRange(
      DateTime start, DateTime end) async {
    final db = await database;
    final result = await db.query(
      'mood_entries',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'timestamp DESC',
    );
    return result.map((map) => MoodEntry.fromMap(map)).toList();
  }

  // Habit methods
  Future<void> createHabit(Habit habit) async {
    final db = await database;
    await db.insert('habits', habit.toMap());
  }

  Future<List<Habit>> getActiveHabits() async {
    final db = await database;
    final result = await db.query(
      'habits',
      where: 'isActive = ?',
      whereArgs: [1],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Habit.fromMap(map)).toList();
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  // Habit Completion methods
  Future<void> toggleHabitCompletion(HabitCompletion completion) async {
    final db = await database;
    final existing = await db.query(
      'habit_completions',
      where: 'habitId = ? AND date = ?',
      whereArgs: [completion.habitId, completion.date.toIso8601String()],
    );

    if (existing.isEmpty) {
      await db.insert('habit_completions', completion.toMap());
    } else {
      await db.delete(
        'habit_completions',
        where: 'habitId = ? AND date = ?',
        whereArgs: [completion.habitId, completion.date.toIso8601String()],
      );
    }
  }

  Future<List<HabitCompletion>> getHabitCompletions(String habitId) async {
    final db = await database;
    final result = await db.query(
      'habit_completions',
      where: 'habitId = ?',
      whereArgs: [habitId],
      orderBy: 'date DESC',
    );
    return result.map((map) => HabitCompletion.fromMap(map)).toList();
  }

  Future<bool> isHabitCompletedOnDate(String habitId, DateTime date) async {
    final db = await database;
    final result = await db.query(
      'habit_completions',
      where: 'habitId = ? AND date = ?',
      whereArgs: [habitId, date.toIso8601String()],
    );
    return result.isNotEmpty;
  }

  // Meditation Session methods
  Future<void> createMeditationSession(MeditationSession session) async {
    final db = await database;
    await db.insert('meditation_sessions', session.toMap());
  }

  Future<void> updateMeditationSession(MeditationSession session) async {
    final db = await database;
    await db.update(
      'meditation_sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<List<MeditationSession>> getMeditationSessions({int? limit}) async {
    final db = await database;
    final result = await db.query(
      'meditation_sessions',
      orderBy: 'startTime DESC',
      limit: limit,
    );
    return result.map((map) => MeditationSession.fromMap(map)).toList();
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
