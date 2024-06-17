import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/models/pilotage/indicateur_model.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/views/pilotage/controllers/tableau_controller.dart';

class AllMonthsTable extends StatefulWidget {
  const AllMonthsTable({super.key});

  @override
  State<AllMonthsTable> createState() => _AllMonthsTableState();
}

class _AllMonthsTableState extends State<AllMonthsTable> {
  final TableauBordController tableauBordController = Get.find();
  final TextEditingController _textController = TextEditingController();

  List<List<String?>> dataIndicateurs = [];
  List<List<String?>> filteredDatasList = [];

  @override
  void initState() {
    filteredDatasList = getListdatasForTable();
    dataIndicateurs = getListdatasForTable();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      filteredDatasList = text.isEmpty
          ? dataIndicateurs
          : dataIndicateurs.where((item) => item[0]!.contains(text)).toList();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textController,
            decoration:  InputDecoration(
              hintText:tr.referenceIndicators,
              border: const OutlineInputBorder(),
            ),
            onChanged: _onSearchTextChanged,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: DynamicTable(
            showCheckboxColumn: false,
            header: Text("${tr.displayingDataMonth} ""${moisEquivalent(tableauBordController.monthsToCurrentMonth.length)}"),
            showActions: false,
            dataRowMaxHeight: 60,
            dataRowMinHeight: 60,
            columnSpacing: 60,
            rows: List.generate(
                filteredDatasList.length,
                (index) => DynamicTableDataRow(
                    color: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        // Check if the last element of dataIndicateurs[index] is "Calculé"
                        bool isCalcule = filteredDatasList[index]
                                [filteredDatasList[index].length - 1] ==
                            "Calculé";
                        // Check if the last element of dataIndicateurs[index] is "Test"
                        bool isTest = filteredDatasList[index]
                                [filteredDatasList[index].length - 1] ==
                            "Test";

                        // Return orange if isCalcule is true, grey if isTest is true, otherwise return white
                        if (isCalcule) {
                          return Colors.orange;
                        } else if (isTest) {
                          return Colors.grey;
                        } else {
                          return Colors.white;
                        }
                      },
                    ),
                    index: index,
                    cells: List.generate(
                        filteredDatasList[index].length - 1,
                        (cellIndex) => DynamicTableDataCell(
                              value: filteredDatasList[index][cellIndex],
                            )))),
            columns: [
              DynamicTableDataColumn(
                  label:  Text(tr.reference),
                  dynamicTableInputType: DynamicTableTextInput()),
              DynamicTableDataColumn(
                label:  Text(tr.title),
                dynamicTableInputType: DynamicTableTextInput(),
                isEditable: false,
              ),
              DynamicTableDataColumn(
                label:  Text(tr.process),
                dynamicTableInputType: DynamicTableTextInput(),
                isEditable: false,
              ),
              DynamicTableDataColumn(
                label:  Text(tr.completed),
                dynamicTableInputType: DynamicTableTextInput(),
                isEditable: false,
              ),
              for (int month in tableauBordController.monthsToCurrentMonth)
                DynamicTableDataColumn(
                  label: Text(moisEquivalent(month)),
                  dynamicTableInputType: DynamicTableTextInput(),
                  isEditable: false,
                ),
            ],
          ),
        )
      ],
    );
  }

  List<List<String?>> getListdatasForTable() {
    List<List<String?>> result = [];
    for (IndicateurModel indicateur in tableauBordController.indicateursList) {
      List<String?> tempList = [];
      tempList.add(indicateur.reference);
      tempList.add(indicateur.intitule);
      tempList.add(indicateur.processus);

      var value = tableauBordController
          .dataIndicateur.value.valeurs[indicateur.numero - 1][0];
      var valueType = indicateur.type;
      if (value == null) {
        tempList.add("----");
      } else if (valueType == "Test") {
        if (value == 1) {
          tempList.add(tr.trueV);
        } else {
          tempList.add(tr.falseV);
        }
      } else {
        tempList.add("${value}");
      }
      // Realise

      for (int month in tableauBordController.monthsToCurrentMonth) {
        var value = tableauBordController
            .dataIndicateur.value.valeurs[indicateur.numero - 1][month];
        var valueType = indicateur.type;
        if (value == null) {
          tempList.add("----");
        } else if (valueType == "Test") {
          if (value == 1) {
            tempList.add(tr.trueV);
          } else {
            tempList.add(tr.falseV);
          }
        } else {
          tempList.add("${value}");
        }
      }
      tempList.add(indicateur.type);
      result.add(tempList);
    }
    return result;
  }
}
