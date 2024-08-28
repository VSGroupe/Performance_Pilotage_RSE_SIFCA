import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/helper/helper_methods.dart';
import 'package:perf_rse/models/pilotage/data_indicateur_row_model.dart';
import 'package:perf_rse/models/pilotage/indicateur_model.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/utils/operation_liste.dart';
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
        .order('axe, index_ordering, reference', ascending: true);
    final listIndicateur = responseIndicateurs
        .map((json) => IndicateurModel.fromJson(json))
        .toList();
    setState(() {
      isLoading = false;
    });
    return listIndicateur;
  }

  Future<List<IndicateurModel>> getListIndicateursEN() async {
    setState(() {
      isLoading = true;
    });
    final List responseIndicateurs = await supabase
        .from("Indicateurs_en")
        .select()
        .order('axe, index_ordering, reference', ascending: true);
    final listIndicateur = responseIndicateurs
        .map((json) => IndicateurModel.fromJson(json))
        .toList();
    setState(() {
      isLoading = false;
    });
    return listIndicateur;
  }

  void refreshData() async {
    var response;
    if (tr.abrLange.toLowerCase() == "en") {
      response = await getListIndicateursEN();
    } else {
      response = await getListIndicateurs();
    }
    setState(() {
      entityConsoDataGridSource =
          EntityConsoDataGridSource(indicateurs: response);
    });
  }

  String moisEquivalent(int mois) {
    List moisNoms = [
      tr.monthLong("january"),
      tr.monthLong("february"),
      tr.monthLong("march"),
      tr.monthLong("april"),
      tr.monthLong("may"),
      tr.monthLong("june"),
      tr.monthLong("july"),
      tr.monthLong("august"),
      tr.monthLong("september"),
      tr.monthLong("october"),
      tr.monthLong("november"),
      tr.monthLong("december")
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
    List sousEntitesNames = entitePilotageController.sousEntiteName;
    var annee = tableauBordController.currentYear.value;
    List<GridColumn> columns = [
      GridColumn(
        columnName: 'reference',
        width: 100,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tr.reference,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'intitule',
        width: 400.0,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(
            tr.title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'unite',
        width: 100,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tr.unit,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
          child: Text(
            tr.formulas,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'processus',
        width: 150,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tr.process,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
            "${tr.completed} $annee",
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
      for (String sousEntite in sousEntitesNames) {
        columns.add(
          GridColumn(
            columnName: sousEntite,
            width: 200,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "$sousEntite\n${tr.completed} $annee",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
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
    List moisNoms = [
      tr.monthLong("january"),
      tr.monthLong("february"),
      tr.monthLong("march"),
      tr.monthLong("april"),
      tr.monthLong("may"),
      tr.monthLong("june"),
      tr.monthLong("july"),
      tr.monthLong("august"),
      tr.monthLong("september"),
      tr.monthLong("october"),
      tr.monthLong("november"),
      tr.monthLong("december")
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
          "valeur": OperationList().transTypeOperation(indicateur.type),
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'formule', value: {
          "valeur": indicateur.formule != null
              ? OperationList().transTypeFormule(indicateur.formule!)
              : '----',
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'processus', value: {
          "valeur": indicateur.processus ?? '----',
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'realise', value: {
          "valeur":
              '${tableauBordController.dataIndicateur.value.valeurs[indicateur.numero - 1][0] ?? '----'}', //
          "type": indicateur.type,
          "numero": indicateur.numero,
          "reference": indicateur.reference
        }),
        for (int month in tableauBordController.monthsToCurrentMonth)
          DataGridCell<Map<String, dynamic>>(
              columnName: moisEquivalent(month),
              value: {
                "valeur":
                    '${tableauBordController.dataIndicateur.value.valeurs[indicateur.numero - 1][month] ?? '----'}', //
                "type": indicateur.type,
                "numero": indicateur.numero,
                "reference": indicateur.reference
              })
      ];

      // Ajouter des DataGridCell pour chaque sous-entité
      if (sousEntites.isNotEmpty) {
        cells.add(DataGridCell<Map<String, dynamic>>(
            columnName: '###',
            value: {"valeur": "----", "type": indicateur.type}));
        for (int i = 0; i < sousEntites.length; i++) {
          DataIndicateurRowModel? entiteDataIndicateur = tableauBordController
              .dataIndicateurSousEntite['${sousEntites[i]}'];
          cells.add(DataGridCell<Map<String, dynamic>>(
              columnName: '${sousEntites[i]}',
              value: {
                "valeur":
                    '${entiteDataIndicateur?.valeurs[indicateur.numero - 1][0] ?? '----'}', //
                "type": indicateur.type,
                "numero": indicateur.numero,
                "reference": indicateur.reference,
                "formule": indicateur.formule
              }));
        }
      } else {
        // Si sousEntites est vide, ajouter une cellule par défaut
        cells.add(DataGridCell<Map<String, dynamic>>(
            columnName: '###',
            value: {"valeur": "----", "type": indicateur.type}));
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
        // Vérification et extraction des valeurs de la cellule
        Map<String, dynamic> valueMap;
        String type = "";
        String valeur = "";

        if (dataCell.value is Map<String, dynamic>) {
          valueMap = dataCell.value;

          // Vérifier et assigner les clés
          if (valueMap.containsKey("type") && valueMap["type"] is String) {
            type = valueMap["type"];
          } else {
            print(
                "Missing or invalid 'type' key: Expected 'String' but got ${valueMap["type"]?.runtimeType}");
          }

          if (valueMap.containsKey("valeur") && valueMap["valeur"] is String) {
            valeur = valueMap["valeur"];
          } else {
            print(
                "Missing or invalid 'valeur' key: Expected 'String' but got ${valueMap["valeur"]?.runtimeType}");
          }
        } else {
          print(
              "Type mismatch: Expected Map<String, dynamic>, but got ${dataCell.value.runtimeType}");
        }

        // Création du widget pour chaque cellule selon le nom de la colonne
        switch (dataCell.columnName) {
          case "intitule":
            return Container(
              color: type == "Calculé"
                  ? const Color(0xFFFDDDCC)
                  : type == "Test"
                      ? const Color(0xFFB3B9C0)
                      : Colors.transparent,
              padding: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      valeur.isNotEmpty ? valeur : "---",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          default:
            return Container(
              color: type == "Calculé"
                  ? const Color(0xFFFDDDCC)
                  : type == "Test"
                      ? const Color(0xFFB3B9C0)
                      : Colors.transparent,
              padding: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                valeur.isNotEmpty ? valeur : "---",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
        }
      }).toList(),
    );
  }
}
