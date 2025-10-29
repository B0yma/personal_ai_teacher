import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:personal_ai_teacher/src/models/course.dart';

enum ProgressState {
  analyzingText,
  buildingCourse,
  generatingQuestions,
}

typedef ProgressCallback = void Function(ProgressState state, {dynamic payload});

class GeminiService {
  final GenerativeModel _model;

  GeminiService()
      : _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-pro',
  );

  String _cleanJsonString(String rawJson) {
    return rawJson.replaceAll(RegExp(r'^```json|```$'), '').trim();
  }

  Future<Map<String, dynamic>?> generateCourse(
      String text,
      String language,
      ProgressCallback progressCallback,
      ) async {
    try {
      progressCallback(ProgressState.analyzingText);
      final coursePrompt = _buildCoursePrompt(text, language);

      final response = await _model.generateContent([Content.text(coursePrompt)]);
      final rawJsonString = response.text;

      if (rawJsonString == null) {
        throw Exception("Received null response from API");
      }

      final cleanJson = _cleanJsonString(rawJsonString);
      final courseData = json.decode(cleanJson);
      final course = (courseData as List).map((unitData) => Unit.fromJson(unitData)).toList();

      progressCallback(ProgressState.buildingCourse);

      return {
        'course': course,
        'rawJson': cleanJson,
        'qaList': <Map<String, String>>[],
        'prompts': {'qaPrompt': '', 'coursePrompt': coursePrompt},
      };
    } catch (e) {
      debugPrint('Error generating course: $e');
      return null;
    }
  }

  Future<List<Map<String, String>>?> generateCourseSuggestions(
      List<String> existingTitles, String language) async {
    try {
      final prompt = _buildSuggestionsPrompt(existingTitles, language);
      final response = await _model.generateContent([Content.text(prompt)]);
      final rawJsonString = response.text;

      if (rawJsonString == null) {
        throw Exception("Received null response from API for suggestions");
      }

      final cleanJson = _cleanJsonString(rawJsonString);
      final suggestions = (json.decode(cleanJson) as List)
          .map((s) => Map<String, String>.from(s as Map))
          .toList();
      return suggestions;
    } catch (e) {
      debugPrint('Error generating suggestions: $e');
      return null;
    }
  }

  Future<bool> evaluateMeaning(String context, String question, String correctIdea, String userAnswer) async {
    try {
      final prompt = _buildEvaluationPrompt(context, question, correctIdea, userAnswer);
      final response = await _model.generateContent([Content.text(prompt)]);
      final resultText = response.text?.trim().toLowerCase();

      return resultText == 'true';
    } catch (e) {
      debugPrint('Error evaluating meaning: $e');
      return false;
    }
  }

  Future<bool> evaluateSentenceAssembly(String correctSentence, String userAnswer) async {
    try {
      final prompt = _buildSentenceAssemblyEvaluationPrompt(correctSentence, userAnswer);
      final response = await _model.generateContent([Content.text(prompt)]);
      final resultText = response.text?.trim().toLowerCase();

      return resultText == 'true';
    } catch (e) {
      debugPrint('Error evaluating sentence assembly: $e');
      // Fallback to strict comparison on API error
      return correctSentence.trim().toLowerCase() == userAnswer.trim().toLowerCase();
    }
  }

  String _buildSentenceAssemblyEvaluationPrompt(String correctSentence, String userAnswer) {
    return 'Evaluate if the user\'s assembled sentence is a grammatically correct and semantically equivalent alternative to the correct sentence. The user was given a pool of words to form a sentence. Correct sentence: "$correctSentence". User\'s assembled sentence: "$userAnswer". Respond with only "true" if the user\'s sentence is an acceptable alternative, and "false" otherwise. Minor punctuation differences are acceptable.';
  }

  String _buildCoursePrompt(String text, String language) {
    return 'Create a language learning course from the following text. The course should be in $language. The output must be a valid JSON array of units. Each unit must have an id (integer), title, and a list of lessons. Each lesson must have an id (integer), title, type ("standard" or "boss"), and a list of exercises. Each exercise must have a type ("FILL_BLANK", "CHOOSE_VARIANT", "SENTENCE_ASSEMBLY", "LISTEN_AND_SELECT", "LISTEN_AND_WRITE", "MEANING_ASSESSMENT"), a question, and a data object with relevant fields (sentence, correct, options, words, context, question, correct_idea). Ensure all IDs are unique integers. Text: """$text"""';
  }

  String _buildSuggestionsPrompt(List<String> existingTitles, String language) {
    return 'Generate 3 diverse and interesting course suggestions for a language learning app. The suggestions should be in $language. Do not suggest any of the following existing titles: ${existingTitles.join(", ")}. The output must be a valid JSON array of objects, where each object has a "title" and a "description".';
  }

  String _buildEvaluationPrompt(String context, String question, String correctIdea, String userAnswer) {
    return 'Evaluate if the user\'s answer correctly captures the main idea. Context: "$context". Question: "$question". Expected idea: "$correctIdea". User answer: "$userAnswer". Respond with only "true" if the user\'s answer is semantically similar to the expected idea, and "false" otherwise.';
  }
}