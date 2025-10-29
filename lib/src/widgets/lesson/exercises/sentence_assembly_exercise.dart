import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/models/word_token.dart';
import 'package:personal_ai_teacher/src/providers/lesson_provider.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:provider/provider.dart';

class SentenceAssemblyExercise extends StatefulWidget {
  final Map<String, dynamic> data;

  const SentenceAssemblyExercise({super.key, required this.data});

  @override
  State<SentenceAssemblyExercise> createState() => _SentenceAssemblyExerciseState();
}

class _SentenceAssemblyExerciseState extends State<SentenceAssemblyExercise> {
  late List<WordToken> _wordPool;

  @override
  void initState() {
    super.initState();
    final words = List<String>.from(widget.data['words'] ?? []);
    _wordPool = words.map((word) => WordToken(word: word)).toList()..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectedTokens = (lessonProvider.userAnswer as List<WordToken>?) ?? [];

    final availableTokens = _wordPool
        .where((poolToken) => !selectedTokens.any((selected) => selected.id == poolToken.id))
        .toList();

    return Column(
      children: [
        // This Column separates the word area from the line itself.
        Column(
          children: [
            // Container for the selected words.
            Container(
              constraints: const BoxConstraints(minHeight: 90),
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedTokens.map((token) {
                  return ElevatedButton(
                    onPressed: () {
                      final newAnswer = List<WordToken>.from(selectedTokens)..remove(token);
                      lessonProvider.setUserAnswer(newAnswer);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? AppTheme.slate700 : AppTheme.slate200,
                    ),
                    child: Text(token.word),
                  );
                }).toList(),
              ),
            ),
            // The horizontal line, now always positioned below the words.
            Container(
              height: 2,
              width: double.infinity,
              color: isDarkMode ? AppTheme.slate700 : AppTheme.slate300,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Container for the available word choices.
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: availableTokens.map((token) {
            return ElevatedButton(
              onPressed: lessonProvider.feedback == FeedbackState.none
                  ? () {
                final newAnswer = List<WordToken>.from(selectedTokens)..add(token);
                lessonProvider.setUserAnswer(newAnswer);
              }
                  : null,
              child: Text(token.word),
            );
          }).toList(),
        ),
      ],
    );
  }
}