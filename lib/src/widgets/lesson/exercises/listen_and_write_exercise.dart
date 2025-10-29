import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/providers/lesson_provider.dart';
import 'package:personal_ai_teacher/src/services/audio_service.dart';
import 'package:personal_ai_teacher/src/utils/app_icons.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:provider/provider.dart';

class ListenAndWriteExercise extends StatefulWidget {
  final Map<String, dynamic> data;

  const ListenAndWriteExercise({super.key, required this.data});

  @override
  State<ListenAndWriteExercise> createState() => _ListenAndWriteExerciseState();
}

class _ListenAndWriteExerciseState extends State<ListenAndWriteExercise> {
  final AudioService _audioService = AudioService();

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final l10n = AppLocalizations.of(context);

    // Prioritize the 'audio' key for TTS, fall back to 'sentence'.
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
        TextField(
          onChanged: (value) => lessonProvider.setUserAnswer(value),
          enabled: lessonProvider.feedback == FeedbackState.none,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.translate('listenWritePlaceholder'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}