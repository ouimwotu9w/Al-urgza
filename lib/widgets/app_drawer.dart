import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:al_urjuza/data/poem_data.dart';
import 'package:al_urjuza/screens/search_screen.dart';
import 'package:al_urjuza/screens/quiz_screen.dart';
import 'package:al_urjuza/screens/glossary_screen.dart';
import 'package:al_urjuza/screens/poet_screen.dart';
import 'package:al_urjuza/screens/settings_screen.dart';

/// القائمة الجانبية الرئيسية للتطبيق.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? null : scheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 30, 22, 26),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF283593)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.menu_book_rounded,
                        color: Color(0xFFF0C987), size: 28),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'الأَرْجُوزَة',
                    style: GoogleFonts.amiri(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'أُرْجُوزَةُ المِلَلِ وَالنِّحَلِ — عاصف بن الجمل',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  _DrawerTile(
                    icon: Icons.search_rounded,
                    title: 'البحث في الأرجوزة',
                    subtitle: 'في الأبيات والشروح',
                    onTap: () => _openPage(context, const SearchScreen()),
                  ),
                  _DrawerTile(
                    icon: Icons.quiz_outlined,
                    title: 'اختبار الفهم',
                    subtitle: '10 أسئلة عشوائية',
                    onTap: () => _openPage(context, const QuizScreen()),
                  ),
                  _DrawerTile(
                    icon: Icons.local_library_outlined,
                    title: 'معجم المصطلحات',
                    subtitle: 'شرح الألفاظ الفنية',
                    onTap: () => _openPage(context, const GlossaryScreen()),
                  ),
                  _DrawerTile(
                    icon: Icons.person_outline_rounded,
                    title: 'عن الشاعر',
                    subtitle: '${PoemData.poet} والأرجوزة',
                    onTap: () => _openPage(context, const PoetScreen()),
                  ),
                  const Divider(height: 24, indent: 20, endIndent: 20),
                  _DrawerTile(
                    icon: Icons.settings_outlined,
                    title: 'الإعدادات',
                    subtitle: 'المظهر والخطوط والقراءة',
                    onTap: () => _openPage(context, const SettingsScreen()),
                  ),
                  _DrawerTile(
                    icon: Icons.ios_share_rounded,
                    title: 'مشاركة التطبيق',
                    subtitle: 'انصح بها غيرك',
                    onTap: () {
                      Navigator.pop(context);
                      Share.share(
                        'تطبيق «الأرجوزة» — أرجوزة الملل والنحل للشاعر عاصف بن الجمل، شرحاً وتفريعاً بتصميم Material 3.',
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.info_outline_rounded,
                    title: 'عن التطبيق',
                    subtitle: 'المعلومات والإصدار',
                    onTap: () => _showAbout(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                'الإصدار 1.0.0 • Material 3',
                style: TextStyle(
                  color: scheme.onSurfaceVariant.withOpacity(0.7),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.menu_book_rounded, size: 22),
            SizedBox(width: 8),
            Text('عن التطبيق'),
          ],
        ),
        content: const Text(
          'تطبيق «الأرجوزة» لعرض أرجوزة الملل والنحل للشاعر عاصف بن الجمل مع شرح مفصل لكل بيت، ومعجم مصطلحات، واختبار فهم، وتتبع تقدم القراءة.\n\nالنسخة 1.0.0 — مبنية على Flutter وMaterial 3.',
          style: TextStyle(height: 1.8, fontSize: 13.5),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(0.09),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: scheme.primary, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11.5,
            color: scheme.onSurfaceVariant,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }
}
