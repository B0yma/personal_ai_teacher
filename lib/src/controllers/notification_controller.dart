import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_ai_teacher/src/routing/app_router.dart';

/// A dedicated controller for handling notification actions.
class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// This method is called when the user taps on a notification.
  /// It handles taps when the app is in the FOREGROUND or BACKGROUND.
  /// Taps from a TERMINATED state are handled by `getInitialNotificationAction` in App.dart.
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.payload?['navigate'] == 'true') {
      // The navigatorKey will be available when the app is already running.
      debugPrint("hello from app");
      AppRouter.navigatorKey.currentContext?.pushNamed(AppRouter.suggestionsPath);
    }
  }
}