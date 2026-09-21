import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:al_urjuza/data/poem_data.dart';
import 'package:al_urjuza/models/models.dart';
import 'package:al_urjuza/providers/library_provider.dart';
import 'package:al_urjuza/providers/settings_provider.dart';
import 'package:al_urjuza/screens/verse_detail_screen.dart';
import 'package:al_urjuza/theme/app_theme.dart';
import 'package:al_urjuza/utils/text_utils.dart';
import 'package:al_urjuza/widgets/app_drawer.dart';

const Color _starGold = Color(0xFFF0B429);

/// شاشة المفضلة: الأبيات المحفوظة مع معاينة الملاحظات.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final library = context.watch<LibraryProvider>();
    final settings = context.watch<SettingsProvider>();

    final favoriteNumbers = library.favorites.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
      ),
      drawer: const AppDrawer(),
      body: favoriteNumbers.isEmpty
          ? _EmptyFavorites(scheme: scheme)
          : ListView(
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
                  child: Text(
                    '${favoriteNumbers.length} بيتاً محفوظاً',
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                for (final number in favoriteNumbers)
                  _FavoriteTile(
                    verse: PoemData.verseByNumber(number),
                    showTashkeel: settings.showTashkeel,
                  ),
              ],
            ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  final Verse verse;
  final bool showTashkeel;

  const _FavoriteTile({required this.verse, required this.showTashkeel});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final library = context.watch<LibraryProvider>();
    final section = PoemData.sectionOf(verse.number);
    final note = library.noteOf(verse.number);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VerseDetailScreen(verse: verse, section: section),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: section.color.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${verse.number}',
                  style: TextStyle(
                    color: section.color,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showTashkeel ? verse.full : stripTashkeel(verse.full),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.verseStyle(
                        14.5,
                        color: scheme.onSurface,
                        weight: FontWeight.w700,
                      ),
                    ),
                    if (note != null && note.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.edit_note_rounded,
                              size: 15, color: scheme.tertiary),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              note,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: scheme.tertiary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'إزالة من المفضلة',
                icon: const Icon(Icons.star_rounded, color: _starGold),
                onPressed: () =>
                    context.read<LibraryProvider>().toggleFavorite(verse.number),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  final ColorScheme scheme;

  const _EmptyFavorites({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.star_border_rounded,
                size: 44, color: scheme.primary.withOpacity(0.6)),
          ),
          const SizedBox(height: 18),
          const Text(
            'لا توجد أبيات محفوظة بعد',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'اضغط على النجمة في أي بيت لتحفظه هنا وترجع إليه لاحقاً.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12.5,
                height: 1.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
