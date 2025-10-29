import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/providers/lesson_provider.dart';
import 'package:provider/provider.dart';

class MeaningAssessmentExercise extends StatelessWidget {
  final Map<String, dynamic> data;

  const MeaningAssessmentExercise({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final l10n = AppLocalizations.of(context);

    // The AI model might place the primary text in 'context' or 'correct_idea'.
    // This logic robustly finds the text to display.
    final contextText = data['context'] as String? ?? data['correct_idea'] as String? ?? '';

    return Column(
      children: [
        if (contextText.isNotEmpty) ...[
          Text(
            '${l10n.translate('context')}: "$contextText"',
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],
        TextField(
          onChanged: (value) => lessonProvider.setUserAnswer(value),
          enabled: lessonProvider.feedback == FeedbackState.none,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: l10n.translate('meaningAssessmentPlaceholder'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}