import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/utils/app_icons.dart';

void showUnitCompletionModal(BuildContext context, String unitTitle, VoidCallback onClose) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.translate('unitCompleteTitle')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.trophy, color: Colors.amber, size: 64),
            const SizedBox(height: 16),
            Text(l10n.translate('unitCompleteText')),
            const SizedBox(height: 8),
            Text(
              unitTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
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