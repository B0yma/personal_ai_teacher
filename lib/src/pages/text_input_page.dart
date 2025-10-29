import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/providers/app_state_provider.dart';
import 'package:personal_ai_teacher/src/routing/app_router.dart';
import 'package:personal_ai_teacher/src/services/gemini_service.dart';
import 'package:personal_ai_teacher/src/services/mock_course_service.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:personal_ai_teacher/src/widgets/common/header.dart';
import 'package:personal_ai_teacher/src/widgets/common/loading_indicator.dart';
import 'package:personal_ai_teacher/src/widgets/modals/generation_failed_modal.dart';
import 'package:provider/provider.dart';

class TextInputPage extends StatefulWidget {
  const TextInputPage({super.key});

  @override
  State<TextInputPage> createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {
  final _textController = TextEditingController();
  String? _errorText;
  bool _isGenerating = false;
  String _loadingMessage = '';

  Future<void> _handleGenerate() async {
    final l10n = AppLocalizations.of(context);
    if (_textController.text.trim().length < 50) {
      setState(() {
        _errorText = l10n.translate('textInputError');
      });
      return;
    }

    setState(() {
      _errorText = null;
      _isGenerating = true;
    });

    final geminiService = GeminiService();
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final result = await geminiService.generateCourse(
      _textController.text,
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

  Future<void> _handleStartDemo() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    const demoCourseId = 'demo_course_flutter';

    SavedCourse? demoCourse = appState.getCourseById(demoCourseId);

    if (demoCourse == null) {
      demoCourse = MockCourseService.getDemoCourse();
      await appState.addCourse(demoCourse);
    }

    if (mounted) {
      context.push(AppRouter.courseMapPath.replaceFirst(':courseId', demoCourse.id));
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.translate('textInputTitle'),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppTheme.slate100 : AppTheme.slate800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.translate('textInputText'),
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? AppTheme.slate300 : AppTheme.slate600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _textController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: l10n.translate('textInputPlaceholder'),
                    errorText: _errorText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDarkMode ? AppTheme.slate600 : AppTheme.slate300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.sky500,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleGenerate,
                    child: Text(l10n.translate('generateCourse')),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _handleStartDemo,
                    style: TextButton.styleFrom(
                      backgroundColor: isDarkMode ? AppTheme.slate700 : AppTheme.slate200,
                    ),
                    child: Text(l10n.translate('tryDemo')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}