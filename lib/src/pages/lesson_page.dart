import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/models/mistake_coordinate.dart';
import 'package:personal_ai_teacher/src/providers/app_state_provider.dart';
import 'package:personal_ai_teacher/src/providers/lesson_provider.dart';
import 'package:personal_ai_teacher/src/widgets/lesson/lesson_header.dart';
import 'package:personal_ai_teacher/src/widgets/lesson/exercise_renderer.dart';
import 'package:personal_ai_teacher/src/widgets/lesson/lesson_footer.dart';
import 'package:personal_ai_teacher/src/widgets/modals/imperfect_completion_modal.dart';
import 'package:personal_ai_teacher/src/widgets/modals/lesson_failed_modal.dart';
import 'package:personal_ai_teacher/src/widgets/modals/unit_completion_modal.dart';
import 'package:provider/provider.dart';

class LessonPage extends StatelessWidget {
  final String courseId;
  final Lesson lesson;
  final List<MistakeCoordinate>? reviewCoordinates;

  const LessonPage({
    super.key,
    required this.courseId,
    required this.lesson,
    this.reviewCoordinates,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final bool isReviewMode = reviewCoordinates != null;

    return ChangeNotifierProvider(
      create: (context) {
        final lessonProvider = LessonProvider(
          lesson: lesson,
          initialHearts: appState.userProgress.hearts,
          reviewCoordinates: reviewCoordinates,
          onLoseHeart: () {},
          onCorrectAnswerInReview: (_) {},
          onComplete: (_, __) {},
        );

        lessonProvider.onLoseHeartCallback = () {
          if (!isReviewMode) {
            // This is the corrected call. It now passes all necessary info
            // to the AppStateProvider to handle both heart decrement and mistake recording.
            appState.loseHeart(courseId, lesson.id, lessonProvider.currentIndex);
          } else {
            // In review mode, we still decrement the local heart count for the UI,
            // but don't record it as a new mistake.
            appState.loseHeart(courseId, lesson.id, -1); // -1 indicates no new mistake to record
          }
        };
        lessonProvider.onCorrectAnswerInReviewCallback = (coordinate) {
          appState.clearMistake(courseId, coordinate);
        };
        lessonProvider.onCompleteCallback = (xp, mistakeMade) {
          if (!isReviewMode) {
            appState.completeLesson(courseId, lesson.id, xp).then((_) {
              _handleCompletion(context, appState, mistakeMade);
            });
          } else {
            context.pop();
          }
        };

        return lessonProvider;
      },
      child: Consumer<LessonProvider>(
        builder: (context, lessonProvider, child) {
          if (lessonProvider.status == LessonStatus.failed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showLessonFailedModal(context, () {
                context.pop(); // Close modal
                context.pop(); // Go back to course map
              });
            });
          }
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    LessonHeader(
                      progress: lessonProvider.progress,
                      hearts: lessonProvider.hearts,
                    ),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ExerciseRenderer(
                              exercise: lessonProvider.currentExercise,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: LessonFooter(),
          );
        },
      ),
    );
  }

  void _handleCompletion(BuildContext context, AppStateProvider appState, bool mistakeMade) {
    final course = appState.getCourseById(courseId);
    if (course == null) {
      context.pop();
      return;
    }

    final unit = course.courseData.firstWhere((u) => u.lessons.any((l) => l.id == lesson.id));
    final isLastLessonOfUnit = unit.lessons.last.id == lesson.id;

    if (isLastLessonOfUnit) {
      showUnitCompletionModal(context, unit.title, () {
        context.pop(); // Close modal
        context.pop(); // Go back to course map
      });
    } else if (mistakeMade) {
      showImperfectCompletionModal(context, () {
        context.pop(); // Close modal
        context.pop(); // Go back to course map
      });
    } else {
      context.pop(); // Go back to course map
    }
  }
}