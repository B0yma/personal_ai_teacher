import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/providers/lesson_provider.dart';
import 'package:personal_ai_teacher/src/services/audio_service.dart';
import 'package:personal_ai_teacher/src/utils/app_icons.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:provider/provider.dart';

class ListenAndSelectExercise extends StatefulWidget {
  final Map<String, dynamic> data;

  const ListenAndSelectExercise({super.key, required this.data});

  @override
  State<ListenAndSelectExercise> createState() => _ListenAndSelectExerciseState();
}

class _ListenAndSelectExerciseState extends State<ListenAndSelectExercise> {
  late List<String> _shuffledOptions;
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    final options = List<String>.from(widget.data['options'] ?? []);
    final correct = Provider.of<LessonProvider>(context, listen: false).correctAnswerText;
    _shuffledOptions = {...options, correct}.toList()..shuffle();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final sentenceToSpeak = widget.data['audio'] as String? ?? widget.data['sentence'] as String? ?? '';

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _audioService.playAudio(sentenceToSpeak),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: AppTheme.sky500,
          ),
          child: const Icon(AppIcons.speaker, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 32),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _shuffledOptions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final option = _shuffledOptions[index];
            final isSelected = lessonProvider.userAnswer == option;
            return ElevatedButton(
              onPressed: lessonProvider.feedback == FeedbackState.none
                  ? () => lessonProvider.setUserAnswer(option)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? (isDarkMode ? AppTheme.slate700 : AppTheme.sky100)
                    : (isDarkMode ? AppTheme.slate800 : Colors.white),
                foregroundColor: isDarkMode ? Colors.white : Colors.black,
                disabledBackgroundColor: isSelected
                    ? (isDarkMode ? AppTheme.slate700 : AppTheme.sky100)
                    : (isDarkMode ? AppTheme.slate800 : Colors.white),
                disabledForegroundColor: isDarkMode ? AppTheme.slate400 : AppTheme.slate500,
                side: BorderSide(
                  color: isSelected ? AppTheme.sky400 : (isDarkMode ? AppTheme.slate600 : AppTheme.slate300),
                  width: 2,
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
              ),
              child: Text(option),
            );
          },
        ),
      ],
    );
  }
}