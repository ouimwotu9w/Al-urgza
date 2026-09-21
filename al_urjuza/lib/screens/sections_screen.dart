import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:al_urjuza/data/poem_data.dart';
import 'package:al_urjuza/providers/progress_provider.dart';
import 'package:al_urjuza/widgets/app_drawer.dart';
import 'package:al_urjuza/widgets/section_card.dart';

/// شاشة أبواب الأرجوزة الاثني عشر مع تقدم القراءة العام.
class SectionsScreen extends StatelessWidget {
  const SectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = context.watch<ProgressProvider>();
    final percent = (progress.overallProgress * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('أبواب الأرجوزة'),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: scheme.primary.withOpacity(0.18)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress.overallProgress,
                        strokeWidth: 6.5,
                        backgroundColor: scheme.primary.withOpacity(0.12),
                      ),
                      Text(
                        '$percent%',
                        style: TextStyle(
                          fontSize: 12.5,
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
                        'رحلتك في الأرجوزة',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'قرأت ${progress.readCount} بيتاً من أصل 200 بيت عبر 12 باباً. أكمل قراءتك لتغطية الأرجوزة كاملة.',
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 12,
                          height: 1.7,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          for (final section in poemSections) SectionCard(section: section),
        ],
      ),
    );
  }
}
