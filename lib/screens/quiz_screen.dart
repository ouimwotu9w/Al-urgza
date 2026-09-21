import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:al_urjuza/data/quiz_data.dart';
import 'package:al_urjuza/models/models.dart';
import 'package:al_urjuza/providers/progress_provider.dart';

/// اختبار الفهم: 10 أسئلة عشوائية من بنك أسئلة الأرجوزة.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const int questionsPerRound = 10;

  String _phase = 'intro'; // intro / question / result
  late List<QuizQuestion> _questions;
  int _index = 0;
  int _score = 0;
  int? _selected;

  @override
  void initState() {
    super.initState();
    _questions = _pickQuestions();
  }

  List<QuizQuestion> _pickQuestions() {
    final pool = List<QuizQuestion>.from(quizQuestions)..shuffle(Random());
    if (pool.length <= questionsPerRound) return pool;
    return pool.sublist(0, questionsPerRound);
  }

  void _startQuiz() {
    setState(() {
      _questions = _pickQuestions();
      _index = 0;
      _score = 0;
      _selected = null;
      _phase = 'question';
    });
  }

  void _answer(int optionIndex) {
    if (_selected != null) return;
    final question = _questions[_index];
    final correct = optionIndex == question.correctIndex;
    setState(() => _selected = optionIndex);
    if (correct) _score++;
  }

  void _next() {
    if (_index + 1 >= _questions.length) {
      context.read<ProgressProvider>().updateQuizBest(_score);
      setState(() => _phase = 'result');
    } else {
      setState(() {
        _index++;
        _selected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار الفهم'),
      ),
      body: switch (_phase) {
        'intro' => _buildIntro(scheme),
        'question' => _buildQuestion(scheme),
        _ => _buildResult(scheme),
      },
    );
  }

  Widget _buildIntro(ColorScheme scheme) {
    final progress = context.watch<ProgressProvider>();
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A237E).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child:
                  const Icon(Icons.quiz_rounded, color: Colors.white, size: 46),
            ),
            const SizedBox(height: 22),
            const Text(
              'اختبر فهمك للأرجوزة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              '10 أسئلة عشوائية من أرجوزة الملل والنحل:\nأبوابها، أقوالها، ومصطلحاتها. في كل جولة أسئلة جديدة!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 13,
                height: 1.9,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: scheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events_outlined,
                      color: scheme.secondary, size: 18),
                  const SizedBox(width: 7),
                  Text(
                    'أفضل نتيجة: ${progress.quizBest}/$questionsPerRound',
                    style: TextStyle(
                      color: scheme.secondary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            FilledButton.icon(
              onPressed: _startQuiz,
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('ابدأ الاختبار',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(ColorScheme scheme) {
    final question = _questions[_index];
    final answered = _selected != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
      children: [
        // شريط التقدم
        Row(
          children: [
            Text(
              'السؤال ${_index + 1} من ${_questions.length}',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Text(
              'النقاط: $_score',
              style: TextStyle(
                color: scheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (_index + 1) / _questions.length,
            minHeight: 7,
            backgroundColor: scheme.primary.withOpacity(0.12),
          ),
        ),
        const SizedBox(height: 18),
        // نص السؤال
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.primary.withOpacity(0.2)),
          ),
          child: Text(
            question.question,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // الخيارات
        for (var i = 0; i < question.options.length; i++)
          _OptionCard(
            label: question.options[i],
            state: _optionState(question, i),
            onTap: () => _answer(i),
          ),
        // التغذية الراجعة
        if (answered) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _selected == question.correctIndex
                  ? Colors.green.withOpacity(0.09)
                  : scheme.error.withOpacity(0.09),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _selected == question.correctIndex
                    ? Colors.green.withOpacity(0.4)
                    : scheme.error.withOpacity(0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _selected == question.correctIndex
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 18,
                      color: _selected == question.correctIndex
                          ? Colors.green
                          : scheme.error,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      _selected == question.correctIndex
                          ? 'أحسنت! إجابة صحيحة'
                          : 'إجابة غير صحيحة',
                      style: TextStyle(
                        color: _selected == question.correctIndex
                            ? Colors.green
                            : scheme.error,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  question.explanation,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12.5,
                    height: 1.8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _next,
            icon: Icon(
              _index + 1 >= _questions.length
                  ? Icons.emoji_events_outlined
                  : Icons.arrow_back_rounded,
              size: 18,
            ),
            label: Text(
              _index + 1 >= _questions.length ? 'عرض النتيجة' : 'السؤال التالي',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ],
    );
  }

  int _optionState(QuizQuestion question, int index) {
    if (_selected == null) return 0; // لم تُجب بعد
    if (index == question.correctIndex) return 1; // الصحيح
    if (index == _selected) return 2; // المختار الخاطئ
    return 3; // باقي الخيارات
  }

  Widget _buildResult(ColorScheme scheme) {
    final percent = (_score / _questions.length * 100).round();
    String message;
    IconData icon;
    Color color;
    if (percent >= 90) {
      message = 'ممتاز! أنت متمكن من الأرجوزة تماماً';
      icon = Icons.emoji_events_rounded;
      color = Colors.amber.shade700;
    } else if (percent >= 70) {
      message = 'جيد جداً! راجع ما فاتك من الأبواب';
      icon = Icons.thumb_up_rounded;
      color = Colors.green;
    } else if (percent >= 50) {
      message = 'لا بأس، عد إلى الأبواب واقرأها مرة أخرى';
      icon = Icons.menu_book_rounded;
      color = scheme.primary;
    } else {
      message = 'تحتاج إلى مزيد من القراءة... ابدأ من المقدمة';
      icon = Icons.auto_stories_rounded;
      color = scheme.error;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
                border: Border.all(color: color.withOpacity(0.5), width: 3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_score/${_questions.length}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15.5, fontWeight: FontWeight.w800, height: 1.6),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: _startQuiz,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('إعادة الاختبار',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => setState(() => _phase = 'intro'),
                  child: const Text('الرجوع',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة خيار في السؤال مع تمييز صح/خطأ.
class _OptionCard extends StatelessWidget {
  final String label;
  final int state; // 0 عادي، 1 صحيح، 2 مختار خاطئ، 3 مطفأ
  final VoidCallback onTap;

  const _OptionCard({
    required this.label,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color? fillColor;
    Color? borderColor;
    Color? textColor;
    IconData? trailing;

    switch (state) {
      case 1:
        fillColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
        textColor = Colors.green;
        trailing = Icons.check_circle_rounded;
        break;
      case 2:
        fillColor = scheme.error.withOpacity(0.1);
        borderColor = scheme.error;
        textColor = scheme.error;
        trailing = Icons.cancel_rounded;
        break;
      case 3:
        fillColor = null;
        borderColor = scheme.outlineVariant.withOpacity(0.5);
        textColor = scheme.onSurfaceVariant;
        break;
      default:
        fillColor = scheme.surface;
        borderColor = scheme.outlineVariant;
        textColor = scheme.onSurface;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: fillColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: state == 0 ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor ?? Colors.transparent),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      height: 1.6,
                    ),
                  ),
                ),
                if (trailing != null) Icon(trailing, size: 19, color: textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
