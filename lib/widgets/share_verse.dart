import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'package:al_urjuza/models/models.dart';
import 'package:al_urjuza/theme/app_theme.dart';

/// أدوات مشاركة البيت: نسخ، نص، أو صورة مصممة.
class ShareVerse {
  ShareVerse._();

  static String shareText(Verse verse) =>
      '${verse.full}\n\nأرجوزة الملل والنحل — للشاعر عاصف بن الجمل (البيت ${verse.number})';

  /// نافذة اختيار طريقة المشاركة.
  static Future<void> showSheet(
    BuildContext context,
    Verse verse,
    PoemSection section,
  ) async {
    final scheme = Theme.of(context).colorScheme;
    final messenger = ScaffoldMessenger.of(context);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'مشاركة البيت ${verse.number}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title: const Text('نسخ النص'),
                subtitle: const Text('للصق في أي مكان'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: shareText(verse)));
                  Navigator.pop(sheetContext);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('تم نسخ البيت بنجاح')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.text_snippet_outlined),
                title: const Text('مشاركة كنص'),
                subtitle: const Text('مع اسم الشاعر ورقم البيت'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await Share.share(shareText(verse));
                },
              ),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: const Text('مشاركة كصورة مصممة'),
                subtitle: const Text('بطاقة أنيقة جاهزة للنشر'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _shareAsImage(context, verse, section);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// توليد صورة البيت ومشاركتها.
  static Future<void> _shareAsImage(
    BuildContext context,
    Verse verse,
    PoemSection section,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final controller = ScreenshotController();
      final bytes = await controller.captureFromWidget(
        _ShareCard(verse: verse, section: section),
        context: context,
        pixelRatio: 3,
        delay: const Duration(milliseconds: 120),
      );
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/urjuza_verse_${verse.number}.png');
      await file.writeAsBytes(bytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: shareText(verse),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('تعذر توليد الصورة، تمت المشاركة كنص')),
      );
      await Share.share(shareText(verse));
    }
  }
}

/// تصميم بطاقة المشاركة: خلفية كحلية فاخرة وخط أميري.
class _ShareCard extends StatelessWidget {
  final Verse verse;
  final PoemSection section;

  const _ShareCard({required this.verse, required this.section});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 640,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 44),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A237E), Color(0xFF0C1138)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFFC9B37E), size: 26),
              const SizedBox(height: 10),
              Text(
                'أُرْجُوزَةُ المِلَلِ وَالنِّحَلِ',
                style: GoogleFonts.amiri(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${section.ordinal} • ${section.title}',
                style: GoogleFonts.cairo(
                  color: Colors.white60,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              Container(width: 110, height: 1, color: Colors.white24),
              const SizedBox(height: 28),
              Text(
                verse.first,
                textAlign: TextAlign.center,
                style: AppTheme.verseStyle(
                  27,
                  color: Colors.white,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                verse.second,
                textAlign: TextAlign.center,
                style: AppTheme.verseStyle(
                  27,
                  color: Colors.white,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              Container(width: 90, height: 1, color: Colors.white24),
              const SizedBox(height: 16),
              Text(
                'الشاعر: عاصف بن الجمل • البيت ${verse.number}',
                style: GoogleFonts.cairo(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
