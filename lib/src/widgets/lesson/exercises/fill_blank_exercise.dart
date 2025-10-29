import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/providers/lesson_provider.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:provider/provider.dart';

class FillBlankExercise extends StatelessWidget {
  final Map<String, dynamic> data;

  const FillBlankExercise({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final sentence = data['sentence'] as String? ?? '___';
    final parts = sentence.split('___');
    final beforeText = parts[0];
    final afterText = parts.length > 1 ? parts[1] : '';

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      runSpacing: 8.0,
      spacing: 8.0,
      children: [
        Text(beforeText, style: const TextStyle(fontSize: 20)),
        SizedBox(
          width: 150,
          child: TextField(
            onChanged: (value) => lessonProvider.setUserAnswer(value),
            enabled: lessonProvider.feedback == FeedbackState.none,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.sky500, width: 2),
              ),
            ),
          ),
        ),
        Text(afterText, style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}