import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/models/pilotage/data_indicateur_row_model.dart';
import 'package:perf_rse/models/pilotage/indicateur_model.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/views/pilotage/controllers/performs_data_controller.dart';

class NonEditableTable extends StatefulWidget {
  const NonEditableTable({super.key});

  @override
  State<NonEditableTable> createState() => _NonEditableTableState();
}

class _NonEditableTableState extends State<NonEditableTable> {
  final PerformsDataController performsDataController = Get.find();
  bool _showFirstLastButtons = true;
  bool _showCheckboxColumn = true;
  bool _showRowsPerPage = true;

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> dataIndicateursUser =
        getListdatasForTable(); // a adapter selon l'annee selectionnee
    return Column(
      children: [
        // Wrap(
        //   children: [
        //     Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Switch(
        //           value: _showFirstLastButtons,
        //           onChanged: (value) {
        //             setState(() {
        //               _showFirstLastButtons = value;
        //             });
        //           },
        //         ),
        //         const Text("Show First Last Buttons"),
        //       ],
        //     ),
        //     Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Switch(
        //           value: _showCheckboxColumn,
        //           onChanged: (value) {
        //             setState(() {
        //               _showCheckboxColumn = value;
        //             });
        //           },
        //         ),
        //         const Text("Show Checkbox Column"),
        //       ],
        //     ),
        //     Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Switch(
        //           value: _showRowsPerPage,
        //           onChanged: (value) {
        //             setState(() {
        //               _showRowsPerPage = value;
        //             });
        //           },
        //         ),
        //         const Text("Show Rows Per Page"),
        //       ],
        //     ),
        //   ],
        // ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: DynamicTable(
            header:  Text(tr.performanceIndicators),
            rowsPerPage: 5,
            showFirstLastButtons: _showFirstLastButtons,
            availableRowsPerPage: const [
              5,
              10,
              15,
              20,
            ],
            dataRowMinHeight: 60,
            dataRowMaxHeight: 60,
            columnSpacing: 60,
            showCheckboxColumn: _showCheckboxColumn,
            onRowsPerPageChanged: _showRowsPerPage
                ? (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Rows Per Page Changed to $value"),
                      ),
                    );
                  }
                : null,
            rows: List.generate(
              dataIndicateursUser.length, // dummyData.length
              (index) => DynamicTableDataRow(
                index: index,
                onSelectChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: value ?? false
                          ? Text("Row Selected index:$index")
                          : Text("Row Unselected index:$index"),
                    ),
                  );
                },
                cells: List.generate(
                    dataIndicateursUser[index]
                        .length, // dummyData[index].length
                    (cellIndex) => DynamicTableDataCell(
                          value: dataIndicateursUser[index][cellIndex],
                        ) // dummyData[index][cellIndex]
                    ),
              ),
            ),
            columns: [
              DynamicTableDataColumn(
                  label:  Text(tr.reference), // Name
                  onSort: (columnIndex, ascending) {},
                  dynamicTableInputType: DynamicTableTextInput()),
              // dynamicTableInputType: DynamicTableInputType.text()),
              DynamicTableDataColumn(
                  label: Text(tr.title), // Unique ID
                  onSort: (columnIndex, ascending) {},
                  isEditable: false,
                  dynamicTableInputType: DynamicTableTextInput()),
              DynamicTableDataColumn(
                  label:  Text(tr.process), // Unique ID
                  onSort: (columnIndex, ascending) {},
                  isEditable: false,
                  dynamicTableInputType: DynamicTableTextInput()),
              DynamicTableDataColumn(
                  label: const Text("Performances"), // Unique ID
                  onSort: (columnIndex, ascending) {},
                  isEditable: false,
                  dynamicTableInputType: DynamicTableTextInput()),
              // // dynamicTableInputType: DynamicTableInputType.text()),
              // DynamicTableDataColumn(
              //   label: const Text("Birth Date"),
              //   onSort: (columnIndex, ascending) {},
              //   // dynamicTableInputType: DynamicTableDateInput()
              //   dynamicTableInputType: DynamicTableInputType.date(
              //     context: context,
              //     decoration: const InputDecoration(
              //         hintText: "Select Birth Date",
              //         suffixIcon: Icon(Icons.date_range),
              //         border: OutlineInputBorder()),
              //     initialDate: DateTime(1900),
              //     lastDate: DateTime.now().add(
              //       const Duration(days: 365),
              //     ),
              //   ),
              // ),
              // DynamicTableDataColumn(
              //   label: const Text("Gender"),
              //   // dynamicTableInputType: DynamicTableDropDownInput<String>()
              //   dynamicTableInputType: DynamicTableInputType.dropDown<String>(
              //     items: genderDropdown
              //         .map((e) => DropdownMenuItem(
              //               value: e,
              //               child: Text(e),
              //             ))
              //         .toList(),
              //     selectedItemBuilder: (context) {
              //       return genderDropdown
              //           .map((e) => Text(e))
              //           .toList(growable: false);
              //     },
              //     decoration: const InputDecoration(
              //         hintText: "Select Gender", border: OutlineInputBorder()),
              //     displayBuilder: (value) =>
              //         value ??
              //         "", // How the string will be displayed in non editing mode
              //   ),
              // ),
              // DynamicTableDataColumn(
              //     label: const Text("Other Info"),
              //     onSort: (columnIndex, ascending) {},
              //     dynamicTableInputType: DynamicTableInputType.text(
              //       decoration: const InputDecoration(
              //         hintText: "Enter Other Info",
              //         border: OutlineInputBorder(),
              //       ),
              //       maxLines: 100,
              //     )),
            ],
          ),
        ),
      ],
    );
  }

  DataIndicateurRowModel getDataForSelectedYear(int selectedYear) {
    if (selectedYear == 2022) {
      return performsDataController.listOfDatasAmongYears[0];
    } else {
      int index = selectedYear - 2022;
      return performsDataController.listOfDatasAmongYears[index];
    }
  }

  List<List<dynamic>> getListdatasForTable() {
    List<List<dynamic>> result = [];
    for (IndicateurModel indicateur in performsDataController.indicateursList) {
      List tempList = [];
      tempList.add(indicateur.reference);
      tempList.add(indicateur.intitule);
      tempList.add(indicateur.processus);
      if (performsDataController
              .dataIndicateur.value.ecarts[indicateur.numero - 1] ==
          null) {
        tempList.add(tr.noData);
      } else {
        tempList.add(performsDataController
            .dataIndicateur.value.ecarts[indicateur.numero - 1]);
      }
      result.add(tempList);
    }
    return result;
  }
}
