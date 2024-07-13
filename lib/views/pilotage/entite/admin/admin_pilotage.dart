import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'admin_controller.dart';
import 'widgets/contributeurs_screen.dart';
import 'widgets/indicateurs_screen.dart';

class AdministrationPilotage extends StatefulWidget {
  const AdministrationPilotage({super.key});

  @override
  State<AdministrationPilotage> createState() => _AdministrationPilotageState();
}
class _AdministrationPilotageState extends State<AdministrationPilotage> {
  final adminPilotageController = Get.put(AdminPilotageController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final adminCard = adminPilotageController.titleCard.value;
      return  Column(
        children: [
           Row(
            children: [
              ButtonCard(title: tr.contributeurs,),
             const SizedBox(width: 10,),
              ButtonCard(title: tr.indicators),
              const  SizedBox(width: 10,),
            ],
          ),
          const SizedBox(height: 10,),
          Expanded(child: adminCard == tr.contributeurs ?  const ContributeurScreen() : const IndicateursScreen() )
        ],
      );
    });
  }
}


class ButtonCard extends StatefulWidget {
  final String title;
  const ButtonCard({super.key, required this.title});

  @override
  State<ButtonCard> createState() => _ButtonCardState();
}

class _ButtonCardState extends State<ButtonCard> {
  final AdminPilotageController adminPilotageController = Get.find();
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final titleCard = adminPilotageController.titleCard.value;
      return InkWell(
        onTap: (){
          adminPilotageController.titleCard.value = widget.title;
        },
        onHover: (value){
          setState(() {
            isHovering = value;
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              color: titleCard == widget.title ? Colors.amber : isHovering ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(widget.title,style: const TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),)),
          ),
        ),
      );
    });
  }
}

