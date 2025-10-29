import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/models/mistake_coordinate.dart';
import 'package:personal_ai_teacher/src/models/word_token.dart';
import 'package:personal_ai_teacher/src/services/gemini_service.dart';

enum FeedbackState { none, correct, incorrect }
enum LessonStatus { inProgress, failed, completed }

class LessonProvider with ChangeNotifier {
  final Lesson _lesson;
  final List<MistakeCoordinate>? reviewCoordinates;
  final GeminiService _geminiService;

  late VoidCallback onLoseHeartCallback;
  late Function(MistakeCoordinate) onCorrectAnswerInReviewCallback;
  late Function(int xp, bool mistakeMade) onCompleteCallback;

  int _currentIndex = 0;
  int _hearts;
  bool _mistakeMadeInLesson = false;
  FeedbackState _feedback = FeedbackState.none;
  bool _isChecking = false;
  dynamic _userAnswer;
  LessonStatus _status = LessonStatus.inProgress;

  bool get isReviewMode => reviewCoordinates != null;
  int get currentIndex => _currentIndex;

  LessonProvider({
    required Lesson lesson,
    required int initialHearts,
    this.reviewCoordinates,
    required VoidCallback onLoseHeart,
    required Function(MistakeCoordinate) onCorrectAnswerInReview,
    required Function(int xp, bool mistakeMade) onComplete,
  })  : _lesson = lesson,
        _hearts = initialHearts,
        _geminiService = GeminiService() {
    onLoseHeartCallback = onLoseHeart;
    onCorrectAnswerInReviewCallback = onCorrectAnswerInReview;
    onCompleteCallback = onComplete;
  }

  Exercise get currentExercise => _lesson.exercises[_currentIndex];
  int get hearts => _hearts;
  double get progress => (_currentIndex + 1) / _lesson.exercises.length;
  FeedbackState get feedback => _feedback;
  bool get isChecking => _isChecking;
  dynamic get userAnswer => _userAnswer;
  LessonStatus get status => _status;

  String _getCorrectAnswerAsString(dynamic correctValue) {
    if (correctValue is String) return correctValue;
    if (correctValue is List && correctValue.isNotEmpty) return correctValue.first.toString();
    return '';
  }

  String get correctAnswerText {
    final exercise = currentExercise;
    switch (exercise.type) {
      case ExerciseType.fillBlank:
      case ExerciseType.chooseVariant:
      case ExerciseType.listenAndSelect:
      case ExerciseType.listenAndWrite:
        return _getCorrectAnswerAsString(exercise.data['correct']);
      case ExerciseType.sentenceAssembly:
        final sentence = exercise.data['sentence'] as String?;
        final correct = exercise.data['correct'];
        return sentence ?? _getCorrectAnswerAsString(correct);
      case ExerciseType.meaningAssessment:
        final correctIdea = exercise.data['correct_idea'] as String?;
        final correct = exercise.data['correct'];
        return correctIdea ?? _getCorrectAnswerAsString(correct);
      default:
        return '';
    }
  }

  void setUserAnswer(dynamic answer) {
    _userAnswer = answer;
    notifyListeners();
  }

  Future<void> checkAnswer() async {
    if (_userAnswer == null || (_userAnswer is String && _userAnswer.trim().isEmpty) || (_userAnswer is List && _userAnswer.isEmpty)) {
      return;
    }

    _isChecking = true;
    notifyListeners();

    bool isCorrect = false;
    final exercise = currentExercise;

    try {
      switch (exercise.type) {
        case ExerciseType.sentenceAssembly:
          final correctSentence = correctAnswerText;
          final userAnswer = (_userAnswer as List<WordToken>?)?.map((t) => t.word).join(' ') ?? '';
          isCorrect = await _geminiService.evaluateSentenceAssembly(correctSentence, userAnswer);
          break;
        default:
          final correct = correctAnswerText;
          final answer = (_userAnswer is List<WordToken>)
              ? (_userAnswer as List<WordToken>).map((t) => t.word).join(' ')
              : _userAnswer.toString();
          isCorrect = answer.trim().toLowerCase() == correct.trim().toLowerCase();
      }
    } catch (e) {
      debugPrint("Error checking answer: $e");
      isCorrect = false;
    }

    if (isCorrect) {
      _feedback = FeedbackState.correct;
      if (isReviewMode) {
        onCorrectAnswerInReviewCallback(reviewCoordinates![_currentIndex]);
      }
    } else {
      _feedback = FeedbackState.incorrect;
      // This is the crucial fix: only penalize the user if NOT in review mode.
      if (!isReviewMode) {
        _mistakeMadeInLesson = true;
        _hearts--;
        onLoseHeartCallback();
        if (_hearts <= 0) {
          _status = LessonStatus.failed;
        }
      }
    }

    _isChecking = false;
    notifyListeners();
  }

  void handleContinue() {
    if (_status == LessonStatus.failed) return;

    if (_currentIndex + 1 < _lesson.exercises.length) {
      _currentIndex++;
      _userAnswer = null;
      _feedback = FeedbackState.none;
      notifyListeners();
    } else {
      _status = LessonStatus.completed;
      onCompleteCallback(_lesson.exercises.length * 10, _mistakeMadeInLesson);
      notifyListeners();
    }
  }
}