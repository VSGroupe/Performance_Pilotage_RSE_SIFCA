import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/views/audit/controller/controller_audit.dart';
//import 'package:perfqse/Views/audit/controller/controller_audit.dart';

class TransiteAudit extends StatefulWidget {
  const TransiteAudit({super.key});

  @override
  State<TransiteAudit> createState() => _TransiteAuditState();
}

class _TransiteAuditState extends State<TransiteAudit> {
  final ControllerAudit controllerAudit =Get.put(ControllerAudit());
  final storage =FlutterSecureStorage();
  final Location="/audit/accueil";

  Future<void> _showDialogNoAcces() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Vous n'avez pas la référence d'accès à cet espace."),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/forbidden.png",
                  width: 50,
                  height: 50,
                )
              ],
            ),
          ),
        );
      },
    );
  }


  void getAccess(String centerTitle)async{
    String? reference = await storage.read(key:"ref");
    List<String> ref=["E"];
    if (reference!=null){
      ref =reference.split("\n");
    }
    if(ref.contains(centerTitle)) {
      controllerAudit.reference.value=centerTitle;
      context.go(Location);
    }else{
      _showDialogNoAcces();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 630,
        width: 1000,
        child: Center(
          child: Stack(children: [
            Positioned(
                top: 160,
                right: 385,
                child: SizedBox(
                  height: 250,
                  width: 250,
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          getAccess("QSE");
                        });
                      },
                      mouseCursor: SystemMouseCursors.click,
                      child: Image.asset("assets/images/qse.png", fit: BoxFit.contain)),
                )),
            Positioned(
                top: 0,
                right: 350,
                child: SizedBox(
                  height: 160,
                  width: 300,
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          getAccess("QS");
                        });
                      },
                      mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/qs.png", fit: BoxFit.contain)),
                )),
            Positioned(
                bottom:0,
                right: 350,
                child: SizedBox(
                  height: 200,
                  width: 300,
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          getAccess("E");
                        });
                      },
                      mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/e.png", fit: BoxFit.contain)),
                )),
            Positioned(
                top: 140,
                left: 60,
                child: SizedBox(
                  height: 160,
                  width: 300,
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          getAccess("Q");
                        });
                      },
                      mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/q.png", fit: BoxFit.contain)),
                )),
            Positioned(
                top: 140,
                right: 60,
                child: SizedBox(
                  height: 160,
                  width: 300,
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          getAccess("S");
                        });
                      },
                      mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/s.png", fit: BoxFit.contain)),
                )),
            Positioned(
                top: 340,
                right: 100,
                child: SizedBox(
                  height: 200,
                  width: 250,
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          getAccess("SE");
                        });
                      },
                      mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/se.png", fit: BoxFit.contain)),
                )),
            Positioned(
                top: 340,
                left: 100,
                child: SizedBox(
                  height: 200,
                  width: 250,
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          getAccess("QE");
                        });
                      },
                      mouseCursor: SystemMouseCursors.click,child: Image.asset("assets/images/qe.png", fit: BoxFit.contain)),
                )),
          ]),
        ),
      ),
    );
  }
}
