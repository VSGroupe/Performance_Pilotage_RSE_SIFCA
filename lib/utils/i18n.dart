import 'package:flutter/material.dart';
import 'package:perf_rse/l10n/gen_l10n/app_localizations.dart';

AppLocalizations get tr => _tr!; // helper function to avoid typing '!' all the time
AppLocalizations? _tr; // global variable 

class AppTranslations {
  static init(BuildContext context) {
    _tr = AppLocalizations.of(context);
  }
  
}