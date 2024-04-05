import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../helper/helper_methods.dart';
import '../../../../../../models/pilotage/indicateur_model.dart';
import '../../../../controllers/tableau_controller.dart';

class DashBoardUtils {
  static bool editDataRow(BuildContext context, IndicateurModel indicator,
      num? value, int colonne, int numeroLigne) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "${value == null ? "Renseigner la donnée de" : "Mettre à jour la donnée de"} l'indicateur",
            style: TextStyle(color: value == null ? Colors.blue : Colors.green),
          ),
          contentPadding: const EdgeInsets.all(30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          titleTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis),
          content: ContentEdition(
              indicator: indicator,
              value: value,
              colonne: colonne,
              numeroLigne: numeroLigne),
        );
      },
    );
    return true;
  }

  static bool editDataCible(BuildContext context, IndicateurModel indicator,
      num? value, int numeroLigne, int colonne) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "${value == null ? "Renseigner la cible de" : "Mettre à jour la donnée de"} l'indicateur",
            style: TextStyle(color: value == null ? Colors.blue : Colors.green),
          ),
          contentPadding: const EdgeInsets.all(30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          titleTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis),
          content: ContentEditionCible(
              indicator: indicator,
              value: value,
              numeroLigne: numeroLigne,
              colonne: colonne),
        );
      },
    );
    return true;
  }
}

class ContentEdition extends StatefulWidget {
  final IndicateurModel indicator;
  final num? value;
  final int colonne;
  final int numeroLigne;
  const ContentEdition(
      {Key? key,
      this.value,
      required this.indicator,
      required this.colonne,
      required this.numeroLigne})
      : super(key: key);

  @override
  State<ContentEdition> createState() => _ContentEditionState();
}

class _ContentEditionState extends State<ContentEdition> {
  final _keyForm = GlobalKey<FormState>();
  final TextEditingController valueController = TextEditingController();
  final TableauBordController tableauBordController = Get.find();
  late bool updating;
  int resultEdition = 0;

  @override
  void initState() {
    updating = false;
    valueController.text = widget.value != null ? "${widget.value}" : "";
    resultEdition = 0;
    super.initState();
  }

  Widget resultUI() {
    if (updating == true) {
      return const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.blue,
        )),
      );
    } else {
      switch (resultEdition) {
        case 0:
          return Container();
        case -1:
          return const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dangerous,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Echec lors de l'édition")
              ],
            ),
          );
        case 1:
          return Container();
        default:
          return Container();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: updating ? 200 : 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 350,
            child: Text(
              "${widget.indicator.intitule} (${widget.indicator.unite})",
              style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _keyForm,
            child: TextFormField(
              controller: valueController,
              validator: (val) =>
                  GetUtils.isNum("$val") ? null : "Erreur de saisie",
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          resultUI(),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text('Annuler'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                  onPressed: updating == true
                      ? null
                      : () async {
                          if (_keyForm.currentState!.validate()) {
                            setState(() {
                              updating = true;
                            });
                            await Future.delayed(const Duration(seconds: 1));
                            num valeur = num.parse(valueController.text);
                            var result = await tableauBordController
                                .renseignerIndicateurMois(
                                    valeur: valeur,
                                    numeroLigne: widget.indicator.numero - 1,
                                    colonne: widget.colonne,
                                    type: widget.indicator.type,
                                    formule: widget.indicator.formule ?? "");

                            if (result == true) {
                              await tableauBordController
                                  .updateDataIndicateur();
                              await Future.delayed(const Duration(seconds: 1));
                              var message =
                                  "La donnée a été modifiée avec succès.";
                              ScaffoldMessenger.of(context).showSnackBar(
                                  showSnackBar(
                                      "Succès", message, Colors.green));
                              tableauBordController.updateSuiviDate(
                                  tableauBordController.currentYear.value, widget.indicator.processus, widget.indicator.numero - 1, widget.colonne);
                            } else {
                              var message =
                                  "La donnée n'a pas été mise à jour.";
                              ScaffoldMessenger.of(context).showSnackBar(
                                  showSnackBar("Echec", message, Colors.red));
                            }
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            Navigator.of(context).pop();
                          }
                        },
                  child: const Text('Valider'))
            ],
          )
        ],
      ),
    );
  }

  String getIdDoc(String idIndicateur, String entityAbr, String annee) {
    final id = "${entityAbr}_${annee}_$idIndicateur";
    return id;
  }
}

class ContentEditionCible extends StatefulWidget {
  final IndicateurModel indicator;
  final num? value;
  final int numeroLigne;
  final int colonne;
  const ContentEditionCible(
      {Key? key,
      this.value,
      required this.indicator,
      required this.numeroLigne,
      required this.colonne})
      : super(key: key);

  @override
  State<ContentEditionCible> createState() => _ContentEditionCible();
}

class _ContentEditionCible extends State<ContentEditionCible> {
  final _keyform = GlobalKey<FormState>();
  final TextEditingController valueController = TextEditingController();
  final TableauBordController tableauBordController = Get.find();
  late bool updating;
  int resultEdition = 0;

  @override
  void initState() {
    updating = false;
    valueController.text = widget.value != null ? "${widget.value}" : "";
    resultEdition = 0;
    super.initState();
  }

  Widget resultUI() {
    if (updating == true) {
      return const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.blue,
        )),
      );
    } else {
      switch (resultEdition) {
        case 0:
          return Container();
        case -1:
          return const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dangerous,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Echec lors de l'édition")
              ],
            ),
          );
        case 1:
          return Container();
        default:
          return Container();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: updating ? 200 : 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 350,
            child: Text(
              "${widget.indicator.intitule} (${widget.indicator.unite})",
              style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _keyform,
            child: TextFormField(
              controller: valueController,
              validator: (val) =>
                  GetUtils.isNum("$val") ? null : "Erreur de saisie",
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          resultUI(),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text('Annuler'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                  onPressed: updating == true
                      ? null
                      : () async {
                          if (_keyform.currentState!.validate()) {
                            setState(() {
                              updating = true;
                            });
                            await Future.delayed(const Duration(seconds: 1));
                            num valeur = num.parse(valueController.text);
                            // var result =
                            //     await tableauBordController.renseignerDataCible(
                            //         dataCible: valeur,
                            //         numeroLigne: widget.indicator.numero - 1,
                            //         colonne: widget.colonne, type: widget.indicator.type,
                            //         formule: widget.indicator.formule ?? "");

                            // if (result == true) {
                            //   await tableauBordController
                            //       .updateDataIndicateur();
                            //   await Future.delayed(const Duration(seconds: 1));
                            //   var message =
                            //       "La Cible a été modifiée avec succès.";
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //       showSnackBar(
                            //           "Succès", message, Colors.green));
                            // } else {
                            //   var message = "La Cible n'a pas été mise à jour.";
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //       showSnackBar("Echec", message, Colors.red));
                            // }
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            Navigator.of(context).pop();
                          }
                        },
                  child: const Text('Valider'))
            ],
          )
        ],
      ),
    );
  }
}
