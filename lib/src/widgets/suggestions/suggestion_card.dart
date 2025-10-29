import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';

class SuggestionCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const SuggestionCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.slate800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDarkMode ? AppTheme.slate700 : AppTheme.slate200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Allow the card to determine its own height
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.purple500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? AppTheme.slate400 : AppTheme.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}