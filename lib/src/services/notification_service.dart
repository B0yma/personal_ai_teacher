import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/config.dart';
import 'package:personal_ai_teacher/src/controllers/notification_controller.dart';

class NotificationService {
  static const String channelKey = 'suggestion_channel';
  static const String channelName = 'Course Suggestions';
  static const String channelDescription = 'Notifications with new course suggestions.';
  static const int notificationId = 100;

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null, // null for default icon
      [
        NotificationChannel(
          channelKey: channelKey,
          channelName: channelName,
          channelDescription: channelDescription,
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
      debug: true,
    );

    // This listener is now ONLY for background/terminated states.
    // The foreground listener is set up in the App widget.
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  static Future<void> requestPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> scheduleCourseSuggestionNotification() async {
    await AwesomeNotifications().cancel(notificationId);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: channelKey,
        title: 'Вас ждут новые открытия!',
        body: 'Подобрал пару терминов, нажмите, чтобы посмотреть.',
        notificationLayout: NotificationLayout.Default,
        payload: {'navigate': 'true'},
      ),
      schedule: NotificationInterval(
        interval: const Duration(minutes: Config.notificationIntervalMinutes),
        repeats: true,
        allowWhileIdle: true,
      ),
    );
  }

  static Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }
}