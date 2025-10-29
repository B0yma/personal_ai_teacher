import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/models/mistake_coordinate.dart';
import 'package:personal_ai_teacher/src/models/user_progress.dart';
import 'package:personal_ai_teacher/src/services/notification_service.dart';
import 'package:personal_ai_teacher/src/services/user_data_service.dart';
import 'package:personal_ai_teacher/src/utils/constants.dart';

class AppStateProvider with ChangeNotifier {
  final UserDataService _userDataService;

  AppStateProvider({required UserDataService userDataService})
      : _userDataService = userDataService;

  List<SavedCourse> _savedCourses = [];
  UserProgress _userProgress = UserProgress.initial;
  bool _isLoading = true;
  Locale _locale = const Locale('en');

  List<SavedCourse> get savedCourses => _savedCourses;
  UserProgress get userProgress => _userProgress;
  bool get isLoading => _isLoading;
  Locale get locale => _locale;

  Future<void> _refillHearts() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    int lastRefill = _userProgress.lastHeartRefillTimestamp ?? now;

    if (_userProgress.hearts >= AppConstants.maxHearts) {
      _userProgress = _userProgress.copyWith(lastHeartRefillTimestamp: now);
      await _userDataService.saveUserProgress(_userProgress);
      return;
    }

    final int elapsed = now - lastRefill;
    final int refillIntervalMs = AppConstants.heartsRefillTime.inMilliseconds;
    final int heartsToRefill = (elapsed / refillIntervalMs).floor();

    if (heartsToRefill > 0) {
      final int newHearts = (_userProgress.hearts + heartsToRefill).clamp(0, AppConstants.maxHearts);
      final int newTimestamp = lastRefill + (heartsToRefill * refillIntervalMs);

      _userProgress = _userProgress.copyWith(
        hearts: newHearts,
        lastHeartRefillTimestamp: newTimestamp,
      );
      await _userDataService.saveUserProgress(_userProgress);
    }
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    await NotificationService.requestPermission();
    await NotificationService.scheduleCourseSuggestionNotification();

    // Load saved language first
    final savedLangCode = await _userDataService.loadLanguage();
    _locale = Locale(savedLangCode);

    _savedCourses = await _userDataService.loadCourses();
    _userProgress = await _userDataService.loadUserProgress();

