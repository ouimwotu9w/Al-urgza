import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// تقدم القراءة: الأبيات المقروءة، آخر موضع، ونتيجة أفضل اختبار.
class ProgressProvider extends ChangeNotifier {
  ProgressProvider(this._prefs) {
    final readList = _prefs.getStringList('readVerses') ?? <String>[];
    _read = readList.map(int.parse).toSet();
    _lastVerse = _prefs.getInt('lastVerse') ?? 1;
    _quizBest = _prefs.getInt('quizBest') ?? 0;
  }

  final SharedPreferences _prefs;

  Set<int> _read = <int>{};
  int _lastVerse = 1;
  int _quizBest = 0;

  Set<int> get readSet => _read;
  int get lastVerse => _lastVerse;
  int get quizBest => _quizBest;
  int get readCount => _read.length;
  double get overallProgress => _read.length / 200;

  bool isRead(int verseNumber) => _read.contains(verseNumber);

  void markRead(int verseNumber) {
    if (_read.add(verseNumber)) {
      _persistRead();
    }
  }

  void markUnread(int verseNumber) {
    if (_read.remove(verseNumber)) {
      _persistRead();
    }
  }

  void toggleRead(int verseNumber) {
    if (_read.contains(verseNumber)) {
      _read.remove(verseNumber);
    } else {
      _read.add(verseNumber);
    }
    _persistRead();
  }

  void _persistRead() {
    _prefs.setStringList('readVerses', _read.map((e) => e.toString()).toList());
    notifyListeners();
  }

  void setLastVerse(int verseNumber) {
    _lastVerse = verseNumber;
    _prefs.setInt('lastVerse', verseNumber);
    notifyListeners();
  }

  void updateQuizBest(int score) {
    if (score > _quizBest) {
      _quizBest = score;
      _prefs.setInt('quizBest', score);
      notifyListeners();
    }
  }

  /// نسبة التقدم ضمن نطاق أرقام أبيات (من بداية باب إلى نهايته).
  double progressInRange(int start, int end) {
    var c = 0;
    for (var i = start; i <= end; i++) {
      if (_read.contains(i)) c++;
    }
    return c / (end - start + 1);
  }

  void resetAll() {
    _read.clear();
    _lastVerse = 1;
    _prefs.setStringList('readVerses', <String>[]);
    _prefs.setInt('lastVerse', 1);
    notifyListeners();
  }
}
