import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';

void showLessonFailedModal(BuildContext context, VoidCallback onClose) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.translate('lessonFailedModalTitle')),
        content: Text(l10n.translate('lessonFailedModalText')),
        actions: <Widget>[
          TextButton(
            child: Text(l10n.translate('ok')),
            onPressed: onClose,
          ),
        ],
      );
    },
  );
}