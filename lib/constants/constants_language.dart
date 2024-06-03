import 'package:perf_rse/models/pilotage/model_language.dart';

class LanguageContants {
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(
        languageName: 'French', countryCode: 'FR', languageCode: 'fr'),
    LanguageModel(
        languageName: 'English', countryCode: 'EN', languageCode: 'en'),
  ];
}
