import 'package:flutter/material.dart';

/// بيت واحد من أبيات الأرجوزة: الشطر الأول والثاني مع الشرح.
class Verse {
  final int number;
  final String first;
  final String second;
  final String explanation;

  const Verse({
    required this.number,
    required this.first,
    required this.second,
    required this.explanation,
  });

  /// البيت كاملاً بشكل نصيّ مع الفاصل الشعري.
  String get full => '$first ... $second';

  /// البحث في البيت بلا تشكيل.
  String get searchText => '$first $second $explanation';
}

/// باب (موضوع) من أبواب الأرجوزة.
class PoemSection {
  final String id;
  final String ordinal;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<Verse> verses;

  const PoemSection({
    required this.id,
    required this.ordinal,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.verses,
  });

  int get startNumber => verses.first.number;
  int get endNumber => verses.last.number;
  int get verseCount => verses.length;
  int countRead(Set<int> readSet) {
    var c = 0;
    for (final v in verses) {
      if (readSet.contains(v.number)) c++;
    }
    return c;
  }
}

/// مصطلح في معجم المصطلحات.
class GlossaryTerm {
  final String term;
  final String definition;
  final String sectionHint;

  const GlossaryTerm({
    required this.term,
    required this.definition,
    required this.sectionHint,
  });
}

/// سؤال في اختبار الفهم.
class QuizQuestion {
  final String sectionId;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.sectionId,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

/// معلومات عامة عن الشاعر والأرجوزة تُعرض في شاشة «عن الشاعر».
class PoetInfo {
  final String name;
  final String poemTitle;
  final String bio;
  final String meterNote;
  final String rhymeNote;
  final List<String> highlights;

  const PoetInfo({
    required this.name,
    required this.poemTitle,
    required this.bio,
    required this.meterNote,
    required this.rhymeNote,
    required this.highlights,
  });
}
