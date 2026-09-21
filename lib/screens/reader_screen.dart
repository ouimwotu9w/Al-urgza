import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:al_urjuza/data/poem_data.dart';
import 'package:al_urjuza/models/models.dart';
import 'package:al_urjuza/providers/progress_provider.dart';
import 'package:al_urjuza/providers/settings_provider.dart';
import 'package:al_urjuza/screens/verse_detail_screen.dart';
import 'package:al_urjuza/theme/app_theme.dart';
import 'package:al_urjuza/widgets/app_drawer.dart';
import 'package:al_urjuza/widgets/verse_card.dart';
import 'package:al_urjuza/widgets/verse_text.dart';

/// قارئ الأرجوزة: عرض باب واحد في وضعين — بطاقات قابلة للتوسيع أو نص متواصل.
class ReaderScreen extends StatefulWidget {
  final String? initialSectionId;
  final int jumpVerse;
  final int jumpToken;
  final bool asPage;

  const ReaderScreen({
    super.key,
    this.initialSectionId,
    this.jumpVerse = 0,
    this.jumpToken = 0,
    this.asPage = false,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late String _sectionId;
  int _mode = 0; // 0 = بطاقات، 1 = متواصل
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _verseKeys = <int, GlobalKey>{};

  @override
  void initState() {
    super.initState();
    final lastVerse = context.read<ProgressProvider>().lastVerse;
    _sectionId =
        widget.initialSectionId ?? PoemData.sectionOf(lastVerse).id;
    if (widget.jumpVerse > 0) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _jumpToVerse(widget.jumpVerse));
    }
  }

  @override
  void didUpdateWidget(covariant ReaderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.jumpToken != oldWidget.jumpToken && widget.jumpVerse > 0) {
      _jumpToVerse(widget.jumpVerse);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _jumpToVerse(int verseNumber) {
    final section = PoemData.sectionOf(verseNumber);
    if (section.id != _sectionId) {
      setState(() => _sectionId = section.id);
    }
    context.read<ProgressProvider>().setLastVerse(verseNumber);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final keyContext = _verseKeys[verseNumber]?.currentContext;
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 500),
          alignment: 0.1,
        );
      } else {
        _scrollController.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final section = PoemData.sectionById(_sectionId);
    final progress = context.watch<ProgressProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${section.ordinal} • ${section.title}'),
      ),
      drawer: widget.asPage ? null : const AppDrawer(),
      body: Column(
        children: [
          // شريط تبديل الأبواب
          SizedBox(
            height: 52,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: poemSections.length,
              itemBuilder: (context, i) {
                final s = poemSections[i];
                final selected = s.id == _sectionId;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(s.title),
                    selected: selected,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: selected
                          ? (s.id == _sectionId ? Colors.white : scheme.onSurface)
                          : scheme.onSurfaceVariant,
                    ),
                    selectedColor: s.color,
                    backgroundColor: scheme.surface,
                    side: BorderSide(
                      color: selected
                          ? s.color
                          : scheme.outlineVariant,
                    ),
                    onSelected: (_) => setState(() => _sectionId = s.id),
                  ),
                );
              },
            ),
          ),
          // مفتاح وضع القراءة
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 2, 14, 8),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  icon: Icon(Icons.dashboard_outlined, size: 18),
                  label: Text('بطاقات'),
                ),
                ButtonSegment(
                  value: 1,
                  icon: Icon(Icons.auto_stories_outlined, size: 18),
                  label: Text('متواصل'),
                ),
              ],
              selected: {_mode},
              showSelectedIcon: false,
              onSelectionChanged: (selection) =>
                  setState(() => _mode = selection.first),
            ),
          ),
          // قائمة الأبيات
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 40),
              children: [
                if (_mode == 0)
                  for (final verse in section.verses)
                    _withKey(
                      verse.number,
                      VerseCard(
                        verse: verse,
                        section: section,
                      ),
                    )
                else
                  for (final verse in section.verses)
                    _withKey(
                      verse.number,
                      _BookItem(
                        verse: verse,
                        section: section,
                        isRead: progress.isRead(verse.number),
                        showTashkeel: settings.showTashkeel,
                        onOpen: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerseDetailScreen(
                                verse: verse,
                                section: section,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'reader-top-$asPageTag',
        tooltip: 'أعلى الباب',
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          );
        },
        child: const Icon(Icons.keyboard_arrow_up_rounded),
      ),
    );
  }

  String get asPageTag => widget.asPage ? 'page' : 'tab';

  Widget _withKey(int verseNumber, Widget child) {
    _verseKeys.putIfAbsent(verseNumber, () => GlobalKey());
    return KeyedSubtree(
      key: _verseKeys[verseNumber],
      child: child,
    );
  }
}

/// عنصر البيت في وضع القراءة المتواصل (شبيه بالكتاب المفتوح).
class _BookItem extends StatelessWidget {
  final Verse verse;
  final PoemSection section;
  final bool isRead;
  final bool showTashkeel;
  final VoidCallback onOpen;

  const _BookItem({
    required this.verse,
    required this.section,
    required this.isRead,
    required this.showTashkeel,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: section.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${verse.number}',
                    style: TextStyle(
                      color: section.color,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Divider(color: scheme.outlineVariant),
                ),
                if (isRead)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 6),
                    child: Icon(Icons.check_circle_rounded,
                        size: 15, color: scheme.primary),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            VerseTextWidget(
              verse: verse,
              fontSize: 17.5,
              showTashkeel: showTashkeel,
              baseColor: scheme.onSurface,
              rhymeColor: section.color,
              weight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            Text(
              verse.explanation,
              style: AppTheme.explanationStyle(scheme, size: 13.5),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
