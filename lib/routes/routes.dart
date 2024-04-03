import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../views/common/forgot_password/change_password.dart';
import '../views/common/reload_page/reload_screen.dart';
import '../views/common/update_page/update_page.dart';
import '../views/export_page.dart';
import '../views/pilotage/entite/admin/screen_admin_pilotage.dart';
import '../views/pilotage/entite/connexion_historique/screen_connexion_historique.dart';
import '../views/pilotage/entite/entity_piloatage_main.dart';
import '../views/pilotage/entite/overview/screen_overview_pilotage.dart';
import '../views/pilotage/entite/performs/screen_pilotage_perform.dart';
import '../views/pilotage/entite/profil/screen_pilotage_profil.dart';
import '../views/pilotage/entite/suivi/screen_suivi_pilotage.dart';
import '../views/pilotage/entite/support_client/screen_support_client.dart';
import '../views/pilotage/entite/tableau_bord/indicateur_screen.dart';
import '../views/pilotage/entite/tableau_bord/screen_tableau_bord_pilotage.dart';
import '../widgets/loading_widget.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class RouteClass {
  static final supabase = Supabase.instance.client;

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: supabase.auth.currentSession != null ? "/" : "/account/login",
    errorBuilder: (context, state) {
      return const PageNotFound();
    },
    routes: [
      GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const MainPage(),
          ),
      ),
      //
      GoRoute(
        path: '/reload-page',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          restorationId: state.pageKey.value,
          child: ReloadScreen(redirection: state.extra.toString(),),
        ),
      ),
      GoRoute(
          path: '/pilotage',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const PilotageHome(),
          ),
          routes: [
            GoRoute(
                path: 'espace/:entiteId',
                name: "Sucrivoire Siège",
                pageBuilder: (context, state) => NoTransitionPage<void>(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: const Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(
                        child: LoadingWidget(),
                      ),
                    )//const PilotageEntiteOverview(urlPath: "profil"),
                ),
                routes:[
                  ShellRoute(
                    navigatorKey: _shellNavigatorKey,
                    builder: (BuildContext context, GoRouterState state, Widget child) {
                      return EntityPilotageMain(entiteId: state.pathParameters['entiteId'], child: child);
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'accueil',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenOverviewPilotage()
                        ),
                      ),
                      GoRoute(
                        path: 'tableau-de-bord',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenTableauBordPilotage()
                        ),
                        routes: [
                          GoRoute(
                              path: 'indicateurs',
                              pageBuilder: (context, state) => NoTransitionPage<void>(
                                  key: state.pageKey,
                                  child: const IndicateurScreen()
                              ),
                          )
                        ]
                      ),
                      GoRoute(
                        path: 'profil',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenPilotageProfil()
                        ),
                      ),
                      //
                      GoRoute(
                        path: 'performances',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenPilotagePerform()
                        ),
                      ),
                      GoRoute(
                        path: 'suivi-des-donnees',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenPilotageSuivi()
                        ),
                      ),
                      GoRoute(
                        path: 'admin',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenPilotageAdmin()
                        ),
                      ),
                      GoRoute(
                        path: 'support-client',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenSupportClient()
                        ),
                      ),
                      GoRoute(
                        path: 'historique-des-modifications',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenConnexionHistorique()
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ]),
      GoRoute(
          path: '/account/login',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const LoginPage(),
          )
      ),
      GoRoute(
          path: '/account/change-password',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: ChangePassWordScreen(event: state.extra.toString()),
          )
      ),
      GoRoute(
          path: '/account/forgot-password',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const ForgotPassword(),
          )
      ),
      GoRoute(
          path: '/mise-a-jour',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const UpdatedPage(),
          )
      ),
    ],
    redirect: (context ,state) async {

      if (state.fullPath!=null && state.fullPath =="/account/forgot-password"){
        return null;
      }
      supabase.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        var session = event.name;
        if (session == "passwordRecovery") {
          context.go("/account/change-password",extra:"passowrdRecovery");
        }
      });

      const storage = FlutterSecureStorage();
      String? loggedPref = await storage.read(key: 'logged');
      String? email = await storage.read(key: 'email');
      String? isInitTime = await storage.read(key: 'isInitTime');
      
      if ( state.fullPath!=null && state.fullPath =="/account/change-password" ){
        return null;
      }
      
      // bool sessionVerification = false;
      // final session = supabase.auth.currentSession;
      
      // if (session != null) {
      //   sessionVerification = true;
      // } else {
      //   sessionVerification = false;
      // }
      if (loggedPref == "true" && email!=null && isInitTime == "true" && GetUtils.isEmail(email)) {
        return null; // && sessionVerification ==true
      }
      // await supabase.auth.signOut();
      // return "/account/login";
    },
  );
}
