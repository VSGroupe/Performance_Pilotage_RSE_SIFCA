import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/views/audit/controller/controller_audit.dart';
import '../constant/constants.dart';
import '../widget/button_header_progress.dart';
import '../widget/material_global_button.dart';
import 'bilan/bilan.dart';
import 'checklist/checklist.dart';
import 'information_generale/info_gene.dart';
import 'plan_audit/plan_audit_page.dart';

class ScreenGestionAudit extends StatefulWidget {
  const ScreenGestionAudit({super.key});

  @override
  State<ScreenGestionAudit> createState() => _ScreenGestionAuditState();
}

class _ScreenGestionAuditState extends State<ScreenGestionAudit> {
  final ControllerAudit controllerAudit=Get.find();

  @override
  void initState() {
    controllerAudit.currentGestAudit.value=0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> widget=[
      InfoGeneral(),PlanAuditPage(),CheckList(),BilanAudit(),
    ];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height - 100,
      width: width - 160,
      child: Padding(
        padding: const EdgeInsets.only(top:26.0,right: 17),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/search.png",width: 30,height: 30,),
                SizedBox(width: 5,),
                RichText(text:TextSpan(text:"Audit RSE ",style: headerBoldStyle,children: [
                  TextSpan(text:"> Audit N-2023-07-19",style:headerNormalStyle)
                ]))

              ],
            ),
            Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Obx(()=>ButtonProgress(icon: Image.asset("assets/images/info.png",width: 30,height: 30,), backgroundColor:controllerAudit.currentGestAudit.value>0?confirmColor:activeColor,text:"Information Générale",)),
                  SizedBox(width: 7,),
                  Obx(()=>ButtonProgress(icon:  Image.asset("assets/images/review.png",width: 30,height: 30,), backgroundColor:controllerAudit.currentGestAudit.value<1?unselectColor:controllerAudit.currentGestAudit.value==1?activeColor:confirmColor,text:"Plan d'audit",)),
                  SizedBox(width: 7,),
                  Obx(()=> ButtonProgress(icon:  Image.asset("assets/images/checklist.png",width: 30,height: 30,), backgroundColor: controllerAudit.currentGestAudit.value<2?unselectColor:controllerAudit.currentGestAudit.value==2?activeColor:confirmColor,text:"Checklist",)),
                  SizedBox(width: 7,),
                  Obx(()=> ButtonProgress(icon:  Image.asset("assets/images/resultats.png",width: 30,height: 30,), backgroundColor: controllerAudit.currentGestAudit.value<3?unselectColor:controllerAudit.currentGestAudit.value==3?activeColor:confirmColor,text:"Bilan",)),

                ],
              ),
            ),
            Obx(()=> widget[controllerAudit.currentGestAudit.value]),
            Center(child: Obx(()
              => MaterialGlobalButon(
                  onPressed:(){
                    setState(() {
                      if(controllerAudit.currentGestAudit.value>2){
                        controllerAudit.currentGestAudit.value=0;
                      }else{
                        controllerAudit.currentGestAudit.value+=1;
                      }
                    });
                  },
                  text:controllerAudit.currentGestAudit.value==0?"Valider pour aller au plan d'audit":
                  controllerAudit.currentGestAudit.value==1?"Valider pour aller à la checkList":
                  controllerAudit.currentGestAudit.value==2?"Valider pour aller au Bilan":"Cloturer la saisie des notes et constantes",
                       backgroundColor: activeColor,
                  width: 200,
                ),
            ))//PlanAuditPage()
            ,SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
