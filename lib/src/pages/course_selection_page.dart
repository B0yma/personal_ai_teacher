import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/providers/app_state_provider.dart';
import 'package:personal_ai_teacher/src/routing/app_router.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:personal_ai_teacher/src/widgets/common/header.dart';
import 'package:personal_ai_teacher/src/widgets/common/loading_indicator.dart';
import 'package:personal_ai_teacher/src/widgets/course_selection/course_card.dart';
import 'package:personal_ai_teacher/src/widgets/course_selection/language_switcher.dart';
import 'package:personal_ai_teacher/src/widgets/modals/delete_course_modal.dart';
import 'package:provider/provider.dart';

class CourseSelectionPage extends StatelessWidget {
  const CourseSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final l10n = AppLocalizations.of(context);

    if (appState.isLoading) {
      return const Scaffold(body: LoadingIndicator());
    }

    return Scaffold(
      appBar: Header(userProgress: appState.userProgress),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(context, l10n, isMobile),
                const SizedBox(height: 24),
                appState.savedCourses.isEmpty
                    ? _buildEmptyState(context, l10n)
                    : _buildCoursesGrid(context, appState, constraints.maxWidth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppLocalizations l10n, bool isMobile) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final title = Text(
      l10n.translate('yourCourses'),
      style: TextStyle(
        fontSize: isMobile ? 24 : 28,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? AppTheme.slate100 : AppTheme.slate800,
      ),
    );

    final suggestButton = ElevatedButton(
      onPressed: () => context.push(AppRouter.suggestionsPath),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.purple500,
        foregroundColor: Colors.white,
      ),
      child: Text(l10n.translate('suggestCourse')),
    );

    final createButton = ElevatedButton(
      onPressed: () => context.push(AppRouter.textInputPath),
      child: Text(l10n.translate('createNew')),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title,
              const LanguageSwitcher(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: suggestButton),
              const SizedBox(width: 8),
              Expanded(child: createButton),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title,
          Row(
            children: [
              const LanguageSwitcher(),
              const SizedBox(width: 16),
              suggestButton,
              const SizedBox(width: 8),
              createButton,
            ],
          ),
        ],
      );
    }
  }

  Widget _buildCoursesGrid(BuildContext context, AppStateProvider appState, double screenWidth) {
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth > 1200) {
      crossAxisCount = 3;
      childAspectRatio = 1.5;
    } else if (screenWidth > 600) {
      crossAxisCount = 2;
      childAspectRatio = 1.6;
    } else {
      crossAxisCount = 1;
      childAspectRatio = 2.5;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: appState.savedCourses.length,
      itemBuilder: (context, index) {
        final course = appState.savedCourses[index];
        return CourseCard(
          course: course,
          mistakes: appState.userProgress.mistakes[course.id]?.length ?? 0,
          onSelect: () => context.push(AppRouter.courseMapPath.replaceFirst(':courseId', course.id)),
          onDelete: () => showDeleteCourseModal(
            context,
            courseTitle: course.title,
            onConfirm: () => appState.deleteCourse(course.id),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? AppTheme.slate700 : AppTheme.slate300,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.folder_open, size: 48, color: AppTheme.slate400),
            const SizedBox(height: 8),
            Text(
              l10n.translate('noCoursesTitle'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? AppTheme.slate200 : AppTheme.slate800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.translate('noCoursesText'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppTheme.slate500),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRouter.textInputPath),
              icon: const Icon(Icons.add),
              label: Text(l10n.translate('createNewCourse')),
            ),
          ],
        ),
      ),
    );
  }
}