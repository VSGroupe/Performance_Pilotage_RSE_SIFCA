import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../models/pilotage/indicateur_model.dart';
import '../../../../controllers/drop_down_controller.dart';
import '/views/pilotage/controllers/tableau_controller.dart';
import 'row_enjeu.dart';
import 'row_indicateur.dart';

class RowAxe extends StatefulWidget {
  final String idAxe;
  final String title;
  final Color color;
  final String? imagePath;
  final List<IndicateurModel> indicateurs;
  const RowAxe(
      {Key? key,
      required this.title,
      required this.color,
      required this.idAxe,
      this.imagePath,
      required this.indicateurs})
      : super(key: key);

  @override
  State<RowAxe> createState() => _RowAxeState();
}

class _RowAxeState extends State<RowAxe> {
  final TableauBordController tableauBordController = Get.find();
  final DropDownController dropDownController = Get.find();

  @override
  Widget build(BuildContext context) {
    final indicateurs = widget.indicateurs
        .where((indicateur) => indicateur.axe == widget.idAxe)
        .toList();
    return Obx(() {
      bool isVisibleEnjeu =
          dropDownController.jsonDropDown[widget.idAxe] ?? false;
      bool isFiltrePilier =
          dropDownController.filtreViewAxe[widget.idAxe] ?? false;
      return Visibility(
        visible: isFiltrePilier,
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: true,
                child: Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: widget.color, width: 2.0),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 4, bottom: 4, right: 14, left: 20),
                    child: Row(
                      children: [
                        widget.imagePath != null
                            ? Image.asset(
                                "${widget.imagePath}",
                                width: 25,
                                height: 25,
                              )
                            : Icon(
                                Icons.ac_unit_sharp,
                                color: widget.color,
                                size: 24,
                              ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          widget.title,
                          style: TextStyle(
                              color: widget.color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: Container()),
                        RotatedBox(
                          quarterTurns: isVisibleEnjeu ? 1 : 3,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_sharp,
                              color: Colors.black,
                            ),
                            splashRadius: 20,
                            onPressed: () {
                              dropDownController.updateJson(
                                  widget.idAxe, !isVisibleEnjeu);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isVisibleEnjeu,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getPilierSubWidget(widget.idAxe, indicateurs)),
              )
            ],
          ),
        ),
      );
    });
  }

  List<Widget> getPilierSubWidget(
      String idPilier, List<IndicateurModel> indicateursList) {
    switch (idPilier) {
      case "axe_1":
        return [
          const SizedBox(
            height: 1,
          ),
 RowEnjeu(
              numero: "1a",
              idPilier: widget.idAxe,
              idEnjeu: "enjeu_1a",
              enjeuTitle: "Gouvernance DD et stratégie",
              color: widget.color,
              indicateurs: indicateursList),
          const SizedBox(
            height: 1,
          ),
          RowEnjeu(
              numero: "1b",
              idPilier: widget.idAxe,
              idEnjeu: "enjeu_1b",
              enjeuTitle: "Pilotage DD",
              color: widget.color,
              indicateurs: indicateursList),
          const SizedBox(
            height: 1,
          ),
          RowEnjeu(
              numero: "2",
              idPilier: widget.idAxe,
              idEnjeu: "enjeu_2",
              enjeuTitle: "Éthique des affaires et achats responsables",
              color: widget.color,
              indicateurs: indicateursList),
          const SizedBox(
            height: 1,
          ),
          RowEnjeu(
              numero: "3",
              idPilier: widget.idAxe,
              idEnjeu: "enjeu_3",
              enjeuTitle:
                  "Intégration des attentes DD des clients et consommateurs",
              color: widget.color,
              indicateurs: indicateursList),
          const SizedBox(
            height: 1,
          ),
        ];
      case "axe_2":
        return [
          const SizedBox(
            height: 1,
          ),
          RowEnjeu(
              numero: "4",
              idPilier: widget.idAxe,
              idEnjeu: "enjeu_4",
              enjeuTitle: "Égalité de traitement",
              color: widget.color,
              indicateurs: indicateursList),
          const SizedBox(
            height: 1,
          ),
          RowEnjeu(
              numero: "5",
              idPilier: widget.idAxe,
              idEnjeu: "enjeu_5",
              enjeuTitle: "Conditions de travail",
              color: widget.color,
              indicateurs: indicateursList),
          const SizedBox(
            height: 1,
          ),
          RowEnjeu(
              numero: "6",
              idPilier: widget.idAxe,
              idEnjeu: "enjeu_6",
              enjeuTitle: "Amélioration du cadre de vie",
              color: widget.color,
              indicateurs: indicateursList),
          const SizedBox(
            height: 1,
          ),
        ];
      case "axe_3":
        return [
          const SizedBox(
            height: 1,
          ),
          RowEnjeu(
              numero: "7",
              idPilier: widget.idAxe,
              idEnjeu: "enjeu_7",
              enjeuTitle: "Inclusion sociale ét dévéloppement des communautés",
              color: widget.color,
              indicateurs: indicateursList),
          const SizedBox(
            height: 1,
          ),
        ];
      case "axe_4":
        return [
          const SizedBox(
            height: 1,
          ),
          RowEnjeu(
              numero: "8",
              idPilier: widget.idAxe,
              idEnjeu: "enjeu_8",
              enjeuTitle: "Changement climatique et déforestation",
              color: widget.color,
              indicateurs: indicateursList),
          const SizedBox(
            height: 1,
          ),
          RowEnjeu(
              numero: "9",
              idPilier: widget.idAxe,
              idEnjeu: "enjeu_9",
              enjeuTitle: "Gestion et traitement de l’eau",
              color: widget.color,
              indicateurs: indicateursList),
          const SizedBox(
            height: 1,
          ),
          RowEnjeu(
              numero: "10",
              idPilier: widget.idAxe,
              idEnjeu: "enjeu_10",
              enjeuTitle: "Gestion des ressources et déchets",

              color: widget.color,
              indicateurs: indicateursList),
          const SizedBox(
            height: 1,
          ),
        ];
      default:
        return [
          const Text(""),
        ];
    }
  }
}

