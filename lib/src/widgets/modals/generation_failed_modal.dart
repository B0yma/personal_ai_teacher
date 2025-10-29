import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';

void showGenerationFailedModal(BuildContext context, VoidCallback onClose) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.translate('generationFailedTitle')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(l10n.translate('generationFailedText')),
          ],
        ),
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