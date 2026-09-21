import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:al_urjuza/data/poem_data.dart';
import 'package:al_urjuza/providers/library_provider.dart';
import 'package:al_urjuza/providers/progress_provider.dart';
import 'package:al_urjuza/screens/reader_screen.dart';
import 'package:al_urjuza/screens/search_screen.dart';
import 'package:al_urjuza/utils/text_utils.dart';
import 'package:al_urjuza/widgets/app_drawer.dart';
import 'package:al_urjuza/widgets/daily_verse_card.dart';

/// الشاشة الرئيسية: الترحيب، بيت اليوم، تقدم القراءة، الإحصائيات، واختصارات الأبواب.
class HomeScreen extends StatelessWidget {
  final void Function(int verseNumber) onContinue;
  final VoidCallback onOpenSections;

  const HomeScreen({
    super.key,
    required this.onContinue,
    required this.onOpenSections,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = context.watch<ProgressProvider>();
    final library = context.watch<LibraryProvider>();

    final dailyNumber = dailyVerseNumber(PoemData.totalVerses);
    final dailyVerse = PoemData.verseByNumber(dailyNumber);
    final dailySection = PoemData.sectionOf(dailyNumber);
    final progressPercent = (progress.overallProgress * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأَرْجُوزَة'),
        actions: [
          IconButton(
            tooltip: 'البحث',
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 30),
        children: [
          // بطاقة الترحيب
          Container(
            margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF303F9F)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أُرْجُوزَةُ المِلَلِ وَالنِّحَلِ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'للشاعر عاصف بن الجمل — شرحاً وتفريعاً بيتاً بيتاً',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _MiniStat(value: '200', label: 'بيتاً'),
                    const SizedBox(width: 10),
                    _MiniStat(value: '12', label: 'باباً'),
                    const SizedBox(width: 10),
                    _MiniStat(value: '10', label: 'مواضيع'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'بيت اليوم',
              style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 10),
          DailyVerseCard(verse: dailyVerse, section: dailySection),
          const SizedBox(height: 22),
          // متابعة القراءة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(color: scheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress.overallProgress,
                            strokeWidth: 6,
                            backgroundColor:
                                scheme.primary.withOpacity(0.12),
                          ),
                          Text(
                            '$progressPercent%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: scheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'تقدم القراءة',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 14.5),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'قرأت ${progress.readCount} من 200 بيت — توقفت عند البيت ${progress.lastVerse}',
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () => onContinue(progress.lastVerse),
                      icon: const Icon(Icons.play_arrow_rounded, size: 20),
                      label: const Text('تابع', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // إحصائيات سريعة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _StatTile(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'المقروء',
                  value: '${progress.readCount}',
                  color: scheme.primary,
                ),
                const SizedBox(width: 10),
                _StatTile(
                  icon: Icons.star_rounded,
                  label: 'المفضلة',
                  value: '${library.favorites.length}',
                  color: const Color(0xFFF0B429),
                ),
                const SizedBox(width: 10),
                _StatTile(
                  icon: Icons.edit_note_rounded,
                  label: 'الملاحظات',
                  value: '${library.countNotes()}',
                  color: scheme.tertiary,
                ),
                const SizedBox(width: 10),
                _StatTile(
                  icon: Icons.quiz_outlined,
                  label: 'أفضل اختبار',
                  value: '${progress.quizBest}/10',
                  color: scheme.secondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                const Text(
                  'استكشف الأبواب',
                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onOpenSections,
                  child: const Text('عرض الكل',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          // شريط الأبواب الأفقية
          SizedBox(
            height: 150,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              itemCount: poemSections.length,
              itemBuilder: (context, i) {
                final section = poemSections[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReaderScreen(
                            initialSectionId: section.id,
                            asPage: true,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 138,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: section.color.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: section.color.withOpacity(0.35),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(section.icon, color: section.color, size: 24),
                          const Spacer(),
                          Text(
                            section.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${section.verseCount} بيتاً',
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة إحصائية مصغرة داخل بطاقة الترحيب.
class _MiniStat extends StatelessWidget {
  final String value;
  final String label;

  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة إحصائية في صف الإحصائيات.
class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 14.5, fontWeight: FontWeight.w800),
            ),
            Text(
              label,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
