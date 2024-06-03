import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/api/supabse_db.dart';
import 'package:perf_rse/constants/constant_double.dart';
import 'package:perf_rse/views/pilotage/controllers/entite_pilotage_controler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollecteMensuelleEntites extends StatefulWidget {
  const CollecteMensuelleEntites({
    Key? key,
  }) : super(key: key);

  @override
  State<CollecteMensuelleEntites> createState() => _CollecteMensuelleEntites();
}

class _CollecteMensuelleEntites extends State<CollecteMensuelleEntites> {
  List<Map<String, dynamic>> entityInfos = [];
  final DataBaseController apiClient = DataBaseController();
  int status = 0;
  final supabase = Supabase.instance.client;
  final EntitePilotageController entitePilotageController = Get.find();
  final year = DateTime.now().year;
  final current_month = DateTime.now().month;
  var last_month = 0;

  void initialisation() async {
    List<Map<String, dynamic>> kEntityInfos = [];
    try {
      final entiteID = entitePilotageController.currentEntite.value;
      final List suiviDocList =
          await supabase.from('SuiviData').select().gte("annee", year);
      final List entiteList =
          await supabase.from('Entites').select().eq("id_entite", entiteID);
      final List affichageEntites = entiteList.first["filtre_entite_id"];

      if (current_month != 1) {
        last_month = current_month - 1;

        for (var kEntiteId in affichageEntites) {
          Map<String, dynamic> doc = {
            "$current_month": " ",
            "$last_month": " "
          };
          final ligneAnneeN = suiviDocList.firstWhere((element) =>
              (element["annee"] == year && element["id_entite"] == kEntiteId));
          doc["nom"] = ligneAnneeN["nom_entite"];
          num percentageN1 = (ligneAnneeN["suivi_mensuel"]["$current_month"]
                  ["indicateur_collectes"] /
              ligneAnneeN["indicateur_total"]);
          num percentageN2 = (ligneAnneeN["suivi_mensuel"]["$last_month"]
                  ["indicateur_collectes"] /
              ligneAnneeN["indicateur_total"]);
          doc["$current_month"] = num.parse(percentageN1.toStringAsFixed(2));
          doc["$last_month"] = num.parse(percentageN2.toStringAsFixed(2));

          kEntityInfos.add(doc);
        }
        //print(kEntityInfos);
      } else {
        last_month = 12;

        for (var kEntiteId in affichageEntites) {
          Map<String, dynamic> doc = {
            "$current_month": " ",
            "$last_month": " "
          };
          final ligneAnneeN = suiviDocList.firstWhere((element) =>
              (element["annee"] == year && element["id_entite"] == kEntiteId));
          doc["nom"] = ligneAnneeN["nom_entite"];
          num percentageN1 = (ligneAnneeN["suivi_mensuel"]["$current_month"]
                  ["indicateur_collectes"] /
              ligneAnneeN["indicateur_total"]);
          final ligneAnneeN1 = suiviDocList.firstWhere((element) =>
              (element["annee"] == year - 1 &&
                  element["id_entite"] == kEntiteId));
          num percentageN2 = (ligneAnneeN1["suivi_mensuel"]["$last_month"]
                  ["indicateur_collectes"] /
              ligneAnneeN["indicateur_total"]);
          doc["$current_month"] = num.parse(percentageN1.toStringAsFixed(2));
          doc["$last_month"] = num.parse(percentageN2.toStringAsFixed(2));

          kEntityInfos.add(doc);
        }
      }
      //print("Hello");
    } catch (e) {
      setState(() {
        status = -1;
      });
    }
    setState(() {
      status = 1;
      entityInfos = kEntityInfos;
    });
  }

  @override
  void initState() {
    initialisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: entityInfos.isEmpty
            ? SizedBox(
                width: double.infinity,
                height: 300,
                child: Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: status == -1
                        ? const Text("Aucune donnée disponible.")
                        : const CircularProgressIndicator(),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      columns: [
                        const DataColumn(
                          label: Text("Entités des filiales"),
                        ),
                        DataColumn(
                          label: Text("${obtenirNomMois(last_month)}"),
                        ),
                        DataColumn(
                          label: Text("${obtenirNomMois(current_month)}"),
                        ),
                      ],
                      rows: List.generate(
                        entityInfos.length,
                        (index) => dataRow(entityInfos[index]),
                      ))
                ],
              ),
      ),
    );
  }

  DataRow dataRow(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"] < 30
                  ? Colors.red
                  : entityInfo["$last_month"] < 60
                      ? Colors.yellow
                      : entityInfo["$last_month"] < 75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"] < 30
                  ? Colors.red
                  : entityInfo["$current_month"] < 60
                      ? Colors.yellow
                      : entityInfo["$current_month"] < 75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  String? obtenirNomMois(num chiffreMois) {
    Map<int, String> moisMap = {
      1: "Janvier",
      2: "Février",
      3: "Mars",
      4: "Avril",
      5: "Mai",
      6: "Juin",
      7: "Juillet",
      8: "Août",
      9: "Septembre",
      10: "Octobre",
      11: "Novembre",
      12: "Décembre"
    };

    String? nomMois = moisMap[chiffreMois];
    return nomMois != null && nomMois.length == 4
        ? nomMois
        : nomMois?.substring(0, 3);
  }
}

