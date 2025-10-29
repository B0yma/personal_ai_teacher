import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';

void showImperfectCompletionModal(BuildContext context, VoidCallback onClose) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.translate('imperfectCompletionModalTitle')),
        content: Text(l10n.translate('imperfectCompletionModalText')),
        actions: <Widget>[
          TextButton(
            child: Text(l10n.translate('continue')),
            onPressed: onClose,
          ),
        ],
      );
    },
  );
}