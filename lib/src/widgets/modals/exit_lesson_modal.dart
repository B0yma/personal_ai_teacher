import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';

void showExitLessonModal(BuildContext context, VoidCallback onConfirm) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.translate('exitLessonTitle')),
        content: Text(l10n.translate('exitLessonText')),
        actions: <Widget>[
          TextButton(
            child: Text(l10n.translate('stayInLesson')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(l10n.translate('leave')),
            onPressed: onConfirm,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      );
    },
  );
}