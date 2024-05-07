import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/helper/helper_methods.dart';
//import 'package:perfqse/Views/pilotage/entity/tableau_bord/controller_tableau_bord/controller_tableau_bord.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../helpers/helper_methods.dart';
import 'autre/widgets/evaluation_utils.dart';
import 'gestion_audits/plan_audit/plan_audit_page.dart';
import 'widget/app_bar_audit.dart';
import 'widget/copyright.dart';
import 'widget/drawer.dart';

class ScreenEvaluation extends StatefulWidget {
  final Widget child;
  /// Constructs a [ScreenEvaluation] widget.
  const ScreenEvaluation({super.key, required this.child});

  @override
  State<ScreenEvaluation> createState() =>
      _ScreenEvaluationState();
}

class _ScreenEvaluationState extends State<ScreenEvaluation> {
  final storage = FlutterSecureStorage();
  final supabase = Supabase.instance.client;
  //final ControllerTableauBord controllerTb=Get.put(ControllerTableauBord());
  late Future<Map> EvaluationData;


  Future<Map> loadDataEvaluation() async{
    var data = {};
    String? email = await storage.read(key: 'email');
    final user = await supabase.from('Users').select().eq('email', email!);
    final accesEvaluation = await supabase.from('AccesEvaluation').select().eq('email', email);
    data["user"] = user[0] ;
    data["accesEvaluation"] = accesEvaluation[0] ;
    if(checkAccesPilotage(accesEvaluation[0]) ==false) {
      await Future.delayed(Duration(milliseconds: 500));
      context.go("/");
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    EvaluationData = loadDataEvaluation();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder<Map?>(
        future: EvaluationData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: loadingPageWidget(),
              ),
            );
          }
          final data = snapshot.data!;

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: AppBarEvaluation(),
            ),
            body: Scaffold(
              drawer: const DrawerEvaluation(),
              endDrawer: const DrawerEvaluation(),
              body: Row(
                children: [
                  const DrawerEvaluation(),
                  Expanded(child: widget.child)],
              ),
            ),
          );
      }
    );
  }
}
