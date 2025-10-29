import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_ai_teacher/src/controllers/notification_controller.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/providers/app_state_provider.dart';
import 'package:personal_ai_teacher/src/routing/app_router.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';
import 'package:personal_ai_teacher/src/widgets/common/dismiss.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    asd();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  Future<void> asd() async {
    ReceivedAction? receivedAction = await AwesomeNotifications().getInitialNotificationAction(
        removeFromActionEvents: false
    );
    if (receivedAction?.payload?['navigate'] == 'true') {
      // The navigatorKey will be available when the app is already running.
      debugPrint("hello from asd");
      AppRouter.navigatorKey.currentContext?.pushNamed(AppRouter.suggestionsPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppStateProvider(
        userDataService: Provider.of(context, listen: false),
      )..loadInitialData(),
      child: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          return DismissKeyboard(
            child: MaterialApp.router(
              title: 'Personal AI Teacher',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              routerConfig: AppRouter.router,
              locale: appState.locale,
              debugShowCheckedModeBanner: false,
              supportedLocales: const [
                Locale('en', ''),
                Locale('ru', ''),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
            ),
          );
        },
      ),
    );
  }
}