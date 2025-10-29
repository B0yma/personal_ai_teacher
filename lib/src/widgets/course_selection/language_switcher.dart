import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/providers/app_state_provider.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:provider/provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final currentLang = appState.locale.languageCode;

    return Row(
      children: [
        _buildLangButton(context, 'ru', currentLang),
        const SizedBox(width: 8),
        _buildLangButton(context, 'en', currentLang),
      ],
    );
  }

  Widget _buildLangButton(BuildContext context, String langCode, String currentLang) {
    final isSelected = langCode == currentLang;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: () {
        Provider.of<AppStateProvider>(context, listen: false)
            .setLocale(Locale(langCode));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? AppTheme.sky500
            : (isDarkMode ? AppTheme.slate700 : AppTheme.slate200),
        foregroundColor: isSelected
            ? Colors.white
            : (isDarkMode ? AppTheme.slate200 : AppTheme.slate700),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      child: Text(langCode.toUpperCase()),
    );
  }
}