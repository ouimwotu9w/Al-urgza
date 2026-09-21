import 'package:flutter/material.dart';
import 'package:al_urjuza/models/models.dart';
import 'package:al_urjuza/data/section_intro.dart';
import 'package:al_urjuza/data/section_ashariyya.dart';
import 'package:al_urjuza/data/section_jahmiyya.dart';
import 'package:al_urjuza/data/section_rafida.dart';
import 'package:al_urjuza/data/section_khawarij.dart';
import 'package:al_urjuza/data/section_qadariyya.dart';
import 'package:al_urjuza/data/section_malahida.dart';
import 'package:al_urjuza/data/section_yahud.dart';
import 'package:al_urjuza/data/section_nasara.dart';
import 'package:al_urjuza/data/section_batiniyya.dart';
import 'package:al_urjuza/data/section_sufiyya.dart';
import 'package:al_urjuza/data/section_conclusion.dart';

/// أبواب الأرجوزة الاثنا عشر بالترتيب.
const List<PoemSection> poemSections = [
  PoemSection(
    id: 'intro',
    ordinal: 'المقدمة',
    title: 'أول المنظومة',
    description: 'الافتتاح والتعريف بخطة المنظومة: أبوابها وعدد أبياتها وفرقها العشر وثمرتها.',
    icon: Icons.menu_book,
    color: Color(0xFF5E35B1),
    verses: sectionIntroVerses,
  ),
  PoemSection(
    id: 'ashariyya',
    ordinal: 'الموضوع الأول',
    title: 'الأشاعرة',
    description: 'في أقوالهم في كلام الله والصفات والاستواء والكسب، وتقديمهم المعقول على المنقول.',
    icon: Icons.account_balance,
    color: Color(0xFF1E88E5),
    verses: sectionAshariyyaVerses,
  ),
  PoemSection(
    id: 'jahmiyya',
    ordinal: 'الموضوع الثاني',
    title: 'الجهمية والمعتزلة',
    description: 'في تعطيل الجهم للصفات وقوله خلق القرآن، وقواعد المعتزلة الخمس ومسائلهم.',
    icon: Icons.psychology,
    color: Color(0xFF00897B),
    verses: sectionJahmiyyaVerses,
  ),
  PoemSection(
    id: 'rafida',
    ordinal: 'الموضوع الثالث',
    title: 'الرافضة',
    description: 'في قولهم في الصحابة الكرام وعصمة الأئمة والتقية وما يتصل بها من البدع.',
    icon: Icons.groups,
    color: Color(0xFF6D4C41),
    verses: sectionRafidaVerses,
  ),
  PoemSection(
    id: 'khawarij',
    ordinal: 'الموضوع الرابع',
    title: 'الخوارج',
    description: 'في تكفيرهم بالذنوب واستحلالهم الدماء، وصفة النبي صلى الله عليه وسلم لهم.',
    icon: Icons.gavel,
    color: Color(0xFFE53935),
    verses: sectionKhawarijVerses,
  ),
  PoemSection(
    id: 'qadariyya',
    ordinal: 'الموضوع الخامس',
    title: 'القدرية والمرجئة',
    description: 'في نفيهم للقدر أو للعمل، والوسطية بينهما على منهج أهل السنة.',
    icon: Icons.balance,
    color: Color(0xFF3949AB),
    verses: sectionQadariyyaVerses,
  ),
  PoemSection(
    id: 'malahida',
    ordinal: 'الموضوع السادس',
    title: 'الملاحدة والدهرية',
    description: 'في جحدهم للصانع وصفة العالم بالصدفة وإنكارهم للبعث والروح.',
    icon: Icons.cloud_off,
    color: Color(0xFF546E7A),
    verses: sectionMalahidaVerses,
  ),
  PoemSection(
    id: 'yahud',
    ordinal: 'الموضوع السابع',
    title: 'اليهود',
    description: 'في ما ورد ذمهم على سبيل التحريف والقتل والغلو، وما ثبت في القرآن من ذلك.',
    icon: Icons.history_edu,
    color: Color(0xFF0288D1),
    verses: sectionYahudVerses,
  ),
  PoemSection(
    id: 'nasara',
    ordinal: 'الموضوع الثامن',
    title: 'النصارى',
    description: 'في قولهم بالتثليث والتجسد والفداء، ونفي القرآن لصلب المسيح عليه السلام.',
    icon: Icons.church,
    color: Color(0xFF7B1FA2),
    verses: sectionNasaraVerses,
  ),
  PoemSection(
    id: 'batiniyya',
    ordinal: 'الموضوع التاسع',
    title: 'الباطنية والإسماعيلية',
    description: 'في دعوى الباطن وإسقاط الشريعة به، وسيرتهم في التاريخ من القرامطة إلى اليوم.',
    icon: Icons.visibility_off,
    color: Color(0xFFC2185B),
    verses: sectionBatiniyyaVerses,
  ),
  PoemSection(
    id: 'sufiyya',
    ordinal: 'الموضوع العاشر',
    title: 'غلاة الصوفية والحلولية',
    description: 'في الحلول والاتحاد ووحدة الوجود والشطحات، وما ورد في ذلك من الحكم.',
    icon: Icons.self_improvement,
    color: Color(0xFF00695C),
    verses: sectionSufiyyaVerses,
  ),
  PoemSection(
    id: 'conclusion',
    ordinal: 'الخاتمة',
    title: 'تمام المنظومة',
    description: 'التمام والحمد والصلاة، والوصية بالإمساك بهدى الكتاب والسنة.',
    icon: Icons.verified,
    color: Color(0xFFEF6C00),
    verses: sectionConclusionVerses,
  ),
];

/// مركز البيانات العامة للأرجوزة.
class PoemData {
  PoemData._();

  static const String title = 'أُرْجُوزَةُ المِلَلِ وَالنِّحَلِ';
  static const String poet = 'عاصف بن الجمل';
  static const int totalVerses = 200;

  /// جميع الأبيات الـ200 بالترتيب.
  static List<Verse> get allVerses {
    final result = <Verse>[];
    for (final s in poemSections) {
      result.addAll(s.verses);
    }
    return result;
  }

  /// البحث عن بيت برقمه.
  static Verse verseByNumber(int number) {
    for (final s in poemSections) {
      for (final v in s.verses) {
        if (v.number == number) return v;
      }
    }
    return poemSections.first.verses.first;
  }

  /// الباب الذي يقع فيه رقم البيت.
  static PoemSection sectionOf(int number) {
    for (final s in poemSections) {
      if (number >= s.startNumber && number <= s.endNumber) return s;
    }
    return poemSections.first;
  }

  /// البحث عن باب بمعرفه.
  static PoemSection sectionById(String id) {
    for (final s in poemSections) {
      if (s.id == id) return s;
    }
    return poemSections.first;
  }
}
