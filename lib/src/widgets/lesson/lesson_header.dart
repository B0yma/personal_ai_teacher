import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_ai_teacher/src/utils/app_icons.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:personal_ai_teacher/src/widgets/modals/exit_lesson_modal.dart';

class LessonHeader extends StatelessWidget {
  final double progress;
  final int hearts;

  const LessonHeader({
    super.key,
    required this.progress,
    required this.hearts,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final progressBackgroundColor = isDarkMode ? AppTheme.slate700 : AppTheme.slate200;

    return Row(
      children: [
        IconButton(
          icon: const Icon(AppIcons.close, color: AppTheme.slate400),
          onPressed: () => showExitLessonModal(
            context,
            () {
              Navigator.of(context).pop(); // Close modal
              context.pop(); // Go back to course map
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: progressBackgroundColor,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.green500),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Icon(AppIcons.heart, color: AppTheme.red500, size: 24),
        const SizedBox(width: 4),
        Text(
          hearts.toString(),
          style: const TextStyle(
            color: AppTheme.red500,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}