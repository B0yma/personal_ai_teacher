class Config {
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'YOUR_API_KEY_HERE',
  );

  // Notification interval in minutes
  static const int notificationIntervalMinutes = 5;
}