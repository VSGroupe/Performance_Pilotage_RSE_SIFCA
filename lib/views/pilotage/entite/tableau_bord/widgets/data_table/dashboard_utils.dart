import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/utils/i18n.dart';
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
            value == null
                ? tr.enterIndicatorValueMessage
                : tr.deleteIndicatorData,
            style: TextStyle(
                color: value == null
                    ? Colors.blue
                    : Color.fromARGB(255, 175, 150, 76)),
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
            value == null ? tr.enterTargetOf : tr.updateIndicatorValueMessage,
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
  bool deleting = false;
  bool deleteConfirmed = false;
  int countdown = 5;
  Timer? timer;
  int resultEdition = 0;
  int resultDelete = 0;

  @override
  void dispose() {
    valueController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void startDeleteCountdown(BuildContext context) {
    setState(() {
      deleting = true;
      deleteConfirmed = false;
      countdown = 6;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
      });

      if (countdown == 0) {
        timer.cancel();
        executeDelete(context);
      }
    });
  }

  num? AplusB(num? A, num? B) {
    if (A != null && B != null) {
      return A + B;
    } else if (A == null && B != null) {
      return B;
    } else if (A != null && B == null) {
      return A;
    } else {
      return null;
    }
  }

  num? AmoinsB(num? A, num? B) {
    if (A != null && B != null) {
      return A - B;
    } else {
      return null;
    }
  }

  bool AVGcontrolDenominateurValue(num value, int month, int ligne) {
    Map<int, List<int>> purcentIndicatorsKeys = {
      4: [2],
      6: [49],
      11: [3],
      18: [17],
      45: [3],
      26: [13],
      30: [6],
      32: [30],
      35: [11],
      37: [10],
      39: [13],
      41: [13],
      43: [11],
      47: [49],
      109: [54],
      110: [53],
      121: [49, 54],
      123: [53],
      128: [127],
      132: [49],
      134: [49],
      140: [49],
      142: [143],
      145: [54],
      146: [53],
      147: [49],
      150: [151],
      82: [49],
      187: [49],
      191: [190],
      209: [13],
      211: [13],
      214: [49],
      240: [11],
      243: [220],
      259: [11],
      263: [11],
      282: [46],
      284: [218],
      219: [286],
      281: [288],
      137: [58, 59],
      63: [64, 58, 59],
      64: [63, 58, 59]
    }; // cas particuliers : 137 / (58 + 59) et (63 + 64) / (58 + 59)
    var dataListIndicator = tableauBordController.dataIndicateur.value.valeurs;
    bool checkResult = purcentIndicatorsKeys.containsKey(ligne);

    if (checkResult) {
      if (ligne != 137 && ligne != 63) {
        List<int> listTemp = purcentIndicatorsKeys[ligne]!;
        for (int index in listTemp) {
          num? denominateur = dataListIndicator[index - 1][month];
          if (denominateur != null) {
            if (denominateur < value) {
              return false;
            }
            if (denominateur > value &&
                listTemp.indexOf(index) == listTemp.length - 1) {
              return true;
            }
          }
        }
      } else if (ligne == 137) {
        List<int> listTemp = purcentIndicatorsKeys[ligne]!;
        num? denominateurItemA = dataListIndicator[listTemp[0] - 1][month];
        num? denominateurItemB = dataListIndicator[listTemp[1] - 1][month];
        num? denominateur = AplusB(denominateurItemA, denominateurItemB);
        if (denominateur != null) {
          if (denominateur < value) {
            return false;
          }
        } else {
          return true;
        }
      } else if (ligne == 64 || ligne == 63) {
        List<int> listTemp = purcentIndicatorsKeys[ligne]!;
        num? numerateurItemA = dataListIndicator[63][month]; // L64
        num? numerateurItemB = dataListIndicator[62][month]; // L63
        num? numerateur = AplusB(numerateurItemA, numerateurItemB);
        num? denominateurItemA = dataListIndicator[listTemp[1] - 1][month];
        num? denominateurItemB = dataListIndicator[listTemp[2] - 1][month];
        num? denominateur = AplusB(denominateurItemA, denominateurItemB);
        if (denominateurItemA == null || denominateurItemB == null) {
          return true;
        } else if (denominateur != null && numerateur != null) {
          if (denominateur < numerateur) {
            return false;
          } else {
            return true;
          }
        }
      }
    }
    return true;
  }

  bool AVGcontrolNumerateurValue(num value, int month, int ligne) {
    Map<int, List<int>> purcentIndicatorsKeys = {
      2: [4],
      17: [18],
      3: [11, 45],
      6: [30],
      30: [32],
      11: [35, 43, 240, 259, 263],
      10: [37],
      13: [26, 39, 41, 209, 211],
      49: [6, 47, 121, 132, 140, 147, 134, 82, 187, 214],
      53: [110, 123, 146],
      54: [109, 121, 145],
      127: [128],
      143: [142],
      151: [150],
      190: [191],
      220: [243],
      46: [282],
      218: [284],
      286: [219],
      288: [281],
      58: [59, 137, 63, 64],
      59: [58, 137, 63, 64],
    }; // cas particuliers : 58/59
    var dataListIndicator = tableauBordController.dataIndicateur.value.valeurs;
    bool checkResult = purcentIndicatorsKeys.containsKey(ligne);

    if (checkResult) {
      if (ligne != 58 && ligne != 59) {
        List<int> listTemp = purcentIndicatorsKeys[ligne]!;
        for (int index in listTemp) {
          num? numerateur = dataListIndicator[index - 1][month];
          if (numerateur != null) {
            if (numerateur > value) {
              return false;
            }
            if (numerateur < value &&
                listTemp.indexOf(index) == listTemp.length - 1) {
              return true;
            }
          }
        }
      } else if (ligne == 58 || ligne == 59) {
        // cas numerateur L137
        List<int> listTemp = purcentIndicatorsKeys[ligne]!;
        num? numerateur = dataListIndicator[listTemp[1] - 1][month];
        num? denominateurItem = dataListIndicator[listTemp[0] - 1][month];
        num? denominateur = AplusB(value, denominateurItem);
        // print("denominateurItem = $denominateurItem");
        // print("denominateur = $denominateur");
        // cas numerateurs L63 + L64
        num? numerateurA = dataListIndicator[listTemp[2] - 1][month];
        num? numerateurB = dataListIndicator[listTemp[3] - 1][month];
        num? numerateurAB = AplusB(numerateurA, numerateurB);
        // print("L137 = $numerateur");
        // print("L64 + L63 = $numerateurAB");
        if (numerateur != null && denominateur != null) {
          if (numerateur > denominateur) {
            //print("numerateur > denominateur : ${numerateur > denominateur}");
            return false;
          }
        } else if (numerateurAB != null && denominateur != null) {
          if (numerateurAB > denominateur) {
            //print("numerateurAB > denominateur : ${numerateurAB > denominateur}");
            return false;
          }
        }
      }
    }
    return true;
  }

  bool SUBcontrolValue(num value, int month, int ligne) {
    Map<int, int> SubIndicatorsKeys = {
      56: 61,
      57: 62,
      58: 63,
      59: 64,
      70: 74,
      71: 75, //
      72: 76, //
      82: 87, //
      83: 88, //
      84: 89, //
      121: 123, //
      130: 131, //
      249: 253,
      61: 56,
      62: 57,
      63: 58,
      64: 59,
      74: 70,
      75: 71,
      76: 72,
      87: 82,
      88: 83,
      89: 84,
      123: 121,
      131: 130,
      253: 249
    };
    List<int> particularKeyList = [
      61,
      62,
      63,
      64,
      74,
      75,
      76,
      87,
      88,
      89,
      123,
      131,
      253
    ];
    var dataListIndicator = tableauBordController.dataIndicateur.value.valeurs;
    bool checkResult = SubIndicatorsKeys.containsKey(ligne);

    if (checkResult) {
      if (!particularKeyList.contains(ligne)) {
        int key = SubIndicatorsKeys[ligne]!;
        num? indicatorData = dataListIndicator[key - 1][month];
        num? subResult = AmoinsB(value, indicatorData);
        if (subResult == null) {
          return true;
        } else if (subResult < 0) {
          return false;
        }
      } else if (particularKeyList.contains(ligne)) {
        int key = SubIndicatorsKeys[ligne]!;
        num? indicatorData = dataListIndicator[key - 1][month];
        num? subResult = AmoinsB(value, indicatorData);
        //print(subResult);
        if (subResult == null) {
          return true;
        } else if (subResult > 0) {
          return false;
        }
      }
    }
    return true;
  }

  void cancelDelete() {
    setState(() {
      deleting = false;
      deleteConfirmed = true;
    });
    timer?.cancel();
  }

  Future<void> executeDelete(BuildContext context) async {
    var result = await tableauBordController.supprimerIndicateurMois(
      numeroLigne: widget.indicator.numero - 1,
      colonne: widget.colonne,
      type: widget.indicator.type,
      formule: widget.indicator.formule ?? "",
    );

    if (result == true) {
      await tableauBordController.updateDataIndicateur();
      var message = tr.successDeletedDataMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        showSnackBar(tr.success, message, Colors.green),
      );
      tableauBordController.updateSuiviDate(
        tableauBordController.currentYear.value,
        widget.indicator.processus,
        widget.indicator.numero - 1,
        widget.colonne,
      );
    } else {
      var message = tr.failDeletedDataMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        showSnackBar(tr.fail, message, Colors.red),
      );
      setState(() {
        resultDelete = -1; // Failure
      });
    }
    setState(() {
      deleting = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showMyDialog(BuildContext context, int counter) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tr.countdownMessageTitle,
                  style: const TextStyle(
                    color: Color(0xFFFFC000),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              children: [
                Text("${tr.deletionIn} $counter ${tr.seconds}..."),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  cancelDelete();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(tr.cancel),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    updating = false;
    valueController.text = widget.value != null ? "${widget.value}" : "";
    resultEdition = 0;
    resultDelete = 0;
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
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.dangerous,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(tr.editionFailed)
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

  Widget deleteResultUI() {
    if (deleting == true) {
      return const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.blue,
        )),
      );
    } else {
      switch (resultDelete) {
        case 0:
          return Container();
        case -1:
          return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.dangerous,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(tr.deletionFailed)
              ],
            ),
          );
        case 1:
          return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(tr.successDeletedDataMessage)
              ],
            ),
          );
        default:
          return Container();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: updating ? 250 : 200,
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
              validator: (val) {
                if (!GetUtils.isNum(val!)) {
                  return tr.dataEntryError;
                }
                num value = num.parse(val);
                if (value < 0) {
                  return tr.negativeData;
                }
                bool checkAVGdenominateur = AVGcontrolDenominateurValue(
                    value, widget.colonne, widget.numeroLigne + 1);
                bool checkAVGnumerateur = AVGcontrolNumerateurValue(
                    value, widget.colonne, widget.numeroLigne + 1);
                bool checkSubDatas = SUBcontrolValue(
                    value, widget.colonne, widget.numeroLigne + 1);
                if (checkAVGdenominateur &&
                    checkAVGnumerateur &&
                    checkSubDatas) {
                  return null;
                } else {
                  return tr.erroneousCalculation;
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          resultUI(),
          Expanded(child: deleteResultUI()),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.value !=
                  null) // Only show the delete button if there is a value
                ElevatedButton(
                  onPressed: deleting == true
                      ? null
                      : () async {
                          startDeleteCountdown(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(tr.delete),
                ),
              TextButton(
                child: Text(tr.cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
              deleting
                  ? Text('${tr.deletionIn} $countdown...')
                  : const SizedBox(),
              widget.value == null
                  ? ElevatedButton(
                      onPressed: updating == true
                          ? null
                          : () async {
                              if (_keyForm.currentState!.validate()) {
                                setState(() {
                                  updating = true;
                                });
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                num valeur = num.parse(valueController.text);
                                var result = await tableauBordController
                                    .renseignerIndicateurMois(
                                        valeur: valeur,
                                        numeroLigne:
                                            widget.indicator.numero - 1,
                                        colonne: widget.colonne,
                                        type: widget.indicator.type,
                                        formule:
                                            widget.indicator.formule ?? "");

                                if (result == true) {
                                  await tableauBordController
                                      .updateDataIndicateur();
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  var message = tr.successUpdatingData;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      showSnackBar(
                                          tr.success, message, Colors.green));
                                  //print("hello");
                                  tableauBordController.updateSuiviDate(
                                      tableauBordController.currentYear.value,
                                      widget.indicator.processus,
                                      widget.indicator.numero - 1,
                                      widget.colonne);
                                } else {
                                  var message = tr.failUpdatingData;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      showSnackBar(
                                          tr.fail, message, Colors.red));
                                }
                                await Future.delayed(
                                    const Duration(milliseconds: 500));
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              }
                            },
                      child: Text(tr.confirm))
                  : const SizedBox(),
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
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.dangerous,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(tr.editionFailed)
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
                  GetUtils.isNum("$val") ? null : tr.dataEntryError,
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
                child: Text(tr.cancel),
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
                  child: Text(tr.confirm))
            ],
          )
        ],
      ),
    );
  }
}
