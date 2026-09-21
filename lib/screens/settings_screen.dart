import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:al_urjuza/providers/library_provider.dart';
import 'package:al_urjuza/providers/progress_provider.dart';
import 'package:al_urjuza/providers/settings_provider.dart';

/// شاشة الإعدادات: المظهر، الخطوط، القراءة، وإعادة التعيين.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final settings = context.watch<SettingsProvider>();
    final progress = context.watch<ProgressProvider>();
    final library = context.watch<LibraryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 30),
        children: [
          _SectionTitle('المظهر'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: scheme.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: settings.themeMode,
                  onChanged: (mode) {
                    if (mode != null) settings.setThemeMode(mode);
                  },
                  title: const Text('حسب النظام',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  subtitle: const Text('يتبع إعداد الجهاز تلقائياً',
                      style: TextStyle(fontSize: 11.5)),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: settings.themeMode,
                  onChanged: (mode) {
                    if (mode != null) settings.setThemeMode(mode);
                  },
                  title: const Text('فاتح',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  subtitle: const Text('أبيض وألوان مشرقة',
                      style: TextStyle(fontSize: 11.5)),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: settings.themeMode,
                  onChanged: (mode) {
                    if (mode != null) settings.setThemeMode(mode);
                  },
                  title: const Text('داكن',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  subtitle: const Text('خلفيات كحلية أنيقة',
                      style: TextStyle(fontSize: 11.5)),
                ),
              ],
            ),
          ),
          _SectionTitle('الخط والقراءة'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: scheme.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
                  child: Row(
                    children: [
                      const Text(
                        'حجم خط النصوص',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        '${(settings.fontScale * 100).round()}%',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: settings.fontScale,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  label: '${(settings.fontScale * 100).round()}%',
                  onChanged: settings.setFontScale,
                ),
                SwitchListTile(
                  value: settings.showTashkeel,
                  onChanged: settings.setShowTashkeel,
                  title: const Text('إظهار التشكيل',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  subtitle: const Text('إخفاؤه يسهّل القراءة السريعة',
                      style: TextStyle(fontSize: 11.5)),
                ),
              ],
            ),
          ),
          _SectionTitle('بياناتك'),
          Card(
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
                  Text(
                    'قرأت ${progress.readCount} بيتاً، حفظت ${library.favorites.length} بيتاً في المفضلة، وكتبت ${library.countNotes()} ملاحظة.',
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12.5,
                      height: 1.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.error,
                      side: BorderSide(color: scheme.error.withOpacity(0.5)),
                    ),
                    onPressed: () => _confirmReset(context),
                    icon: const Icon(Icons.restart_alt_rounded, size: 18),
                    label: const Text('إعادة تعيين تقدم القراءة',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    final progress = context.read<ProgressProvider>();
    final messenger = ScaffoldMessenger.of(context);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إعادة التعيين؟'),
        content: const Text(
          'سيتم مسح سجل الأبيات المقروءة وآخر موضع قراءة. المفضلة والملاحظات لن تتأثر.',
          style: TextStyle(height: 1.8),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              progress.resetAll();
              Navigator.pop(dialogContext);
              messenger.showSnackBar(
                const SnackBar(content: Text('تمت إعادة تعيين تقدم القراءة')),
              );
            },
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 18, 6, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
