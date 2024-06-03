import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/helper/helper_methods.dart';
import 'package:perf_rse/models/pilotage/data_indicateur_row_model.dart';
import 'package:perf_rse/models/pilotage/indicateur_model.dart';
import 'package:perf_rse/views/pilotage/controllers/entite_pilotage_controler.dart';
import 'package:perf_rse/views/pilotage/controllers/tableau_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ConsolidationEntityTable extends StatefulWidget {
  const ConsolidationEntityTable({super.key});

  @override
  State<ConsolidationEntityTable> createState() =>
      _ConsolidationEntityTableState();
}

class _ConsolidationEntityTableState extends State<ConsolidationEntityTable> {
  final EntitePilotageController entitePilotageController = Get.find();
  final TableauBordController tableauBordController = Get.find();
  late EntityConsoDataGridSource entityConsoDataGridSource;

  final supabase = Supabase.instance.client;
  bool isLoading = false;

  Future<List<IndicateurModel>> getListIndicateurs() async {
    setState(() {
      isLoading = true;
    });
    final List responseIndicateurs = await supabase
        .from("Indicateurs")
        .select()
        .order('numero', ascending: true);
    final listIndicateur = responseIndicateurs
        .map((json) => IndicateurModel.fromJson(json))
        .toList();
    setState(() {
      isLoading = false;
    });
    return listIndicateur;
  }

  void refreshData() async {
    final response = await getListIndicateurs();
    setState(() {
      entityConsoDataGridSource =
          EntityConsoDataGridSource(indicateurs: response);
    });
  }

  String moisEquivalent(int mois) {
    List moisNoms = [
      "Janvier",
      "Fevrier",
      "Mars",
      "Avril",
      "Mai",
      "Juin",
      "Juillet",
      "Aout",
      "Septembre",
      "Octobre",
      "Novembre",
      "Décembre"
    ];

    return moisNoms[mois - 1];
  }

