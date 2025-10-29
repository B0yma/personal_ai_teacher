import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/providers/app_state_provider.dart';
import 'package:personal_ai_teacher/src/routing/app_router.dart';
import 'package:personal_ai_teacher/src/utils/constants.dart';
import 'package:personal_ai_teacher/src/widgets/common/header.dart';
import 'package:personal_ai_teacher/src/widgets/common/loading_indicator.dart';
import 'package:personal_ai_teacher/src/widgets/course_map/unit_section.dart';
import 'package:personal_ai_teacher/src/widgets/modals/course_details_modals.dart';
import 'package:personal_ai_teacher/src/widgets/modals/hearts_modal.dart';
import 'package:provider/provider.dart';

class CourseMapPage extends StatelessWidget {
  final String courseId;

  const CourseMapPage({super.key, required this.courseId});

  void _startReviewLesson(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    if (appState.userProgress.hearts <= 0) {
      showHeartsModal(context);
      return;
    }

    final reviewData = appState.createMistakesLesson(courseId);
    if (reviewData != null) {
      context.push(
        AppRouter.lessonPath
            .replaceFirst(':courseId', courseId)
            .replaceFirst(':lessonId', (reviewData['lesson'] as Lesson).id),
        extra: reviewData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final course = appState.getCourseById(courseId);
        final userProgress = appState.userProgress;
        final mistakes = userProgress.mistakes[courseId] ?? [];

        if (appState.isLoading) {
          return const Scaffold(body: LoadingIndicator());
        }

        if (course == null) {
          return Scaffold(
            appBar: Header(userProgress: userProgress, showBackButton: true),
            body: Center(child: Text(l10n.translate('errorNoCourse'))),
          );
        }

        return Scaffold(
          appBar: Header(
            userProgress: userProgress,
            courseTitle: course.title,
            showBackButton: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                if (mistakes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _startReviewLesson(context),
                      icon: const Icon(Icons.sync_problem),
                      label: Text(l10n.translate('reviewMistakes', args: {'count': mistakes.length})),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
                if (AppConstants.isDebugMode) _buildDebugButtons(context, course),
                ...course.courseData.map((unit) {
                  final unitIndex = course.courseData.indexOf(unit);
                  return UnitSection(
                    courseId: courseId,
                    unit: unit,
                    unitIndex: unitIndex,
                    allUnits: course.courseData,
                    completedLessons: userProgress.completedLessons[courseId] ?? [],
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDebugButtons(BuildContext context, course) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.end,
        children: [
          /*if (course.qaList != null && course.qaList!.isNotEmpty)
            TextButton(
              onPressed: () => showQaModal(context, course.qaList!),
              child: Text(l10n.translate('viewQa')),
            ),
          if (course.rawCourseJson != null)
            TextButton(
              onPressed: () => showCourseJsonModal(context, course.rawCourseJson!),
              child: Text(l10n.translate('viewJson')),
            ),*/
        ],
      ),
    );
  }
}