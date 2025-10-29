import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/strings_en.dart';
import 'package:personal_ai_teacher/src/localization/strings_ru.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': englishStrings,
    'ru': russianStrings,
  };

  String _interpolate(String string, Map<String, dynamic> args) {
    args.forEach((key, value) {
      string = string.replaceAll('{$key}', value.toString());
    });
    return string;
  }

  String translate(String key, {Map<String, dynamic>? args}) {
    final langCode = locale.languageCode;
    String? text = _localizedValues[langCode]?[key] ?? _localizedValues['en']![key];

    if (text == null) {
      return '!!$key!!';
    }
    
    if (args != null) {
      return _interpolate(text, args);
    }

    return text;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}