import 'package:equatable/equatable.dart';

/// A simple data class to store the location of a mistake.
class MistakeCoordinate extends Equatable {
  final String lessonId;
  final int exerciseIndex;

  const MistakeCoordinate({required this.lessonId, required this.exerciseIndex});

  @override
  List<Object?> get props => [lessonId, exerciseIndex];

  factory MistakeCoordinate.fromJson(Map<String, dynamic> json) {
    return MistakeCoordinate(
      lessonId: json['lessonId'] as String,
      exerciseIndex: json['exerciseIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'exerciseIndex': exerciseIndex,
    };
  }
}