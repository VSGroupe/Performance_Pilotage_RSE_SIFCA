import 'dart:ui';
import 'package:get/get.dart';
import 'package:perf_rse/constants/constants_language.dart';
import 'package:perf_rse/models/pilotage/model_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  LocalizationController({required this.sharedPreferences}) {
    // Initialiser _locale dans le constructeur
    _locale = Locale(
      sharedPreferences.getString(LanguageContants.LANGUAGE_CODE) ?? 
      LanguageContants.languages[0].languageCode,
      sharedPreferences.getString(LanguageContants.COUNTRY_CODE) ?? 
      LanguageContants.languages[0].countryCode,
    );

    loadCurrentLanguage();
  }

  late Locale _locale; // Déclarer _locale sans initialisation
  Locale get locale => _locale; // Utiliser une minuscule pour le getter

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  void loadCurrentLanguage() async {
    _locale = Locale(
      sharedPreferences.getString(LanguageContants.LANGUAGE_CODE) ??
      LanguageContants.languages[0].languageCode,
      sharedPreferences.getString(LanguageContants.COUNTRY_CODE) ??
      LanguageContants.languages[0].countryCode,
    );

    for (int index = 0; index < LanguageContants.languages.length; index++) {
      if (LanguageContants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }

    _languages = [];
    _languages.addAll(LanguageContants.languages);
    update();
  }
}

