import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/models/mistake_coordinate.dart';
import 'package:personal_ai_teacher/src/pages/course_map_page.dart';
import 'package:personal_ai_teacher/src/pages/course_selection_page.dart';
import 'package:personal_ai_teacher/src/pages/lesson_page.dart';
import 'package:personal_ai_teacher/src/pages/suggestions_page.dart';
import 'package:personal_ai_teacher/src/pages/text_input_page.dart';
import 'package:personal_ai_teacher/src/providers/app_state_provider.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String courseSelectionPath = '/';
  static const String textInputPath = '/create';
  static const String suggestionsPath = '/suggest';
  static const String courseMapPath = '/course/:courseId';
  static const String lessonPath = '/course/:courseId/lesson/:lessonId';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: courseSelectionPath,
    routes: [
      GoRoute(
        path: courseSelectionPath,
        name: courseSelectionPath,
        builder: (context, state) => const CourseSelectionPage(),
      ),
      GoRoute(
        path: textInputPath,
        name: textInputPath,
        builder: (context, state) => const TextInputPage(),
      ),
      GoRoute(
        path: suggestionsPath,
        name: suggestionsPath,
        builder: (context, state) => const SuggestionsPage(),
      ),
      GoRoute(
        path: courseMapPath,
        name: courseMapPath,
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          return CourseMapPage(courseId: courseId);
        },
      ),
      GoRoute(
        path: lessonPath,
        name: lessonPath,
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final lessonId = state.pathParameters['lessonId']!;
          final extra = state.extra as Map<String, dynamic>?;

          Lesson? lesson;
          List<MistakeCoordinate>? reviewCoordinates;

          if (extra != null) {
            // This is a review lesson
            lesson = extra['lesson'] as Lesson?;
            reviewCoordinates = extra['coordinates'] as List<MistakeCoordinate>?;
          } else {
            // This is a standard lesson
            final appState = Provider.of<AppStateProvider>(context, listen: false);
            lesson = appState.findLessonById(courseId, lessonId);
          }

          if (lesson == null) {
            return Scaffold(
              body: Center(
                child: Text('Lesson with ID $lessonId not found in course $courseId'),
              ),
            );
          }
          return LessonPage(
            courseId: courseId,
            lesson: lesson,
            reviewCoordinates: reviewCoordinates,
          );
        },
      ),
    ],
  );
}