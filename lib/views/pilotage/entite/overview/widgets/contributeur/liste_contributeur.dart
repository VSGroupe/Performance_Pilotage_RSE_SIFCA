import 'package:flutter/material.dart';
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
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      )),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: DataTable(
                          columnSpacing: 10,
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
                                contributeurs[index], colors[index % 8]),
                          )),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text("${fileInfo.prenom} ${fileInfo.nom}"),
              ),
            ],
          ),
        ),
        //DataCell(Text(fileInfo.filiale)),
        DataCell(Text(fileInfo.entite)),
        //DataCell(Text(fileInfo.access)),
        DataCell(Text(fileInfo.processus)),
      ],
    );
  }
}
