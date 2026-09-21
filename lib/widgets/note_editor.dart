import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_urjuza/providers/library_provider.dart';

/// نافذة تحرير الملاحظة الشخصية على بيت.
Future<void> showNoteEditor(BuildContext context, int verseNumber) async {
  final library = context.read<LibraryProvider>();
  final controller =
      TextEditingController(text: library.noteOf(verseNumber) ?? '');
  final messenger = ScaffoldMessenger.of(context);
  final scheme = Theme.of(context).colorScheme;

  final saved = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('ملاحظة على البيت $verseNumber'),
      content: TextField(
        controller: controller,
        maxLines: 5,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'اكتب فكرتك أو تثبيتك هنا...',
          filled: true,
          fillColor: scheme.primaryContainer.withOpacity(0.3),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('حفظ'),
        ),
      ],
    ),
  );

  if (saved == true) {
    library.setNote(verseNumber, controller.text);
    messenger.showSnackBar(
      SnackBar(
        content: Text(library.hasNote(verseNumber)
            ? 'تم حفظ الملاحظة'
            : 'تم حذف الملاحظة'),
      ),
    );
  }
}
