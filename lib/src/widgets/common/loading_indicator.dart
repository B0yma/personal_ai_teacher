import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.sky500),
          ),
          const SizedBox(height: 24),
          Text(
            message ?? l10n.translate('loading'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppTheme.slate200 : AppTheme.slate700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.translate('loadingSubtext'),
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? AppTheme.slate400 : AppTheme.slate500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}