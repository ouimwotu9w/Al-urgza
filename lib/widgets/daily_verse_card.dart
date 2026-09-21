import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_urjuza/models/models.dart';
import 'package:al_urjuza/providers/settings_provider.dart';
import 'package:al_urjuza/screens/verse_detail_screen.dart';
import 'package:al_urjuza/widgets/verse_text.dart';

/// بطاقة «بيت اليوم» في الرئيسية بخلفية كحلية مميزة.
class DailyVerseCard extends StatelessWidget {
  final Verse verse;
  final PoemSection section;

  const DailyVerseCard({super.key, required this.verse, required this.section});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF0C1138)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(26),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    VerseDetailScreen(verse: verse, section: section),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wb_twilight_rounded,
                              color: Color(0xFFF0C987), size: 15),
                          const SizedBox(width: 5),
                          Text(
                            'بيت اليوم',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'البيت ${verse.number}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                VerseTextWidget(
                  verse: verse,
                  fontSize: 19,
                  showTashkeel: settings.showTashkeel,
                  baseColor: Colors.white,
                  rhymeColor: const Color(0xFFF0C987),
                  weight: FontWeight.w700,
                ),
                const SizedBox(height: 16),
                Text(
                  verse.explanation,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12.5,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VerseDetailScreen(
                              verse: verse, section: section),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chrome_reader_mode_outlined,
                        size: 17),
                    label: const Text(
                      'اقرأ الشرح كاملاً',
                      style: TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w800),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFF0C987),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
