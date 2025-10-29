import 'package:equatable/equatable.dart';
import 'package:personal_ai_teacher/src/models/mistake_coordinate.dart';
import 'package:personal_ai_teacher/src/utils/constants.dart';

class UserProgress extends Equatable {
  final Map<String, List<String>> completedLessons;
  final int xp;
  final int gems;
  final int hearts;
  final int streak;
  final String? lastCompletedDate;
  final Map<String, List<MistakeCoordinate>> mistakes;
  final int? lastHeartRefillTimestamp; // New field to track refill time

  const UserProgress({
    required this.completedLessons,
    required this.xp,
    required this.gems,
    required this.hearts,
    required this.streak,
    this.lastCompletedDate,
    required this.mistakes,
    this.lastHeartRefillTimestamp,
  });

  static UserProgress initial = UserProgress(
    completedLessons: {},
    xp: 0,
    gems: 100,
    hearts: AppConstants.maxHearts,
    streak: 0,
    lastCompletedDate: null,
    mistakes: {},
    lastHeartRefillTimestamp: null,
  );

  UserProgress copyWith({
    Map<String, List<String>>? completedLessons,
    int? xp,
    int? gems,
    int? hearts,
    int? streak,
    String? lastCompletedDate,
    Map<String, List<MistakeCoordinate>>? mistakes,
    int? lastHeartRefillTimestamp,
  }) {
    return UserProgress(
      completedLessons: completedLessons ?? this.completedLessons,
      xp: xp ?? this.xp,
      gems: gems ?? this.gems,
      hearts: hearts ?? this.hearts,
      streak: streak ?? this.streak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      mistakes: mistakes ?? this.mistakes,
      lastHeartRefillTimestamp: lastHeartRefillTimestamp ?? this.lastHeartRefillTimestamp,
    );
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      completedLessons: (json['completedLessons'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value)),
      ),
      xp: json['xp'] as int,
      gems: json['gems'] as int,
      hearts: json['hearts'] as int,
      streak: json['streak'] as int,
      lastCompletedDate: json['lastCompletedDate'] as String?,
      mistakes: (json['mistakes'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          (value as List)
              .map((item) => MistakeCoordinate.fromJson(item))
              .toList(),
        ),
      ),
      lastHeartRefillTimestamp: json['lastHeartRefillTimestamp'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedLessons': completedLessons,
      'xp': xp,
      'gems': gems,
      'hearts': hearts,
      'streak': streak,
      'lastCompletedDate': lastCompletedDate,
      'mistakes': mistakes.map(
            (key, value) => MapEntry(
          key,
          value.map((item) => item.toJson()).toList(),
        ),
      ),
      'lastHeartRefillTimestamp': lastHeartRefillTimestamp,
    };
  }

  @override
  List<Object?> get props => [
    completedLessons,
    xp,
    gems,
    hearts,
    streak,
    lastCompletedDate,
    mistakes,
    lastHeartRefillTimestamp,
  ];
}