import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/providers/lesson_provider.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:provider/provider.dart';

class ChooseVariantExercise extends StatefulWidget {
  final Map<String, dynamic> data;

  const ChooseVariantExercise({super.key, required this.data});

  @override
  State<ChooseVariantExercise> createState() => _ChooseVariantExerciseState();
}

class _ChooseVariantExerciseState extends State<ChooseVariantExercise> {
  late List<String> _shuffledOptions;

  @override
  void initState() {
    super.initState();
    final options = List<String>.from(widget.data['options'] ?? []);
    final correct = Provider.of<LessonProvider>(context, listen: false).correctAnswerText;

    // Use a Set to automatically handle duplicates, then convert back to a List and shuffle.
    _shuffledOptions = {...options, correct}.toList()..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final sentence = widget.data['sentence'] as String? ?? '___';
    final parts = sentence.split('___');
    final beforeText = parts[0];
    final afterText = parts.length > 1 ? parts[1] : '';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 400;
        return Column(
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              runSpacing: 8.0,
              children: [
                Text(beforeText, style: const TextStyle(fontSize: 20)),
                Container(
                  width: 120,
                  height: 2,
                  color: isDarkMode ? AppTheme.slate600 : AppTheme.slate400,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Text(afterText, style: const TextStyle(fontSize: 20)),
              ],
            ),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: isMobile ? 5 : 3,
              ),
              itemCount: _shuffledOptions.length,
              itemBuilder: (context, index) {
                final option = _shuffledOptions[index];
                final isSelected = lessonProvider.userAnswer == option;
                return ElevatedButton(
                  onPressed: lessonProvider.feedback == FeedbackState.none
                      ? () => lessonProvider.setUserAnswer(option)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? (isDarkMode ? AppTheme.slate700 : AppTheme.sky100)
                        : (isDarkMode ? AppTheme.slate800 : Colors.white),
                    foregroundColor: isDarkMode ? Colors.white : Colors.black,
                    disabledBackgroundColor: isSelected
                        ? (isDarkMode ? AppTheme.slate700 : AppTheme.sky100)
                        : (isDarkMode ? AppTheme.slate800 : Colors.white),
                    disabledForegroundColor: isDarkMode ? AppTheme.slate400 : AppTheme.slate500,
                    side: BorderSide(
                      color: isSelected ? AppTheme.sky400 : (isDarkMode ? AppTheme.slate600 : AppTheme.slate300),
                      width: 2,
                    ),
                    elevation: 1,
                  ),
                  child: Text(option, textAlign: TextAlign.center),
                );
              },
            ),
          ],
        );
      },
    );
  }
}