  late bool isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  SfDataGridTheme _buildDataGridForWeb() {
    List sousEntites = entitePilotageController.sousEntite;
    var annee = tableauBordController.currentYear.value;
    List<GridColumn> columns = [
      GridColumn(
        columnName: 'reference',
        width: 100,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            "Réf",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'intitule',
        width: 400.0,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Intitulé",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'unite',
        width: 100,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            "Unité",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'type',
        width: 100,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Type',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'formule',
        width: 100,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Formule",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'processus',
        width: 150,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            "Processus",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'realise',
        width: 150,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Réalisé $annee",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      for (int month in tableauBordController.monthsToCurrentMonth)
      GridColumn(
        columnName: moisEquivalent(month),
        width: 150,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            moisEquivalent(month),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: '###',
        width: 50,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            '###',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];

    // Adding dynamic columns based on sousEntites
    if (sousEntites.isNotEmpty) {
      for (String? sousEntite in sousEntites) {
        if (sousEntite != null) {
          columns.add(
            GridColumn(
              columnName: sousEntite,
              width: 200,
              label: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "$sousEntite\nRéalisé $annee",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }
      }
    }

    return SfDataGridTheme(
      data: SfDataGridThemeData(
        rowHoverColor: Colors.white,
        headerHoverColor: Colors.white.withOpacity(0.3),
        headerColor: const Color.fromARGB(255, 237, 228, 147),
      ),
      child: SfDataGrid(
        source: entityConsoDataGridSource,
        columnWidthMode: ColumnWidthMode.fill,
        isScrollbarAlwaysShown: true,
        headerRowHeight: 40,
        frozenColumnsCount: 3,
        gridLinesVisibility: GridLinesVisibility.horizontal,
        columns: columns,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: isLoading
          ? loadingPageWidget()
          : Column(
              children: [Expanded(child: _buildDataGridForWeb())],
            ),
    );
  }
}

class EntityConsoDataGridSource extends DataGridSource {
  EntityConsoDataGridSource({required List<IndicateurModel> indicateurs}) {
    _indicateurs = indicateurs;
    buildDataGridRow();
  }

  EntitePilotageController entitePilotageController = Get.find();
  TableauBordController tableauBordController = Get.find();

  List<IndicateurModel> _indicateurs = <IndicateurModel>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  dynamic obtenirValeurPourCle(
      List<Map<String, List<List>>> listeDeMaps, String cle) {
    for (Map<String, List<List>> map in listeDeMaps) {
      if (map.containsKey(cle)) {
        return map[cle];
      }
    }
  }
  String moisEquivalent(int mois) {
    const moisNoms = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];

    return moisNoms[mois - 1];
  }

  void buildDataGridRow() {
    List sousEntites = entitePilotageController.sousEntite;

    dataGridRows = _indicateurs.map<DataGridRow>((IndicateurModel indicateur) {
      List<DataGridCell> cells = [
        DataGridCell<Map<String, dynamic>>(columnName: 'reference', value: {
          "valeur": indicateur.reference,
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'intitule', value: {
          "valeur": indicateur.intitule,
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference,
          "formule": indicateur.formule
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'unite', value: {
          "valeur": indicateur.unite,
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'type', value: {
          "valeur": indicateur.type,
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'formule', value: {
          "valeur": indicateur.formule,
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'processus', value: {
          "valeur": indicateur.processus,
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'realise', value: {
          "valeur":
              '${tableauBordController.dataIndicateur.value.valeurs[indicateur.numero - 1][0] ?? '----'}',
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference
        }),
        for(int month in tableauBordController.monthsToCurrentMonth)
        DataGridCell<Map<String, dynamic>>(columnName: moisEquivalent(month), value: {
          "valeur": '${tableauBordController.dataIndicateur.value.valeurs[indicateur.numero - 1][month] ?? '----'}',
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference
        })
      ];

      // Ajouter des DataGridCell pour chaque sous-entité
      if (sousEntites.isNotEmpty) {
        cells.add(const DataGridCell<Map<String, dynamic>>(
            columnName: '###', value: {"valeur": "----"}));
        for (int i = 0; i < sousEntites.length; i++) {
          DataIndicateurRowModel? entiteDataIndicateur = tableauBordController
              .dataIndicateurSousEntite['${sousEntites[i]}'];
          cells.add(DataGridCell<Map<String, dynamic>>(
              columnName: '${sousEntites[i]}',
              value: {
                "valeur":
                    '${entiteDataIndicateur?.valeurs[indicateur.numero - 1][0] ?? '----'}',
                "type": indicateur.type,
                "numero": indicateur.numero,
                "reference": indicateur.reference,
                "formule": indicateur.formule
              }));
        }
      } else {
        // Si sousEntites est vide, ajouter une cellule par défaut
        cells.add(const DataGridCell<Map<String, dynamic>>(
            columnName: '###', value: {"valeur": "----"}));
      }
      return DataGridRow(cells: cells);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell dataCell) {
      if (dataCell.value is Map<String, dynamic>) {
        Map<String, dynamic> valueMap = dataCell.value;
        if (valueMap.containsKey("type") && valueMap.containsKey("valeur")) {
          if (valueMap["type"] is! String || valueMap["valeur"] is! String) {
            // Log si les types ne sont pas ceux attendus
            print(
                "Type mismatch: Expected 'String' for 'type' and 'valeur', but got ${valueMap["type"].runtimeType} and ${valueMap["valeur"].runtimeType}");
          }
        } else {
          // Log si les clés ne sont pas présentes
          print(
              "Missing keys: Expected 'type' and 'valeur' in value map, but got keys ${valueMap.keys}");
        }
      } else {
        // Log si la valeur n'est pas du type attendu
        print(
            "Type mismatch: Expected Map<String, dynamic>, but got ${dataCell.value.runtimeType}");
      }
      switch (dataCell.columnName) {
        case "intitule":
          return Container(
            color: dataCell.value["type"] == "Calculé"
                ? const Color(0xFFFDDDCC)
                : dataCell.value["type"] == "Test"
                    ? const Color(0xFFB3B9C0)
                    : Colors.transparent,
            padding: const EdgeInsets.only(left: 8.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                              "${dataCell.value["valeur"]}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                )

              ],
            ),
          );
        default:
          return Container(
            color: dataCell.value["type"] == "Calculé"
                ? const Color(0xFFFDDDCC)
                : dataCell.value["type"] == "Test"
                    ? const Color(0xFFB3B9C0)
                    : Colors.transparent,
            padding: const EdgeInsets.only(left: 8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              "${dataCell.value["valeur"] ?? "---"}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
      }
    }).toList());
  }
}
