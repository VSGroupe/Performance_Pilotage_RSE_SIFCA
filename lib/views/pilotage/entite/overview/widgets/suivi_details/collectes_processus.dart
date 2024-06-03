import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/constants/constant_double.dart';
import 'package:perf_rse/views/pilotage/controllers/entite_pilotage_controler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollecteByProcessus extends StatefulWidget {
  const CollecteByProcessus({Key? key}) : super(key: key);

  @override
  State<CollecteByProcessus> createState() => _CollecteByProcessus();
}

class _CollecteByProcessus extends State<CollecteByProcessus> {
  List<Map<String, dynamic>> entityInfos = [];
  int status = 0;
  final supabase = Supabase.instance.client;
  final EntitePilotageController entitePilotageController = Get.find();
  final year = DateTime.now().year;
  final current_month = DateTime.now().month;
  var last_month = 0;
  late int paginationItems;
  int selectedProcessusIndex = 0;
  List<String> listProcessus = [
    "Agricole",
    "Développement Durable",
    "Finances",
    "Achats",
    "Juridique",
    "Ressources Humaines",
    "Médecin",
    "Infrastructures",
    "Ressources Humaines/Juridique",
    "Gestion des Stocks / Logistique",
    "Emissions",
    "Usine"
  ];

  void initialisation() async {
    List<Map<String, dynamic>> kEntityInfos = [];
    try {
      final entiteID = entitePilotageController.currentEntite.value;
      final List suiviDocList =
          await supabase.from('SuiviData').select().gte("annee", year);
      final List entiteList =
          await supabase.from('Entites').select().eq("id_entite", entiteID);
      final List totauxProcessus = await supabase.from('Processus').select().order('id', ascending: true);
      final List affichageEntites = entiteList.first["filtre_entite_id"];

      if (current_month != 1) {
        last_month = current_month - 1;
        Map<String, List> processDatasCurrentMonth = {};
        Map<String, List> processDatasLastMonth = {};

        for (var kEntiteId in affichageEntites) {
          Map<String, dynamic> doc = {"$current_month": {}, "$last_month": {}};
          final ligneAnneeN = suiviDocList.firstWhere((element) =>
              (element["annee"] == year && element["id_entite"] == kEntiteId));
          List listN1 = [];
          List listN2 = [];
          doc["nom"] = ligneAnneeN["nom_entite"];
          for (var process in listProcessus) {
            num percentageN1 = (ligneAnneeN["suivi_processus"]["$process"]
                    ["$current_month"] /
                totauxProcessus[listProcessus.indexOf("$process")]["nombre_totale"]);
            num percentageN2 =
                (ligneAnneeN["suivi_processus"]["$process"]["$last_month"] / totauxProcessus[listProcessus.indexOf("$process")]["nombre_totale"]);
            Map<String, num> processMapN1 = {"$process": percentageN1};
            Map<String, num> processMapN2 = {"$process": percentageN2};
            listN1.add(processMapN1);
            listN2.add(processMapN2);
          }
          processDatasCurrentMonth["$kEntiteId"] = listN1;
          processDatasLastMonth["$kEntiteId"] = listN2;
          // print(kEntiteId);
          // print(processDatasCurrentMonth);
          doc["$current_month"] = processDatasCurrentMonth;
          doc["$last_month"] = processDatasLastMonth;
          doc["entite"] = kEntiteId;

          kEntityInfos.add(doc);
        }
      } else {
        last_month = 12;
        List<Map<String, num>> processDatasCurrentMonth = [];
        List<Map<String, num>> processDatasLastMonth = [];

        for (var kEntiteId in affichageEntites) {
          Map<String, dynamic> doc = {"$current_month": [], "$last_month": []};
          final ligneAnneeN = suiviDocList.firstWhere((element) =>
              (element["annee"] == year && element["id_entite"] == kEntiteId));
          final ligneAnneeN1 = suiviDocList.firstWhere((element) =>
              (element["annee"] == year - 1 &&
                  element["id_entite"] == kEntiteId));
          doc["nom"] = ligneAnneeN["nom_entite"];
          for (var process in listProcessus) {
            num percentageN1 = (ligneAnneeN["suivi_processus"]["$process"]
                    ["$current_month"] /
                totauxProcessus[listProcessus.indexOf("$process")]["nombre_totale"]);
            num percentageN2 = (ligneAnneeN1["suivi_processus"]["$process"]
                    ["$last_month"] /
                totauxProcessus[listProcessus.indexOf("$process")]["nombre_totale"]);

            Map<String, num> processMapN1 = {"$process": percentageN1};
            Map<String, num> processMapN2 = {"$process": percentageN2};
            processDatasCurrentMonth.add(processMapN1);
            processDatasLastMonth.add(processMapN2);
          }
          doc["$current_month"] = processDatasCurrentMonth;
          doc["$last_month"] = processDatasLastMonth;

          kEntityInfos.add(doc);
        }
      }
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

  void onNextProcessusPressed() {
    setState(() {
      if (selectedProcessusIndex < listProcessus.length - 1) {
        selectedProcessusIndex++;
      }
    });
  }

  void onPreviousProcessusPressed() {
    setState(() {
      if (selectedProcessusIndex > 0) {
        selectedProcessusIndex--;
      }
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(listProcessus[selectedProcessusIndex]),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: onPreviousProcessusPressed,
                                child: const Text("Précédent"),
                              ),
                              const SizedBox(width: 80),
                              ElevatedButton(
                                onPressed: onNextProcessusPressed,
                                child: const Text("Suivant"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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
                        (index) => dataRowForProcessus(entityInfos[index]),
                      ))
                ],
              ),
      ),
    );
  }

  DataRow dataRowForProcessus(Map entityInfo) {
    final selectedProcessus = listProcessus[selectedProcessusIndex];
    switch (selectedProcessus) {
      case "Agricole":
        return dataRowProcessAgricole(entityInfo);
      case "Développement Durable":
        return dataRowProcessDD(entityInfo);
      case "Finances":
        return dataRowProcessFinances(entityInfo);
      case "Achats":
        return dataRowProcessAchats(entityInfo);
      case "Juridique":
        return dataRowProcessJuridique(entityInfo);
      case "Ressources Humaines":
        return dataRowProcessRH(entityInfo);
      case "Médecin":
        return dataRowProcessRH(entityInfo);
      case "Infrastructures":
        return dataRowProcessInfrastructure(entityInfo);
      case "Ressources Humaines/Juridique":
        return dataRowProcessRHJ(entityInfo);
      case "Gestion des Stocks / Logistique":
        return dataRowProcessGestionStocks(entityInfo);
      case "Emissions":
        return dataRowProcessEmission(entityInfo);
      case "Usine":
        return dataRowProcessUsine(entityInfo);
      default:
        return dataRowProcessAgricole(entityInfo);
    }
  }

  DataRow dataRowProcessAgricole(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][0]["Agricole"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][0]
                              ["Agricole"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][0]
                                  ["Agricole"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][0]
                                      ["Agricole"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][0]["Agricole"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][0]
                              ["Agricole"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][0]
                                  ["Agricole"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [0]["Agricole"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  DataRow dataRowProcessDD(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][1]["Développement Durable"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][1]
                              ["Développement Durable"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][1]
                                  ["Développement Durable"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][1]
                                      ["Développement Durable"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][1]["Développement Durable"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][1]
                              ["Développement Durable"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][1]
                                  ["Développement Durable"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [1]["Développement Durable"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  DataRow dataRowProcessFinances(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][2]["Finances"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][2]
                              ["Finances"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][2]
                                  ["Finances"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][2]
                                      ["Finances"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][2]["Finances"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][2]
                              ["Finances"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][2]
                                  ["Finances"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [2]["Finances"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  DataRow dataRowProcessAchats(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][3]["Achats"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][3]
                              ["Achats"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][3]
                                  ["Achats"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][3]
                                      ["Achats"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][3]["Achats"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][3]
                              ["Achats"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][3]
                                  ["Achats"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [3]["Achats"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  DataRow dataRowProcessJuridique(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][4]["Juridique"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][4]
                              ["Juridique"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][4]
                                  ["Juridique"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][4]
                                      ["Juridique"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][4]["Juridique"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][4]
                              ["Juridique"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][4]
                                  ["Juridique"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [4]["Juridique"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  DataRow dataRowProcessRH(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][5]["Ressources Humaines"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][5]
                              ["Ressources Humaines"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][5]
                                  ["Ressources Humaines"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][5]
                                      ["Ressources Humaines"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][5]["Ressources Humaines"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][5]
                              ["Ressources Humaines"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][5]
                                  ["Ressources Humaines"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [5]["Ressources Humaines"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  DataRow dataRowProcessMedecin(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][6]["Médecin"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][6]
                              ["Médecin"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][6]
                                  ["Médecin"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][6]
                                      ["Médecin"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][6]["Médecin"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][6]
                              ["Médecin"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][6]
                                  ["Médecin"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [6]["Médecin"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  DataRow dataRowProcessInfrastructure(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][7]["Infrastructures"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][7]
                              ["Infrastructures"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][7]
                                  ["Infrastructures"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][7]
                                      ["Infrastructures"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][7]["Infrastructures"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][7]
                              ["Infrastructures"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][7]
                                  ["Infrastructures"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [7]["Infrastructures"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  DataRow dataRowProcessRHJ(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][8]["Ressources Humaines/Juridique"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][8]
                              ["Ressources Humaines/Juridique"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][8]
                                  ["Ressources Humaines/Juridique"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][8]
                                      ["Ressources Humaines/Juridique"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][8]["Ressources Humaines/Juridique"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][8]
                              ["Ressources Humaines/Juridique"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][8]
                                  ["Ressources Humaines/Juridique"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [8]["Ressources Humaines/Juridique"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  DataRow dataRowProcessGestionStocks(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][9]["Gestion des Stocks / Logistique"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][9]
                              ["Gestion des Stocks / Logistique"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][9]
                                  ["Gestion des Stocks / Logistique"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][9]
                                      ["Gestion des Stocks / Logistique"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][9]["Gestion des Stocks / Logistique"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][9]
                              ["Gestion des Stocks / Logistique"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][9]
                                  ["Gestion des Stocks / Logistique"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [9]["Gestion des Stocks / Logistique"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  DataRow dataRowProcessEmission(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][10]["Emissions"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][10]
                              ["Emissions"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][10]
                                  ["Emissions"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][10]
                                      ["Emissions"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][10]["Emissions"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][10]
                              ["Emissions"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][10]
                                  ["Emissions"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [10]["Emissions"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        ))
      ],
    );
  }

  DataRow dataRowProcessUsine(Map entityInfo) {
    return DataRow(
      cells: [
        DataCell(Text(entityInfo["nom"])),
        DataCell(Text(
          "${(entityInfo["$last_month"]["${entityInfo["entite"]}"][11]["Usine"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$last_month"]["${entityInfo["entite"]}"][11]
                              ["Usine"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$last_month"]["${entityInfo["entite"]}"][11]
                                  ["Usine"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$last_month"]["${entityInfo["entite"]}"][11]
                                      ["Usine"] *
                                  100 <
                              75
                          ? Colors.green
                          : Colors.blue),
        )),
        DataCell(Text(
          "${(entityInfo["$current_month"]["${entityInfo["entite"]}"][11]["Usine"] * 100).toStringAsFixed(2)} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: entityInfo["$current_month"]["${entityInfo["entite"]}"][11]
                              ["Usine"] *
                          100 <
                      30
                  ? Colors.red
                  : entityInfo["$current_month"]["${entityInfo["entite"]}"][11]
                                  ["Usine"] *
                              100 <
                          60
                      ? Colors.yellow
                      : entityInfo["$current_month"]["${entityInfo["entite"]}"]
                                      [11]["Usine"] *
                                  100 <
                              75
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
