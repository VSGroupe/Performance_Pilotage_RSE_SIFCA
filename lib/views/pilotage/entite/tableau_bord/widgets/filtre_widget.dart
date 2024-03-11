import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/models/pilotage/acces_pilotage_model.dart';
import 'package:popover/popover.dart';
import '../../../../../api/supabse_db.dart';
import 'package:animated_icon/animated_icon.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../controllers/drop_down_controller.dart';
import '../../../controllers/entite_pilotage_controler.dart';
import '../../../controllers/export_data_controller.dart';
import '../../../controllers/profil_pilotage_controller.dart';
import '../../../controllers/tableau_controller.dart';

class FiltreTableauBord extends StatefulWidget {
  const FiltreTableauBord({Key? key}) : super(key: key);

  @override
  State<FiltreTableauBord> createState() => _EntityWidgetWidgetState();
}

class _EntityWidgetWidgetState extends State<FiltreTableauBord> {
  bool isLoadingPrint = false;
  bool isLoadingExcel = false;
  final ExportDataController exportDataController = ExportDataController();
  final EntitePilotageController entitePilotageController = Get.find();
  final TableauBordController tableauBordController = Get.find();
  final ProfilPilotageController profilPilotageController = Get.find();
  final DataBaseController mongoDBController = DataBaseController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 20,
          ),
          const YearFiltreWidget(),
          const SizedBox(
            width: 10,
          ),
          const MonthFiltreWidget(),
          const SizedBox(
            width: 10,
          ),
          const FiltreWidget(),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: AnimateIcon(
              key: UniqueKey(),
              onTap: () {
                tableauBordController.refreshData();
              },
              iconType: IconType.animatedOnTap,
              color: Colors.blue,
              animateIcon: AnimateIcons.refresh,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                hoverColor: Colors.blue.withOpacity(0.2),
                onTap: isLoadingPrint
                    ? null
                    : () async {
                        setState(() {
                          isLoadingPrint = true;
                        });
                        final result =
                            await exportDataController.loadDataExport(
                                entitePilotageController.currentEntite.value,
                                tableauBordController.currentYear.value);
                        if (result != null) {
                          await exportDataController.downloadPDF(result);
                        }
                        setState(() {
                          isLoadingPrint = false;
                        });
                      },
                child: Container(
                  height: 40,
                  width: 120,
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: isLoadingPrint
                      ? const Center(
                          child: SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator()))
                      : const Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("PDF"),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                ),
              )),
//exportation en excel
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                hoverColor: Colors.blue.withOpacity(0.2),
                onTap: isLoadingPrint
                    ? null
                    : () async {
                        setState(() {
                          isLoadingExcel = true;
                        });
                        final result =
                            await exportDataController.loadDataExport(
                                entitePilotageController.currentEntite.value,
                                tableauBordController.currentYear.value);
                        if (result != null) {
                          await exportDataController.downloadExcel(result);
                        }
                        setState(() {
                          isLoadingExcel = false;
                        });
                      },
                child: Container(
                  height: 40,
                  width: 120,
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: isLoadingExcel
                      ? const Center(
                          child: SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator()))
                      : Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Image.asset('assets/icons/excel.png'),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text("Excel"),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                ),
              )),
          Obx(() {
            final acces =
                getAcces(profilPilotageController.accesPilotageModel.value);
            return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(width: 3.0),
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                ),
                child: CustomText(
                  text: acces,
                  size: 13,
                  color: Colors.green,
                ));
          }),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  String getAcces(AccesPilotageModel acces) {
    if (acces.estBloque == true) {
      return "Bloqué";
    }
    if (acces.estAdmin == true) {
      return " Admin ";
    }
    if (acces.estValidateur == true) {
      return "Validateur";
    }
    if (acces.estEditeur == true) {
      return "Editeur";
    }
    if (acces.estSpectateur == true) {
      return "Spectateur";
    }
    return "";
  }
}

class YearFiltreWidget extends StatefulWidget {
  const YearFiltreWidget({super.key});

  @override
  State<YearFiltreWidget> createState() => _YearFiltreWidgetState();
}

