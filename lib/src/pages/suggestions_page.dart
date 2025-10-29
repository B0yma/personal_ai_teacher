import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/providers/app_state_provider.dart';
import 'package:personal_ai_teacher/src/routing/app_router.dart';
import 'package:personal_ai_teacher/src/services/gemini_service.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:personal_ai_teacher/src/widgets/common/header.dart';
import 'package:personal_ai_teacher/src/widgets/common/loading_indicator.dart';
import 'package:personal_ai_teacher/src/widgets/modals/generation_failed_modal.dart';
import 'package:personal_ai_teacher/src/widgets/suggestions/suggestion_card.dart';
import 'package:provider/provider.dart';

class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  late Future<List<Map<String, String>>?> _suggestionsFuture;
  final GeminiService _geminiService = GeminiService();
  bool _isGenerating = false;
  String _loadingMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final existingTitles = appState.savedCourses.map((c) => c.title).toList();
    _suggestionsFuture = _geminiService.generateCourseSuggestions(existingTitles, appState.locale.languageCode);
  }

  Future<void> _handleGenerate(String title) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _isGenerating = true;
    });

    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final result = await _geminiService.generateCourse(
      "Create a course about: $title",
      appState.locale.languageCode,
          (state, {payload}) {
        setState(() {
          switch (state) {
            case ProgressState.analyzingText:
              _loadingMessage = l10n.translate('progressAnalyzing');
              break;
            case ProgressState.buildingCourse:
              _loadingMessage = l10n.translate('progressBuilding');
              break;
            case ProgressState.generatingQuestions:
              _loadingMessage = l10n.translate('progressGeneratingQuestions', args: {'title': payload['title']});
              break;
          }
        });
      },
    );

    if (!mounted) return;

    setState(() {
      _isGenerating = false;
    });

    if (result != null) {
      final newCourse = SavedCourse(
        id: 'course_${DateTime.now().millisecondsSinceEpoch}',
        title: (result['course'] as List<Unit>).first.title,
        courseData: result['course'],
        rawCourseJson: result['rawJson'],
        qaList: result['qaList'],
        generationPrompts: result['prompts'],
      );
      await appState.addCourse(newCourse);
      if (mounted) {
        context.push(AppRouter.courseMapPath.replaceFirst(':courseId', newCourse.id));
      }
    } else {
      showGenerationFailedModal(context, () => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (_isGenerating) {
      return Scaffold(body: LoadingIndicator(message: _loadingMessage));
    }

    return Scaffold(
      appBar: Header(userProgress: appState.userProgress, showBackButton: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
            child: Column(
              children: [
                Text(
                  l10n.translate('suggestionsTitle'),
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppTheme.slate100 : AppTheme.slate800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.translate('suggestionsText'),
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? AppTheme.slate300 : AppTheme.slate600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildSuggestionsList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestionsList() {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<List<Map<String, String>>?>(
      future: _suggestionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator(message: l10n.translate('suggestionsLoading'));
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Text(l10n.translate('suggestionsErrorGeneral'));
        }
        final suggestions = snapshot.data!;
        return Column(
          children: suggestions.map((suggestion) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SuggestionCard(
                title: suggestion['title']!,
                description: suggestion['description']!,
                onTap: () => _handleGenerate(suggestion['title']!),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}