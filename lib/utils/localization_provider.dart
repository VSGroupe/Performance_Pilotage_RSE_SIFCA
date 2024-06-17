import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalizationProvider with ChangeNotifier {
  Locale _locale = const Locale('fr'); 
  final storage = const FlutterSecureStorage();
  Locale get locale => _locale;

  set locale(Locale newLocale){
    _locale = newLocale;
    notifyListeners();
  }

  void chnageLanguage(String langue){
    if(langue =='Français' || langue =='Française'){
        _locale = Locale('fr');
        storage.write(key: 'langue', value: 'fr');
    }else{
       _locale = Locale('en');
       storage.write(key: 'langue', value: 'fr');
    }
    notifyListeners();
  }
}