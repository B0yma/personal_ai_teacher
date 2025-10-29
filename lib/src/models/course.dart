import 'package:equatable/equatable.dart';

enum ExerciseType {
  fillBlank,
  chooseVariant,
  sentenceAssembly,
  listenAndSelect,
  listenAndWrite,
  meaningAssessment,
}

class SavedCourse extends Equatable {
  final String id;
  final String title;
  final List<Unit> courseData;
  final String? rawCourseJson;
  final List<Map<String, String>>? qaList;
  final Map<String, String>? generationPrompts;

  const SavedCourse({
    required this.id,
    required this.title,
    required this.courseData,
    this.rawCourseJson,
    this.qaList,
    this.generationPrompts,
  });

  @override
  List<Object?> get props =>
      [id, title, courseData, rawCourseJson, qaList, generationPrompts];

  factory SavedCourse.fromJson(Map<String, dynamic> json) {
    return SavedCourse(
      id: json['id'] as String,
      title: json['title'] as String,
      courseData: (json['courseData'] as List)
          .map((unitJson) => Unit.fromJson(unitJson))
          .toList(),
      rawCourseJson: json['rawCourseJson'] as String?,
      qaList: (json['qaList'] as List?)
          ?.map((item) => Map<String, String>.from(item))
          .toList(),
      generationPrompts: json['generationPrompts'] != null
          ? Map<String, String>.from(json['generationPrompts'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courseData': courseData.map((unit) => unit.toJson()).toList(),
      'rawCourseJson': rawCourseJson,
      'qaList': qaList,
      'generationPrompts': generationPrompts,
    };
  }
}

class Unit extends Equatable {
  final String id;
  final String title;
  final List<Lesson> lessons;

  const Unit({required this.id, required this.title, required this.lessons});

  @override
  List<Object?> get props => [id, title, lessons];

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'].toString(),
      title: json['title'] as String,
      lessons: (json['lessons'] as List)
          .map((lessonJson) => Lesson.fromJson(lessonJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}

class Lesson extends Equatable {
  final String id;
  final String title;
  final String type; // 'standard' or 'boss'
  final List<Exercise> exercises;

  const Lesson(
      {required this.id,
        required this.title,
        required this.type,
        required this.exercises});

  @override
  List<Object?> get props => [id, title, type, exercises];

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'].toString(),
      title: json['title'] as String,
      type: json['type'] as String,
      exercises: (json['exercises'] as List? ?? []) // Handle case where exercises might be null
          .map((exJson) => Exercise.fromJson(exJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      // This was the missing line that caused the bug.
      'exercises': exercises.map((ex) => ex.toJson()).toList(),
    };
  }
}

class Exercise extends Equatable {
  final ExerciseType type;
  final String question;
  final Map<String, dynamic> data;

  const Exercise(
      {required this.type, required this.question, required this.data});

  @override
  List<Object?> get props => [type, question, data];

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = ExerciseType.values.firstWhere(
          (e) =>
      e
          .toString()
          .split('.')
          .last
          .toUpperCase() == typeString.replaceAll('_', '').toUpperCase(),
      orElse: () => throw Exception('Unknown ExerciseType: $typeString'),
    );
    return Exercise(
      type: type,
      question: json['question'] as String,
      data: json['data'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    // Convert Dart enum to the format expected by the JSON (e.g., ExerciseType.fillBlank -> 'FILL_BLANK')
    final typeString = type
        .toString()
        .split('.')
        .last
        .replaceAllMapped(RegExp(r'(?<=[a-z])(?=[A-Z])'), (Match m) => '_${m[0]}')
        .toUpperCase();
    return {
      'type': typeString,
      'question': question,
      'data': data,
    };
  }
}