import 'package:flutter/material.dart';
import 'package:al_urjuza/models/models.dart';
import 'package:al_urjuza/theme/app_theme.dart';
import 'package:al_urjuza/utils/text_utils.dart';

/// شطر شعري واحد مع تلوين القافية (آخر كلمة) بلون الباب.
class RhymedHemistich extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color baseColor;
  final Color rhymeColor;
  final FontWeight weight;
  final bool underlineRhyme;

  const RhymedHemistich({
    super.key,
    required this.text,
    required this.fontSize,
    required this.baseColor,
    required this.rhymeColor,
    this.weight = FontWeight.w600,
    this.underlineRhyme = true,
  });

  @override
  Widget build(BuildContext context) {
    final parts = splitRhyme(text);
    final body = parts.$1;
    final rhyme = parts.$2;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTheme.verseStyle(fontSize, color: baseColor, weight: weight),
        children: [
          if (body.isNotEmpty) TextSpan(text: '$body '),
          TextSpan(
            text: rhyme,
            style: TextStyle(
              color: rhymeColor,
              fontSize: fontSize * 1.06,
              fontWeight: FontWeight.w800,
              decoration: underlineRhyme
                  ? TextDecoration.underline
                  : TextDecoration.none,
              decorationColor: rhymeColor.withOpacity(0.45),
              decorationThickness: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// عرض البيت كاملاً: الشطران فوق بعض مع تلوين القافية.
class VerseTextWidget extends StatelessWidget {
  final Verse verse;
  final double fontSize;
  final bool showTashkeel;
  final Color baseColor;
  final Color rhymeColor;
  final FontWeight weight;

  const VerseTextWidget({
    super.key,
    required this.verse,
    required this.fontSize,
    required this.showTashkeel,
    required this.baseColor,
    required this.rhymeColor,
    this.weight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    final first =
        showTashkeel ? verse.first : stripTashkeel(verse.first);
    final second =
        showTashkeel ? verse.second : stripTashkeel(verse.second);

    return Column(
      children: [
        RhymedHemistich(
          text: first,
          fontSize: fontSize,
          baseColor: baseColor,
          rhymeColor: rhymeColor,
          weight: weight,
        ),
        SizedBox(height: fontSize * 0.5),
        RhymedHemistich(
          text: second,
          fontSize: fontSize,
          baseColor: baseColor,
          rhymeColor: rhymeColor,
          weight: weight,
        ),
      ],
    );
  }
}
