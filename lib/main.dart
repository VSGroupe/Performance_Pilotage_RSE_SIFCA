import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:perf_rse/l10n/gen_l10n/app_localizations.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/utils/localization_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/theme/theme.dart';
import '/theme/themes.dart';
import 'controller/time_system_controller.dart';
import 'routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
void main() async {
  await TimeSystemController.initDateTime();
  await GetStorage.init();
  await Supabase.initialize(
    url: "https://djlcnowdwysqbrggekme.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRqbGNub3dkd3lzcWJyZ2dla21lIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIxNzc1NjcsImV4cCI6MjAwNzc1MzU2N30.UxvLKjDhQ4ghsGTTY7Sy1Q75YCktx2nXR2pHuLeIMF4",
  );
  

 runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => LocalizationProvider())] ,
    child:  const MyApp()));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final settings = ThemeSettings(
    sourceColor: Colors.amber,
    themeMode: ThemeMode.system,
  );

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
   
    return MaterialApp.router(
      onGenerateTitle: (context) {
         AppTranslations.init(context);
           return AppLocalizations.of(context)!.appTilte;
         },
      theme: Themes.ligthTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: RouteClass.router,
      builder: EasyLoading.init(),
      locale: box.read('langue')!=null ? Locale(box.read('langue')) : Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
