import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:al_urjuza/data/poet_data.dart';
import 'package:al_urjuza/data/poem_data.dart';

/// شاشة «عن الشاعر»: التعريف بالشاعر والأرجوزة وبناؤها الفني.
class PoetScreen extends StatelessWidget {
  const PoetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('عن الشاعر'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
        children: [
          // بطاقة الشاعر
          Container(
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
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_rounded,
                      color: Color(0xFFF0C987), size: 36),
                ),
                const SizedBox(height: 14),
                Text(
                  poetInfo.name,
                  style: GoogleFonts.amiri(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'صاحب ${poetInfo.poemTitle}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // السيرة
          _InfoCard(
            title: 'التعريف',
            icon: Icons.person_outline_rounded,
            child: Text(
              poetInfo.bio,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 13.5,
                height: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // البناء العروضي
          _InfoCard(
            title: 'البناء الفني',
            icon: Icons.straighten_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BulletRow(
                  icon: Icons.music_note_rounded,
                  text: poetInfo.meterNote,
                ),
                const SizedBox(height: 10),
                _BulletRow(
                  icon: Icons.auto_fix_high_rounded,
                  text: poetInfo.rhymeNote,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // أبرز الملامح
          _InfoCard(
            title: 'أبرز ملامح الأرجوزة',
            icon: Icons.star_outline_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final highlight in poetInfo.highlights)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 16, color: scheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            highlight,
                            style: TextStyle(
                              color: scheme.onSurface,
                              fontSize: 12.5,
                              height: 1.7,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // بطاقة أرقام
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: scheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NumberStat(value: '${PoemData.totalVerses}', label: 'بيتاً'),
                  _divider(scheme),
                  _NumberStat(value: '12', label: 'باباً'),
                  _divider(scheme),
                  _NumberStat(value: '10', label: 'فرقاً'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(ColorScheme scheme) {
    return Container(
      width: 1,
      height: 34,
      color: scheme.outlineVariant,
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                  child: Icon(icon, size: 17, color: scheme.primary),
                ),
                const SizedBox(width: 9),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 14.5),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BulletRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: scheme.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 12.5,
              height: 1.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _NumberStat extends StatelessWidget {
  final String value;
  final String label;

  const _NumberStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w900,
            color: scheme.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
