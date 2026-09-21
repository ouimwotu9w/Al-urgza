import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:al_urjuza/data/poem_data.dart';
import 'package:al_urjuza/models/models.dart';
import 'package:al_urjuza/providers/library_provider.dart';
import 'package:al_urjuza/providers/progress_provider.dart';
import 'package:al_urjuza/providers/settings_provider.dart';
import 'package:al_urjuza/theme/app_theme.dart';
import 'package:al_urjuza/widgets/note_editor.dart';
import 'package:al_urjuza/widgets/share_verse.dart';
import 'package:al_urjuza/widgets/verse_text.dart';

const Color _starGold = Color(0xFFF0B429);

/// شاشة البيت الكاملة: نص كبير، شرح كامل، ملاحظة، ومشاركة، مع تنقل بين الأبيات.
class VerseDetailScreen extends StatefulWidget {
  final Verse verse;
  final PoemSection section;

  const VerseDetailScreen({
    super.key,
    required this.verse,
    required this.section,
  });

  @override
  State<VerseDetailScreen> createState() => _VerseDetailScreenState();
}

class _VerseDetailScreenState extends State<VerseDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final progress = context.read<ProgressProvider>();
      progress.markRead(widget.verse.number);
      progress.setLastVerse(widget.verse.number);
    });
  }

  void _goToVerse(int delta) {
    var target = widget.verse.number + delta;
    if (target < 1) target = PoemData.totalVerses;
    if (target > PoemData.totalVerses) target = 1;
    final verse = PoemData.verseByNumber(target);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VerseDetailScreen(
          verse: verse,
          section: PoemData.sectionOf(verse.number),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final settings = context.watch<SettingsProvider>();
    final library = context.watch<LibraryProvider>();
    final verse = widget.verse;
    final section = widget.section;
    final isFav = library.isFavorite(verse.number);
    final note = library.noteOf(verse.number);

    return Scaffold(
      appBar: AppBar(
        title: Text('البيت ${verse.number}'),
        actions: [
          IconButton(
            tooltip: isFav ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
            icon: Icon(
              isFav ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFav ? _starGold : scheme.onSurfaceVariant,
            ),
            onPressed: () =>
                context.read<LibraryProvider>().toggleFavorite(verse.number),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          // شارة الباب
          Align(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: section.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(section.icon, size: 15, color: section.color),
                  const SizedBox(width: 6),
                  Text(
                    '${section.ordinal} • ${section.title}',
                    style: TextStyle(
                      color: section.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          // نص البيت
          Hero(
            tag: 'verse-${verse.number}',
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    section.color.withOpacity(0.10),
                    section.color.withOpacity(0.04),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: section.color.withOpacity(0.25)),
              ),
              child: VerseTextWidget(
                verse: verse,
                fontSize: 21,
                showTashkeel: settings.showTashkeel,
                baseColor: scheme.onSurface,
                rhymeColor: section.color,
                weight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // الشرح
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: scheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.chrome_reader_mode_rounded,
                          size: 17, color: scheme.primary),
                    ),
                    const SizedBox(width: 9),
                    const Text(
                      'الشرح',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  verse.explanation,
                  style: AppTheme.explanationStyle(scheme, size: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // الملاحظة الشخصية
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (note != null && note.isNotEmpty)
                  ? scheme.tertiary.withOpacity(0.07)
                  : scheme.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: scheme.tertiary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.edit_note_rounded,
                          size: 17, color: scheme.tertiary),
                    ),
                    const SizedBox(width: 9),
                    const Text(
                      'ملاحظتي',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () =>
                          showNoteEditor(context, verse.number),
                      icon: const Icon(Icons.edit_outlined, size: 15),
                      label: Text(
                        (note != null && note.isNotEmpty) ? 'تعديل' : 'إضافة',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                if (note != null && note.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    note,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 13.5,
                      height: 1.8,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  Text(
                    'لم تكتب ملاحظة على هذا البيت بعد. سجّل فكرتك أو تثبيتك هنا.',
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12.5,
                      height: 1.7,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          // أزرار المشاركة
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => ShareVerse.showSheet(context, verse, section),
                  icon: const Icon(Icons.ios_share_rounded, size: 18),
                  label: const Text('مشاركة',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context
                      .read<ProgressProvider>()
                      .toggleRead(verse.number),
                  icon: const Icon(Icons.done_all_rounded, size: 18),
                  label: Text(
                    context.watch<ProgressProvider>().isRead(verse.number)
                        ? 'غير مقروء'
                        : 'تمت القراءة',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          // التنقل بين الأبيات
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _goToVerse(-1),
                  icon: const Icon(Icons.chevron_right_rounded),
                  label: const Text('البيت السابق',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _goToVerse(1),
                  icon: const Icon(Icons.chevron_left_rounded),
                  label: const Text('البيت التالي',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
