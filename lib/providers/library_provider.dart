import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// المكتبة الشخصية: الأبيات المفضلة والملاحظات المكتوبة على كل بيت.
class LibraryProvider extends ChangeNotifier {
  LibraryProvider(this._prefs) {
    final favList = _prefs.getStringList('favorites') ?? <String>[];
    _favorites = favList.map(int.parse).toSet();

    final rawNotes = _prefs.getString('notes');
    if (rawNotes != null && rawNotes.isNotEmpty) {
      final decoded = jsonDecode(rawNotes) as Map<String, dynamic>;
      _notes = decoded.map((k, v) => MapEntry(int.parse(k), v as String));
    }
  }

  final SharedPreferences _prefs;

  Set<int> _favorites = <int>{};
  Map<int, String> _notes = <int, String>{};

  Set<int> get favorites => _favorites;
  Map<int, String> get notes => _notes;

  bool isFavorite(int verseNumber) => _favorites.contains(verseNumber);

  void toggleFavorite(int verseNumber) {
    if (_favorites.contains(verseNumber)) {
      _favorites.remove(verseNumber);
    } else {
      _favorites.add(verseNumber);
    }
    _prefs.setStringList('favorites', _favorites.map((e) => e.toString()).toList());
    notifyListeners();
  }

  String? noteOf(int verseNumber) => _notes[verseNumber];

  bool hasNote(int verseNumber) =>
      _notes.containsKey(verseNumber) && (_notes[verseNumber] ?? '').trim().isNotEmpty;

  void setNote(int verseNumber, String note) {
    final trimmed = note.trim();
    if (trimmed.isEmpty) {
      _notes.remove(verseNumber);
    } else {
      _notes[verseNumber] = trimmed;
    }
    _prefs.setString('notes', jsonEncode(_notes));
    notifyListeners();
  }

  int countNotes() => _notes.length;
}
