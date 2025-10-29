import 'dart:convert';
import 'package:personal_ai_teacher/src/models/course.dart';
import 'package:personal_ai_teacher/src/models/user_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataService {
  static const _coursesKey = 'personalAiTeacherCourses';
  static const _userProgressKey = 'personalAiTeacherProgress';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<SavedCourse>> loadCourses() async {
    final String? coursesJson = _prefs.getString(_coursesKey);
    if (coursesJson != null) {
      try {
        final List<dynamic> decoded = json.decode(coursesJson);
        return decoded.map((json) => SavedCourse.fromJson(json)).toList();
      } catch (e) {
        // If decoding fails, return an empty list
        await _prefs.remove(_coursesKey); // Clear corrupted data
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

  Future<UserProgress> loadUserProgress() async {
    final String? progressJson = _prefs.getString(_userProgressKey);
    if (progressJson != null) {
      try {
        return UserProgress.fromJson(json.decode(progressJson));
      } catch (e) {
        // If decoding fails, return initial progress
        await _prefs.remove(_userProgressKey); // Clear corrupted data
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