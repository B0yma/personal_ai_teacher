import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/providers/lesson_provider.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:provider/provider.dart';

class LessonFooter extends StatelessWidget {
  const LessonFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor;
    Color buttonColor;
    String buttonText;
    VoidCallback? onPressed;

    final isAnswerEmpty = (lessonProvider.userAnswer is String && (lessonProvider.userAnswer as String).trim().isEmpty) ||
        (lessonProvider.userAnswer is List && (lessonProvider.userAnswer as List).isEmpty) ||
        lessonProvider.userAnswer == null;

    switch (lessonProvider.feedback) {
      case FeedbackState.none:
        backgroundColor = isDarkMode ? AppTheme.slate900 : AppTheme.slate50;
        buttonColor = AppTheme.sky500;
        buttonText = lessonProvider.isChecking
            ? l10n.translate('checking')
            : l10n.translate('check');
        onPressed = lessonProvider.isChecking || isAnswerEmpty
            ? null
            : lessonProvider.checkAnswer;
        break;
      case FeedbackState.correct:
        backgroundColor = isDarkMode ? AppTheme.green100.withOpacity(0.1) : AppTheme.green100;
        buttonColor = AppTheme.green500;
        buttonText = l10n.translate('continue');
        onPressed = lessonProvider.handleContinue;
        break;
      case FeedbackState.incorrect:
        backgroundColor = isDarkMode ? AppTheme.red100.withOpacity(0.1) : AppTheme.red100;
        buttonColor = AppTheme.red500;
        buttonText = l10n.translate('continue');
        onPressed = lessonProvider.handleContinue;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: backgroundColor,
      padding: const EdgeInsets.all(16.0).copyWith(bottom: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lessonProvider.feedback != FeedbackState.none)
            _buildFeedbackText(context, l10n, lessonProvider),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                // Use theme-defined disabled colors by not specifying them here
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackText(BuildContext context, AppLocalizations l10n, LessonProvider lessonProvider) {
    final isCorrect = lessonProvider.feedback == FeedbackState.correct;
    final titleText = isCorrect ? l10n.translate('correct') : l10n.translate('incorrect');
    final titleColor = isCorrect ? AppTheme.green600 : AppTheme.red600;

    String? detailText;
    if (!isCorrect) {
      final key = lessonProvider.currentExercise.type == 'MEANING_ASSESSMENT' ? 'expectedIdea' : 'correctAnswer';
      detailText = l10n.translate(key, args: {'answer': lessonProvider.correctAnswerText, 'idea': lessonProvider.correctAnswerText});
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          if (detailText != null) ...[
            const SizedBox(height: 4),
            Text(
              detailText,
              style: const TextStyle(fontSize: 16),
            ),
          ]
        ],
      ),
    );
  }
}