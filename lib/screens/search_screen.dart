import 'package:flutter/material.dart';
import 'package:al_urjuza/data/glossary_data.dart';
import 'package:al_urjuza/data/poem_data.dart';
import 'package:al_urjuza/models/models.dart';
import 'package:al_urjuza/screens/verse_detail_screen.dart';
import 'package:al_urjuza/theme/app_theme.dart';
import 'package:al_urjuza/utils/text_utils.dart';

/// البحث الشامل في الأبيات والشروح ومصطلحات المعجم.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final normalized = normalizeArabic(_query.trim());

    List<Verse> verseResults = [];
    List<GlossaryTerm> termResults = [];

    if (normalized.isNotEmpty) {
      for (final verse in PoemData.allVerses) {
        if (matchesQuery(verse.searchText, normalized)) {
          verseResults.add(verse);
        }
      }
      for (final term in glossaryTerms) {
        if (matchesQuery('${term.term} ${term.definition}', normalized)) {
          termResults.add(term);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث في الأرجوزة'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'ابحث في الأبيات والشروح والمصطلحات...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      ),
                filled: true,
                fillColor: scheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: scheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: scheme.outlineVariant),
                ),
              ),
            ),
          ),
          Expanded(
            child: normalized.isEmpty
                ? _SearchHint(scheme: scheme)
                : ListView(
                    padding: const EdgeInsets.only(bottom: 30),
                    children: [
                      if (termResults.isNotEmpty) ...[
                        _ResultHeader(
                            title: 'المصطلحات (${termResults.length})'),
                        for (final term in termResults)
                          _TermTile(term: term),
                      ],
                      if (verseResults.isNotEmpty) ...[
                        _ResultHeader(title: 'الأبيات (${verseResults.length})'),
                        for (final verse in verseResults)
                          _VerseResultTile(verse: verse),
                      ],
                      if (termResults.isEmpty && verseResults.isEmpty)
                        _NoResults(scheme: scheme),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  final ColorScheme scheme;

  const _SearchHint({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.manage_search_rounded,
              size: 52, color: scheme.primary.withOpacity(0.5)),
          const SizedBox(height: 14),
          Text(
            'اكتب كلمة للبحث في الـ 200 بيت\nوالشروح ومعجم المصطلحات',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 13,
              height: 1.9,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['التعطيل', 'الكسب', 'الصليب', 'التقية']
                .map(
                  (word) => ActionChip(
                    label: Text(word, style: const TextStyle(fontSize: 12)),
                    onPressed: () {},
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  final String title;

  const _ResultHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _VerseResultTile extends StatelessWidget {
  final Verse verse;

  const _VerseResultTile({required this.verse});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final section = PoemData.sectionOf(verse.number);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'البيت ${verse.number} • ${section.title}',
                style: TextStyle(
                  color: section.color,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                verse.full,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.verseStyle(
                  14.5,
                  color: scheme.onSurface,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermTile extends StatelessWidget {
  final GlossaryTerm term;

  const _TermTile({required this.term});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: scheme.tertiary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.local_offer_outlined,
              color: scheme.tertiary, size: 19),
        ),
        title: Text(
          term.term,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
        subtitle: Text(
          term.definition,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11.5,
            color: scheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(term.term),
              content: SingleChildScrollView(
                child: Text(
                  term.definition,
                  style: const TextStyle(height: 1.9, fontSize: 13.5),
                ),
              ),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('حسناً'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final ColorScheme scheme;

  const _NoResults({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded,
                size: 48, color: scheme.onSurfaceVariant.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text(
              'لا توجد نتائج مطابقة',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'جرب كلمة أقصر أو بلا تشكيل',
              style: TextStyle(
                color: scheme.onSurfaceVariant.withOpacity(0.8),
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
