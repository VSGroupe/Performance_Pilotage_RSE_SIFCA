import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../constants/constant_double.dart';
import '../../../../../../widgets/custom_text.dart';
import '../../../../controllers/entite_pilotage_controler.dart';
import '../../../../controllers/suivi_data_controller.dart';
import 'chart_overview.dart';
import 'data_info_card.dart';

class SuiviDetails extends StatefulWidget {
  const SuiviDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<SuiviDetails> createState() => _SuiviDetailsState();
}

class _SuiviDetailsState extends State<SuiviDetails> {
  double isHovering = 3;

  int numberTotal = 0;
  int numberValide = 0;
  int numberCollecte = 0;
  String eniteName = "";

  final supabase = Supabase.instance.client;
  final EntitePilotageController entitePilotageController = Get.find();
  final SuiviDataController suiviDataController = Get.find();

  void initialisation() async {
    final entiteID = entitePilotageController.currentEntite.value;
    final idSuivi = "${entiteID}_${suiviDataController.annee.value}";
    final List suiviDocList = await supabase.from('SuiviData').select().eq("id_suivi",idSuivi);

    final String entite = suiviDocList.first["nom_entite"];
    final int number = suiviDocList.first["indicateur_total"];
    numberValide = suiviDocList.first["indicateur_valides"];
    numberCollecte = suiviDocList.first["indicateur_collectes"];

    setState(() {
      eniteName = entite;
      numberTotal = number;
      numberCollecte = numberCollecte;
      numberValide = numberValide;
    });
  }

  @override
  void initState() {
    initialisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: (){},
      onHover: (value){
        if(value){
          setState(() {
            isHovering = 10;
          });
        }else {
          setState(() {
            isHovering =3;
          });
        }
      },
      child: Card(
        elevation: isHovering,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text:"Suivi des données ${suiviDataController.annee.value}",
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              ChartOverview(nombreTotal: numberTotal, numberVide: numberTotal-numberCollecte, numberCollecte: numberCollecte,),
              DataSuiviCard(
                svgSrc: "assets/icons/data_validated.png",
                title: "Données validées",
                nombre: "$numberTotal",
                total: numberValide,
                color: Colors.green,
              ),
              DataSuiviCard(
                svgSrc: "assets/icons/data_collect.png",
                title: "Données collectées",
                nombre: "$numberTotal",
                total: numberCollecte,
                color: Colors.amber,
              ),
              DataSuiviCard(
                svgSrc: "assets/icons/no_data.png",
                title: "Champs vides",
                nombre: "$numberTotal",
                total: numberTotal-numberCollecte,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

