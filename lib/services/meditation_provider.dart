import 'package:flutter/foundation.dart';
import '../models/meditation_session.dart';
import 'database_service.dart';

class MeditationProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  List<MeditationSession> _sessions = [];
  MeditationSession? _activeSession;
  bool _isLoading = false;

  List<MeditationSession> get sessions => _sessions;
  MeditationSession? get activeSession => _activeSession;
  bool get isLoading => _isLoading;
  bool get hasActiveSession => _activeSession != null;

  Future<void> loadSessions() async {
    _isLoading = true;
    notifyListeners();

    _sessions = await _db.getMeditationSessions(limit: 30);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> startSession(String type, int durationSeconds) async {
    final session = MeditationSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: DateTime.now(),
      durationSeconds: durationSeconds,
      type: type,
    );

    _activeSession = session;
    await _db.createMeditationSession(session);
    notifyListeners();
  }

  Future<void> endSession({String? notes}) async {
    if (_activeSession == null) return;

    final completedSession = MeditationSession(
      id: _activeSession!.id,
      startTime: _activeSession!.startTime,
      endTime: DateTime.now(),
      durationSeconds: _activeSession!.durationSeconds,
      type: _activeSession!.type,
      notes: notes,
    );

    await _db.updateMeditationSession(completedSession);
    _activeSession = null;
    await loadSessions();
  }

  int get totalMinutesMeditated {
    return _sessions.fold<int>(
      0,
      (prev, session) => prev + (session.durationSeconds ~/ 60),
    );
  }

  int get sessionsThisWeek {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _sessions.where((s) => s.startTime.isAfter(weekAgo)).length;
  }
}
