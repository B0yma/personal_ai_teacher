import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';

void showDeleteCourseModal(BuildContext context, {required String courseTitle, required VoidCallback onConfirm}) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.translate('deleteCourseTitle')),
        content: Text(l10n.translate('deleteCourseConfirmation', args: {'courseTitle': courseTitle})),
        actions: <Widget>[
          TextButton(
            child: Text(l10n.translate('cancel')),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(l10n.translate('delete')),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      );
    },
  );
}