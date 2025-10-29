import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/app.dart';
import 'package:personal_ai_teacher/src/controllers/notification_controller.dart';
import 'package:personal_ai_teacher/src/services/notification_service.dart';
import 'package:personal_ai_teacher/src/services/user_data_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize awesome_notifications and set up the background/terminated action handler
  await NotificationService.initialize();

  final userDataService = UserDataService();
  await userDataService.init();

  runApp(
    Provider<UserDataService>.value(
      value: userDataService,
      child: const App(),
    ),
  );
}