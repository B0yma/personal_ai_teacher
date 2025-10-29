import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/providers/app_state_provider.dart';
import 'package:personal_ai_teacher/src/routing/app_router.dart';
import 'package:personal_ai_teacher/src/utils/app_icons.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:personal_ai_teacher/src/widgets/modals/hearts_modal.dart';
import 'package:provider/provider.dart';

class LessonNode extends StatelessWidget {
  final String courseId;
  final Lesson lesson;
  final bool isCompleted;
  final bool isCurrent;
  final bool isUnlocked;
  final bool isFirst;
  final bool isLast;

  const LessonNode({
    super.key,
    required this.courseId,
    required this.lesson,
    required this.isCompleted,
    required this.isCurrent,
    required this.isUnlocked,
    required this.isFirst,
    required this.isLast,
  });

  void _handleTap(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    if (appState.userProgress.hearts <= 0) {
      showHeartsModal(context);
    } else {
      context.push(AppRouter.lessonPath
          .replaceFirst(':courseId', courseId)
          .replaceFirst(':lessonId', lesson.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildTextBlock(context)),
            SizedBox(width: isMobile ? 16 : 24),
            _buildTimeline(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextBlock(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String statusText;
    Color statusColor;

    if (isCompleted) {
      statusText = l10n.translate('completed');
      statusColor = isDarkMode ? AppTheme.slate400 : AppTheme.slate500;
    } else if (isCurrent) {
      statusText = l10n.translate('start');
      statusColor = isDarkMode ? AppTheme.sky400 : AppTheme.sky500;
    } else {
      statusText = l10n.translate('locked');
      statusColor = isDarkMode ? AppTheme.slate500 : AppTheme.slate400;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lesson.title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? AppTheme.slate200 : AppTheme.slate800,
          ),
        ),
        Text(
          statusText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: statusColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final lineColor = isDarkMode ? AppTheme.slate700.withOpacity(0.5) : AppTheme.slate200;

    return SizedBox(
      width: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Vertical line
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    width: 4,
                    color: isFirst ? Colors.transparent : lineColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 4,
                    color: isLast ? Colors.transparent : lineColor,
                  ),
                ),
              ],
            ),
          ),
          // Node
          _buildNode(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildNode(BuildContext context, bool isDarkMode) {
    final isBoss = lesson.type == 'boss';
    final nodeSize = isCurrent ? 80.0 : 64.0;
    
    Color nodeBgColor;
    Widget nodeIcon;

    if (isCompleted) {
      nodeBgColor = AppTheme.yellow400;
      nodeIcon = const Icon(AppIcons.check, color: Colors.white, size: 36);
    } else if (isCurrent) {
      nodeBgColor = AppTheme.sky500;
      nodeIcon = const Icon(AppIcons.play, color: Colors.white, size: 40);
    } else {
      nodeBgColor = isDarkMode ? AppTheme.slate600 : AppTheme.slate300;
      nodeIcon = Icon(AppIcons.lock, color: isDarkMode ? AppTheme.slate400 : Colors.white, size: 36);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (isCurrent)
          Container(
            width: nodeSize,
            height: nodeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.sky500.withOpacity(0.5),
            ),
          ),
        InkWell(
          onTap: isUnlocked ? () => _handleTap(context) : null,
          borderRadius: BorderRadius.circular(nodeSize / 2),
          child: Container(
            width: nodeSize,
            height: nodeSize,
            decoration: BoxDecoration(
              color: nodeBgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode ? AppTheme.slate900 : AppTheme.slate50,
                width: 4,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: AppTheme.sky500.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: Center(child: nodeIcon),
          ),
        ),
        if (isBoss)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted || isCurrent ? AppTheme.red500 : AppTheme.slate500,
                border: Border.all(
                  color: isDarkMode ? AppTheme.slate900 : AppTheme.slate50,
                  width: 2,
                ),
              ),
              child: const Icon(AppIcons.star, color: Colors.white, size: 16),
            ),
          ),
      ],
    );
  }
}