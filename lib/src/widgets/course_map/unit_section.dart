import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:personal_ai_teacher/src/widgets/course_map/lesson_node.dart';

class UnitSection extends StatelessWidget {
  final String courseId;
  final Unit unit;
  final int unitIndex;
  final List<Unit> allUnits;
  final List<String> completedLessons;

  const UnitSection({
    super.key,
    required this.courseId,
    required this.unit,
    required this.unitIndex,
    required this.allUnits,
    required this.completedLessons,
  });

  bool _isUnitUnlocked(int index) {
    if (index == 0) return true;
    final prevUnit = allUnits[index - 1];
    return prevUnit.lessons.every((lesson) => completedLessons.contains(lesson.id));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final unitIsUnlocked = _isUnitUnlocked(unitIndex);
    bool currentLessonFoundForUnit = false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0),
      child: Column(
        children: [
          Text(
            unit.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: unitIsUnlocked
                  ? (isDarkMode ? AppTheme.slate200 : AppTheme.slate700)
                  : (isDarkMode ? AppTheme.slate500 : AppTheme.slate400),
            ),
          ),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: unit.lessons.length,
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemBuilder: (context, lessonIndex) {
              final lesson = unit.lessons[lessonIndex];
              final isCompleted = completedLessons.contains(lesson.id);
              final isPreviousLessonCompleted = lessonIndex == 0 || completedLessons.contains(unit.lessons[lessonIndex - 1].id);
              final isUnlocked = unitIsUnlocked && isPreviousLessonCompleted;

              bool isCurrent = false;
              if (isUnlocked && !isCompleted && !currentLessonFoundForUnit) {
                isCurrent = true;
                currentLessonFoundForUnit = true;
              }

              return LessonNode(
                courseId: courseId,
                lesson: lesson,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isUnlocked: isUnlocked,
                isFirst: lessonIndex == 0,
                isLast: lessonIndex == unit.lessons.length - 1,
              );
            },
          ),
        ],
      ),
    );
  }
}