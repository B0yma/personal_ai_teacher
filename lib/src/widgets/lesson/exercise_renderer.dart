// UPDATED FILE
import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/widgets/lesson/exercises/choose_variant_exercise.dart';
import 'package:personal_ai_teacher/src/widgets/lesson/exercises/fill_blank_exercise.dart';
import 'package:personal_ai_teacher/src/widgets/lesson/exercises/listen_and_select_exercise.dart';
import 'package:personal_ai_teacher/src/widgets/lesson/exercises/listen_and_write_exercise.dart';
import 'package:personal_ai_teacher/src/widgets/lesson/exercises/meaning_assessment_exercise.dart';
import 'package:personal_ai_teacher/src/widgets/lesson/exercises/sentence_assembly_exercise.dart';

class ExerciseRenderer extends StatelessWidget {
  final Exercise exercise;

  const ExerciseRenderer({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (exercise.question.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              exercise.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const SizedBox(height: 32),
        _buildExerciseWidget(),
      ],
    );
  }

  Widget _buildExerciseWidget() {
    switch (exercise.type) {
      case ExerciseType.fillBlank:
        return FillBlankExercise(data: exercise.data);
      case ExerciseType.chooseVariant:
        return ChooseVariantExercise(data: exercise.data);
      case ExerciseType.sentenceAssembly:
        return SentenceAssemblyExercise(data: exercise.data);
      case ExerciseType.listenAndSelect:
        return ListenAndSelectExercise(data: exercise.data);
      case ExerciseType.listenAndWrite:
        return ListenAndWriteExercise(data: exercise.data);
      case ExerciseType.meaningAssessment:
        return MeaningAssessmentExercise(data: exercise.data);
      default:
        return const Text('Unknown exercise type');
    }
  }
}