class _YearFiltreWidgetState extends State<YearFiltreWidget> {
  static const availbleYearList = <String>[
    '2024',
    '2023',
    '2022',
    '2021',
  ];

  bool isCheckBox = false;

  List<PopupMenuItem<String>> _popUpMenuYearItems() {
    return availbleYearList.map(
      (String value) {
        return PopupMenuItem<String>(
            value: value,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Row(
                children: [
                  Text(value),
                ],
              );
            }));
      },
    ).toList();
  }

  final TableauBordController tableauBordController = Get.find();

  String _btn3SelectedYear = "";

  void initialisation() {
    setState(() {
      _btn3SelectedYear = tableauBordController.currentYear.value.toString();
    });
  }

  @override
  void initState() {
    initialisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const Text(
            "Année: ",
            style: TextStyle(fontSize: 18),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5E7))),
            child: Row(
              children: [
                Text(_btn3SelectedYear, style: const TextStyle(fontSize: 15)),
                const SizedBox(
                  width: 5,
                ),
                PopupMenuButton<String>(
                  splashRadius: 15,
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.grey,
                  ),
                  onSelected: (String newValue) {
                    setState(() {
                      _btn3SelectedYear = newValue;
                      tableauBordController
                          .changeYear(int.parse(_btn3SelectedYear));
                    });
                    tableauBordController.initialisation(context);
                  },
                  itemBuilder: (BuildContext context) => _popUpMenuYearItems(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MonthFiltreWidget extends StatefulWidget {
  const MonthFiltreWidget({super.key});

  @override
  State<MonthFiltreWidget> createState() => _MonthFiltreWidgetState();
}

class _MonthFiltreWidgetState extends State<MonthFiltreWidget> {
  final TableauBordController tableauBordController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  List<PopupMenuItem<Map<String, dynamic>>> _popUpMenuMonthItems(
      List<Map<String, dynamic>> monthList) {
    return monthList.map((month) {
      return PopupMenuItem<Map<String, dynamic>>(
          value: month,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Row(
              children: [
                Obx(() {
                  var currentMonth = tableauBordController.currentMonth.value;
                  return Checkbox(
                      value: month["id"] == currentMonth,
                      splashRadius: 15,
                      checkColor: Colors.blue,
                      side: MaterialStateBorderSide.resolveWith(
                        (states) {
                          return BorderSide(
                              width: 2.0,
                              color: month["id"] == currentMonth
                                  ? Colors.blue
                                  : Colors.grey);
                        },
                      ),
                      fillColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.transparent),
                      onChanged: null);
                }),
                const SizedBox(
                  width: 20,
                ),
                CustomText(text: "${month["month"]}")
              ],
            );
          }));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const Text(
            "Mois:  ",
            style: TextStyle(fontSize: 18),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5E7))),
            child: Row(
              children: [
                Obx(() {
                  var currentMonth0 = tableauBordController.currentMonth.value;
                  var showMonth =
                      tableauBordController.listMonth[currentMonth0 - 1];
                  return Text(showMonth, style: const TextStyle(fontSize: 15));
                }),
                const SizedBox(
                  width: 5,
                ),
                Obx(() {
                  var currentMonth = tableauBordController.currentMonth.value;
                  var currentYear = tableauBordController.currentYear.value;
                  List<Map<String, dynamic>> monthList = [];
                  var datetime = DateTime.now();
                  if (currentYear > datetime.year) {
                    return Container();
                  }
                  if (currentYear == datetime.year) {
                    for (var i = 0; i < datetime.month; i++) {
                      monthList.add({
                        "id": i + 1,
                        "month": tableauBordController.listMonth[i]
                      });
                    }
                    return PopupMenuButton<Map<String, dynamic>>(
                      constraints: const BoxConstraints(
                        maxHeight: 300,
                      ),
                      splashRadius: 15,
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: Colors.grey,
                      ),
                      onCanceled: () {
                        setState(() {});
                      },
                      onSelected: (Map<String, dynamic> newValue) {
                        setState(() {
                          tableauBordController.changeMonth(newValue["id"]);
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          _popUpMenuMonthItems(monthList),
                    );
                  } else if (currentYear < datetime.year) {
                    for (var i = 0; i < 12; i++) {
                      monthList.add({
                        "id": i + 1,
                        "month": tableauBordController.listMonth[i]
                      });
                    }
                    return PopupMenuButton<Map<String, dynamic>>(
                      constraints: const BoxConstraints(
                        maxHeight: 300,
                      ),
                      splashRadius: 15,
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: Colors.grey,
                      ),
                      onCanceled: () {
                        setState(() {});
                      },
                      onSelected: (Map<String, dynamic> newValue) {
                        setState(() {
                          tableauBordController.changeMonth(newValue["id"]);
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          _popUpMenuMonthItems(monthList),
                    );
                  }
                  return Container();
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FiltreWidget extends StatefulWidget {
  const FiltreWidget({super.key});

  @override
  State<FiltreWidget> createState() => _AxeFiltreWidgetState();
}

class _AxeFiltreWidgetState extends State<FiltreWidget> {
  bool isCheckBox = false;

  final TableauBordController tableauBordController = Get.find();
  final DropDownController dropDownController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E5E7))),
        child: Obx(() {
          final filtreProcessus = dropDownController.filtreProcessus;
          return Row(
            children: [
              const SizedBox(
                width: 80,
                child: Text(
                  "Processus",
                  style: TextStyle(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (filtreProcessus.isNotEmpty)
                Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.green),
                  width: 25,
                  height: 25,
                  child: Center(
                      child: Text(
                    "${filtreProcessus.length}",
                    style: const TextStyle(color: Colors.white),
                  )),
                ),
              const SizedBox(
                width: 5,
              ),
              IconButton(
                  onPressed: () {
                    showPopover(
                      context: context,
                      bodyBuilder: (context) => popoverWidget(context),
                      direction: PopoverDirection.bottom,
                      width: 350,
                      height: 320,
                      arrowHeight: 15,
                      arrowWidth: 30,
                    );
                  },
                  padding: EdgeInsets.zero,
                  splashRadius: 15,
                  icon: filtreProcessus.isEmpty
                      ? const Icon(Icons.filter_alt_off_rounded,
                          color: Colors.grey)
                      : const Icon(Icons.filter_alt_outlined,
                          color: Colors.amber))
            ],
          );
        }),
      ),
    );
  }

  Widget popoverWidget(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
              child: Container(
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CheckBoxWidget(processus: 'Agricole'),
                      CheckBoxWidget(processus: 'Finances'),
                      CheckBoxWidget(processus: 'DD'),
                      CheckBoxWidget(processus: 'Juridique'),
                      CheckBoxWidget(processus: 'Achats'),
                      CheckBoxWidget(processus: 'RH')
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CheckBoxWidget(processus: 'Gestion Stock / Logistique'),
                      CheckBoxWidget(processus: 'Emissions'),
                      CheckBoxWidget(processus: 'Usine'),
                      CheckBoxWidget(processus: 'Médecin'),
                      CheckBoxWidget(processus: 'Infrastructures'),
                    ],
                  ),
                )
              ],
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                  style:
                      OutlinedButton.styleFrom(foregroundColor: Colors.black),
                  onPressed: () {
                    dropDownController.effacerFiltreProcessus();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Effacer")),
              OutlinedButton(
                  style:
                      OutlinedButton.styleFrom(foregroundColor: Colors.green),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Appliquer")),
            ],
          )
        ],
      ),
    );
  }
}

class CheckBoxWidget extends StatefulWidget {
  final String processus;
  const CheckBoxWidget({super.key, required this.processus});

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  final DropDownController dropDownController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filtreProcessus = dropDownController.filtreProcessus;
      return Container(
        height: 40,
        width: double.infinity,
        margin: const EdgeInsets.all(2),
        child: Row(
          children: [
            Checkbox(
                checkColor: Colors.green,
                value: filtreProcessus.contains(widget.processus),
                onChanged: (value) {
                  dropDownController.addRemoveProcessus(
                      widget.processus, value!);
                }),
            const SizedBox(
              width: 10,
            ),
            Flexible(
                child: CustomText(
              text: widget.processus,
              fontStyle: FontStyle.italic,
            ))
          ],
        ),
      );
    });
  }
}
