/// أدوات مساعدة لمعالجة النص العربي: إزالة التشكيل، البحث، وتجزئة القافية.
library;

/// إزالة علامات التشكيل والتطويل من النص (لأغراض البحث).
String stripTashkeel(String text) {
  final pattern = RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED\u0640\u0640]');
  return text.replaceAll(pattern, '');
}

/// توحيد الحروف المتقاربة لتحسين نتائج البحث.
String normalizeArabic(String text) {
  var t = stripTashkeel(text);
  t = t.replaceAll(RegExp('[أإآٱ]'), 'ا');
  t = t.replaceAll('ى', 'ي');
  t = t.replaceAll('ة', 'ه');
  t = t.replaceAll('ؤ', 'و');
  t = t.replaceAll('ئ', 'ي');
  return t;
}

/// هل يحتوي النص على الكلمة المبحوثة بعد التوحيد؟
bool matchesQuery(String text, String normalizedQuery) {
  if (normalizedQuery.isEmpty) return true;
  return normalizeArabic(text).contains(normalizedQuery);
}

/// فصل آخر كلمة من الشطر (القافية) لتلوينها.
/// يعيد زوجاً: [متن الشطر, الكلمة الأخيرة].
(String, String) splitRhyme(String hemistich) {
  final t = hemistich.trim();
  final idx = t.lastIndexOf(' ');
  if (idx == -1) return ('', t);
  return (t.substring(0, idx), t.substring(idx + 1));
}

/// بيت اليوم: رقم بيت ثابت لكل يوم ميلادي (يتغير كل 24 ساعة).
int dailyVerseNumber(int totalVerses) {
  final now = DateTime.now();
  final dayIndex = now.difference(DateTime(2024)).inDays;
  return (dayIndex % totalVerses) + 1;
}
