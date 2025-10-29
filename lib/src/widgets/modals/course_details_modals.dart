import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';

void showCourseJsonModal(BuildContext context, String jsonString) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.translate('courseJsonTitle')),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: SelectableText(jsonString),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.translate('ok')),
        )
      ],
    ),
  );
}

void showQaModal(BuildContext context, List<Map<String, String>> qaList) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.translate('qaTitle')),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: qaList.length,
          itemBuilder: (context, index) {
            final item = qaList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Q: ${item['question']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("A: ${item['answer']}"),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.translate('ok')),
        )
      ],
    ),
  );
}