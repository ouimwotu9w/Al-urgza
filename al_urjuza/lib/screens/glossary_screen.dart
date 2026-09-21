import 'package:flutter/material.dart';
import 'package:al_urjuza/data/glossary_data.dart';
import 'package:al_urjuza/models/models.dart';

/// معجم المصطلحات الفنية الواردة في الأرجوزة.
class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final filtered = glossaryTerms
        .where((t) =>
            _query.isEmpty ||
            t.term.contains(_query) ||
            t.definition.contains(_query) ||
            t.sectionHint.contains(_query))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('معجم المصطلحات'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'ابحث عن مصطلح...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: scheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: scheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: scheme.outlineVariant),
                ),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'لا يوجد مصطلح مطابق',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.only(bottom: 30),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
                        child: Text(
                          '${filtered.length} مصطلحاً',
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      for (final term in filtered)
                        _TermCard(term: term),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _TermCard extends StatelessWidget {
  final GlossaryTerm term;

  const _TermCard({required this.term});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_offer_outlined,
                color: scheme.primary, size: 19),
          ),
          title: Text(
            term.term,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5),
          ),
          subtitle: Text(
            term.sectionHint,
            style: TextStyle(
              color: scheme.primary.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                term.definition,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 13,
                  height: 1.9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