    await _refillHearts();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale != newLocale) {
      _locale = newLocale;
      // Persist the new language choice
      await _userDataService.saveLanguage(newLocale.languageCode);
      notifyListeners();
    }
  }

  SavedCourse? getCourseById(String courseId) {
    try {
      return _savedCourses.firstWhere((c) => c.id == courseId);
    } catch (e) {
      return null;
    }
  }

  Lesson? findLessonById(String courseId, String lessonId) {
    final course = getCourseById(courseId);
    if (course == null) return null;
    for (final unit in course.courseData) {
      for (final lesson in unit.lessons) {
        if (lesson.id == lessonId) {
          return lesson;
        }
      }
    }
    return null;
  }

  Future<void> addCourse(SavedCourse course) async {
    _savedCourses.removeWhere((c) => c.id == course.id);
    _savedCourses.add(course);
    await _userDataService.saveCourses(_savedCourses);
    notifyListeners();
  }

  Future<void> deleteCourse(String courseId) async {
    _savedCourses.removeWhere((c) => c.id == courseId);
    await _userDataService.saveCourses(_savedCourses);

    final newCompletedLessons = Map<String, List<String>>.from(_userProgress.completedLessons)..remove(courseId);
    final newMistakes = Map<String, List<MistakeCoordinate>>.from(_userProgress.mistakes)..remove(courseId);

    _userProgress = _userProgress.copyWith(
      completedLessons: newCompletedLessons,
      mistakes: newMistakes,
    );

    await _userDataService.saveUserProgress(_userProgress);
    notifyListeners();
  }

  Future<void> completeLesson(String courseId, String lessonId, int xpGained) async {
    final currentCompleted = _userProgress.completedLessons[courseId] ?? [];
    bool wasAlreadyCompleted = currentCompleted.contains(lessonId);

    if (!wasAlreadyCompleted) {
      currentCompleted.add(lessonId);
    }

    final updatedLessons = Map<String, List<String>>.from(_userProgress.completedLessons);
    updatedLessons[courseId] = currentCompleted;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    int newStreak = _userProgress.streak;

    if (_userProgress.lastCompletedDate != today) {
      final yesterday = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));
      if (_userProgress.lastCompletedDate == yesterday) {
        newStreak++;
      } else {
        newStreak = 1;
      }
    }

    // Award gems only for the first time a lesson is completed.
    final int newGems = wasAlreadyCompleted ? _userProgress.gems : _userProgress.gems + AppConstants.gemsPerLesson;

    _userProgress = _userProgress.copyWith(
      completedLessons: updatedLessons,
      xp: _userProgress.xp + xpGained,
      gems: newGems,
      streak: newStreak,
      lastCompletedDate: today,
    );

    await _userDataService.saveUserProgress(_userProgress);
    notifyListeners();
  }

  Future<void> loseHeart(String courseId, String lessonId, int exerciseIndex) async {
    if (_userProgress.hearts <= 0) return;

    final newHearts = _userProgress.hearts - 1;
    Map<String, List<MistakeCoordinate>> updatedMistakes = Map.from(_userProgress.mistakes);
    int? newTimestamp = _userProgress.lastHeartRefillTimestamp;

    if (_userProgress.hearts == AppConstants.maxHearts) {
      newTimestamp = DateTime.now().millisecondsSinceEpoch;
    }

    if (exerciseIndex >= 0) {
      final newMistake = MistakeCoordinate(lessonId: lessonId, exerciseIndex: exerciseIndex);
      final courseMistakes = List<MistakeCoordinate>.from(_userProgress.mistakes[courseId] ?? []);

      if (!courseMistakes.contains(newMistake)) {
        courseMistakes.add(newMistake);
      }

      updatedMistakes[courseId] = courseMistakes;
    }

    _userProgress = _userProgress.copyWith(
      hearts: newHearts,
      mistakes: updatedMistakes,
      lastHeartRefillTimestamp: newTimestamp,
    );
    await _userDataService.saveUserProgress(_userProgress);
    notifyListeners();
  }

  Future<void> clearMistake(String courseId, MistakeCoordinate coordinate) async {
    final courseMistakes = List<MistakeCoordinate>.from(_userProgress.mistakes[courseId] ?? []);
    courseMistakes.remove(coordinate);

    final updatedMistakes = Map<String, List<MistakeCoordinate>>.from(_userProgress.mistakes);
    if (courseMistakes.isEmpty) {
      updatedMistakes.remove(courseId);
    } else {
      updatedMistakes[courseId] = courseMistakes;
    }

    _userProgress = _userProgress.copyWith(mistakes: updatedMistakes);
    await _userDataService.saveUserProgress(_userProgress);
    notifyListeners();
  }

  Map<String, dynamic>? createMistakesLesson(String courseId) {
    final course = getCourseById(courseId);
    final mistakeCoordinates = _userProgress.mistakes[courseId];

    if (course == null || mistakeCoordinates == null || mistakeCoordinates.isEmpty) {
      return null;
    }

    final List<Exercise> mistakeExercises = [];
    for (final coordinate in mistakeCoordinates) {
      final lesson = findLessonById(courseId, coordinate.lessonId);
      if (lesson != null && coordinate.exerciseIndex < lesson.exercises.length) {
        mistakeExercises.add(lesson.exercises[coordinate.exerciseIndex]);
      }
    }

    if (mistakeExercises.isEmpty) return null;

    final reviewLesson = Lesson(
      id: 'review_lesson_$courseId',
      title: 'Mistake Review',
      type: 'standard',
      exercises: mistakeExercises,
    );

    return {
      'lesson': reviewLesson,
      'coordinates': mistakeCoordinates,
    };
  }
}