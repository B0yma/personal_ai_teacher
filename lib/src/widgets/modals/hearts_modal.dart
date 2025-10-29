import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/utils/app_icons.dart';

void showHeartsModal(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.translate('heartsModalTitle')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.heart, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(l10n.translate('heartsModalText')),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text(l10n.translate('ok')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}