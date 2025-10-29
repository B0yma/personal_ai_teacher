import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';

class CourseCard extends StatelessWidget {
  final SavedCourse course;
  final int mistakes;
  final VoidCallback onSelect;
  final VoidCallback onDelete;

  const CourseCard({
    super.key,
    required this.course,
    required this.mistakes,
    required this.onSelect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkMode ? AppTheme.slate800 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppTheme.slate200 : AppTheme.slate700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (mistakes > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.close, color: AppTheme.red500, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        l10n.translate('mistakesCount', args: {'count': mistakes}),
                        style: const TextStyle(
                          color: AppTheme.red500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.green500,
                    ),
                    child: Text(l10n.translate('continue')),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.red500,
                    foregroundColor: Colors.white,
                  ),
                  tooltip: l10n.translate('delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}