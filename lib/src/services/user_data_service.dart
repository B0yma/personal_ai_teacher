import 'dart:convert';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/models/user_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataService {
  static const _coursesKey = 'personalAiTeacherCourses';
  static const _userProgressKey = 'personalAiTeacherProgress';
  static const _languageKey = 'personalAiTeacherLanguage'; // New key for language

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Language Persistence ---
  Future<String> loadLanguage() async {
    // Defaults to 'en' if no language has been saved yet.
    return _prefs.getString(_languageKey) ?? 'en';
  }

  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
  }

  // --- Course Persistence ---
  Future<List<SavedCourse>> loadCourses() async {
    final String? coursesJson = _prefs.getString(_coursesKey);
    if (coursesJson != null) {
      try {
        final List<dynamic> decoded = json.decode(coursesJson);
        return decoded.map((json) => SavedCourse.fromJson(json)).toList();
      } catch (e) {
        await _prefs.remove(_coursesKey);
        return [];
      }
    }
    return [];
  }

  Future<void> saveCourses(List<SavedCourse> courses) async {
    final String coursesJson =
    json.encode(courses.map((c) => c.toJson()).toList());
    await _prefs.setString(_coursesKey, coursesJson);
  }

  // --- User Progress Persistence ---
  Future<UserProgress> loadUserProgress() async {
    final String? progressJson = _prefs.getString(_userProgressKey);
    if (progressJson != null) {
      try {
        return UserProgress.fromJson(json.decode(progressJson));
      } catch (e) {
        await _prefs.remove(_userProgressKey);
        return UserProgress.initial;
      }
    }
    return UserProgress.initial;
  }

  Future<void> saveUserProgress(UserProgress progress) async {
    final String progressJson = json.encode(progress.toJson());
    await _prefs.setString(_userProgressKey, progressJson);
  }
}