class RowAxeGeneral extends StatefulWidget {
  final String idAxe;
  final String title;
  final Color color;
  final String? imagePath;
  final List<IndicateurModel> indicateurs;
  const RowAxeGeneral(
      {Key? key,
      required this.title,
      required this.color,
      required this.idAxe,
      this.imagePath,
      required this.indicateurs})
      : super(key: key);

  @override
  State<RowAxeGeneral> createState() => _RowAxeGeneralState();
}

class _RowAxeGeneralState extends State<RowAxeGeneral> {
  final DropDownController dropDownController = Get.find();
  final TableauBordController tableauBordController = Get.find();

  @override
  Widget build(BuildContext context) {
    final indicateurs =
        widget.indicateurs.where((indicateur) => indicateur.enjeu == "enjeu_0");
    return Obx(() {
      bool isVisibleGeneral =
          dropDownController.jsonDropDown[widget.idAxe]??false;
      bool isFiltrePilier =
          dropDownController.filtreViewAxe[widget.idAxe] ?? false;
      return Visibility(
        visible: isFiltrePilier,
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: true,
                child: Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: widget.color, width: 2.0),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 4, bottom: 4, right: 14, left: 20),
                    child: Row(
                      children: [
                        widget.imagePath != null
                            ? Image.asset(
                                "${widget.imagePath}",
                                width: 25,
                                height: 25,
                              )
                            : Icon(
                                Icons.ac_unit_sharp,
                                color: widget.color,
                                size: 24,
                              ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          widget.title,
                          style: TextStyle(
                              color: widget.color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: Container()),
                        RotatedBox(
                          quarterTurns: isVisibleGeneral ? 1 : 3,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_sharp,
                              color: Colors.black,
                            ),
                            splashRadius: 20,
                            onPressed: () {
                              dropDownController.updateJson(
                                  widget.idAxe, !isVisibleGeneral);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: isVisibleGeneral,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: indicateurs.map((indicateur) {
                        return RowIndicateur(indicateur: indicateur);
                      }).toList())),
            ],
          ),
        ),
      );
    });
  }

  List<dynamic> getValeurs() {
    return [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ];
  }

  List<dynamic> getValidation() {
    return [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ];
  }
}
