import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../constants/constant_double.dart';
import '../../../../../../helper/responsive.dart';
import '../../../../../../models/pilotage/contributeur_model.dart';
import '../../../../../../widgets/custom_text.dart';
import '../../../../controllers/overview_pilotage_controller.dart';

class ListeContributeur extends StatefulWidget {
  const ListeContributeur({
    Key? key,
  }) : super(key: key);

  @override
  State<ListeContributeur> createState() => _ListeContributeurState();
}

class _ListeContributeurState extends State<ListeContributeur> {
  final OverviewPilotageController overviewPilotageController = Get.find();


  String returnOneName(String chaine) {
  String resultat = '';
  
  for (int i = 0; i < chaine.length; i++) {
    if (chaine[i] == ' ') {
      break;
    }
    resultat += chaine[i];
  }
  
  return resultat;
}


  void loading() async {
    await overviewPilotageController.getAllUserEntite();
  }

  @override
  void initState() {
    loading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Obx(() {
        final List<ContributeurModel> contributeurs =
            overviewPilotageController.contributeurs;
        //print(contributeurs);
        return Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Liste des contributeurs",
                    weight: FontWeight.bold,
                  ),
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding /
                            (Responsive.isMobile(context) ? 2 : 1),
                      ),
                    ),
                    onPressed: () {
                      context.go("/pilotage/espace/sucrivoire-siege/admin",
                          extra: "Contributeurs");
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Ajouter"),
                  )
                ],
              ),
              contributeurs.isEmpty
                  ? const SizedBox(
                      width: double.infinity,
                      height: 270,
                      child: Center(
                          child: SizedBox(
                        width: 300,
                        height: 50,
                        child: Text("Aucun Contributeur associé à cette entité"),
                      )),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                            columnSpacing: 40,
                            horizontalMargin: 12,
                            columns: const [
                              DataColumn(
                                label: Text("Nom"),
                              ),
                              // DataColumn(
                              //   label: Text("Filiale"),
                              // ),
                              DataColumn(
                                label: Text("Entité"),
                              ),
                              // DataColumn(
                              //   label: Text("Accès"),
                              // ),
                              DataColumn(label: Text("Processus"),),
                            ],
                            rows: List.generate(
                              contributeurs.length,
                              (index) => contributeursDataRow(
                                  contributeurs[index], colors[random.nextInt(8)]),
                            )),
                      ),
                    )
            ],
          ),
        );
      }),
    );
  }

  List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.orange,
    Colors.amber,
    Colors.brown,
    Colors.deepPurple
  ];

  DataRow contributeursDataRow(ContributeurModel fileInfo, Color color) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: Center(
                    child: Text(
                  "${fileInfo.prenom[0].toUpperCase()}${fileInfo.nom[0].toUpperCase()}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
              ),
              const SizedBox(
                width: 10,
              ),
Expanded(
  child: Text(
                    "${fileInfo.nom} ${returnOneName(fileInfo.prenom)}"
                    ),
),
              
            ],
          ),
        ),
        //DataCell(Text(fileInfo.filiale)),
        DataCell(Text(
          fileInfo.entite,
          maxLines: 2,
          )),
        //DataCell(Text(fileInfo.access)),
        DataCell(Text(
          fileInfo.processus,
          maxLines: 2,
          )),
      ],
    );
  }
}
