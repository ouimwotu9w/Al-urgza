import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_urjuza/models/models.dart';
import 'package:al_urjuza/providers/library_provider.dart';
import 'package:al_urjuza/providers/progress_provider.dart';
import 'package:al_urjuza/providers/settings_provider.dart';
import 'package:al_urjuza/screens/verse_detail_screen.dart';
import 'package:al_urjuza/theme/app_theme.dart';
import 'package:al_urjuza/widgets/verse_text.dart';
import 'package:al_urjuza/widgets/share_verse.dart';
import 'package:al_urjuza/widgets/note_editor.dart';

const Color _starGold = Color(0xFFF0B429);

/// بطاقة البيت في وضع القراءة بالبطاقات: الرقم، النص، الشرح القابل للتوسيع، والأدوات.
class VerseCard extends StatefulWidget {
  final Verse verse;
  final PoemSection section;
  final bool initiallyExpanded;

  const VerseCard({
    super.key,
    required this.verse,
    required this.section,
    this.initiallyExpanded = false,
  });

  @override
  State<VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends State<VerseCard> {
  late bool _expanded = widget.initiallyExpanded;

  void _toggleExpand() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      context.read<ProgressProvider>().markRead(widget.verse.number);
    }
  }

  void _openDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerseDetailScreen(
          verse: widget.verse,
          section: widget.section,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final library = context.watch<LibraryProvider>();
    final progress = context.watch<ProgressProvider>();
    final settings = context.watch<SettingsProvider>();
    final section = widget.section;
    final verse = widget.verse;

    final isFav = library.isFavorite(verse.number);
    final isRead = progress.isRead(verse.number);
    final hasNote = library.hasNote(verse.number);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _toggleExpand,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: section.color.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${verse.number}',
                      style: TextStyle(
                        color: section.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${section.ordinal} • ${section.title}',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isRead)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(Icons.check_circle_rounded,
                          size: 18, color: scheme.primary),
                    ),
                  IconButton(
                    tooltip: isFav ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
                    icon: Icon(
                      isFav
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: isFav ? _starGold : scheme.onSurfaceVariant,
                    ),
                    onPressed: () => context
                        .read<LibraryProvider>()
                        .toggleFavorite(verse.number),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              VerseTextWidget(
                verse: verse,
                fontSize: 18,
                showTashkeel: settings.showTashkeel,
                baseColor: scheme.onSurface,
                rhymeColor: section.color,
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: section.color.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الشرح',
                          style: TextStyle(
                            color: section.color,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          verse.explanation,
                          style: AppTheme.explanationStyle(scheme),
                        ),
                      ],
                    ),
                  ),
                ),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 260),
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      _ActionChip(
                        icon: Icons.chrome_reader_mode_outlined,
                        label: 'التفاصيل',
                        color: section.color,
                        onTap: _openDetails,
                      ),
                      _ActionChip(
                        icon: hasNote
                            ? Icons.edit_note_rounded
                            : Icons.edit_note_outlined,
                        label: hasNote ? 'الملاحظة' : 'ملاحظة',
                        color: scheme.primary,
                        onTap: () => showNoteEditor(context, verse.number),
                      ),
                      _ActionChip(
                        icon: Icons.ios_share_outlined,
                        label: 'مشاركة',
                        color: scheme.secondary,
                        onTap: () => ShareVerse.showSheet(context, verse, section),
                      ),
                      _ActionChip(
                        icon: isRead
                            ? Icons.undo_rounded
                            : Icons.done_all_rounded,
                        label: isRead ? 'غير مقروء' : 'مقروء',
                        color: isRead
                            ? scheme.onSurfaceVariant
                            : scheme.tertiary,
                        onTap: () => context
                            .read<ProgressProvider>()
                            .toggleRead(verse.number),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
