import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:perf_rse/views/pilotage/controllers/entite_pilotage_controler.dart';
import 'package:perf_rse/views/pilotage/controllers/profil_pilotage_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../helper/helper_methods.dart';
import '../../../../../../models/pilotage/indicateur_model.dart';
import '../../../../controllers/side_menu_controller.dart';
import '../../../../controllers/tableau_controller.dart';
import 'dashboard_utils.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RowIndicateur extends StatefulWidget {
  final IndicateurModel indicateur;
  const RowIndicateur({Key? key, required this.indicateur}) : super(key: key);

  @override
  State<RowIndicateur> createState() => _RowIndicateurState();
}

class _RowIndicateurState extends State<RowIndicateur> {
  late ToggleSwitch _toggleButons;
  bool isHovering = false;
  final SideMenuController sideMenuController = Get.find();
  final TableauBordController tableauBordController = Get.find();
  final ProfilPilotageController profilPilotageController = Get.find();
  final EntitePilotageController entitePilotageController = Get.find();

  bool isValidatingMonth = false;
  bool isValidatingRealise = false;
  var valideState = false;
  final storage = const FlutterSecureStorage();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _buildToggleButtons();
  }

  @override
  Widget build(BuildContext context) {
    final accesAdmin = checkAccesAdmin();
    final edition = checkAccesEdition();
    final statusIndic = tableauBordController
        .dataIndicateur.value.statusEntity[widget.indicateur.numero - 1];
    final estContributeur = !accesAdmin && edition && !statusIndic;
    return InkWell(
      onTap: () {},
      onHover: (value) {
        setState(() {
          isHovering = value;
        });
      },
      child: Material(
        elevation: isHovering ? 10 : 0,
        child: Container(
          padding: const EdgeInsets.only(left: 2.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: isHovering ? Colors.black : Colors.grey[300]!,
                width: isHovering ? 1.0 : 0.5),
            color: widget.indicateur.type == "Calculé"
                ? const Color(0xFFFDDDCC)
                : widget.indicateur.type == "Test"
                    ? const Color(0xFFB3B9C0)
                    : tableauBordController.dataIndicateur.value
                                .statusEntity[widget.indicateur.numero - 1] ==
                            false
                        ? Colors.orange
                        : Colors.transparent,
          ),
          height: 40,
          child: Row(children: [
            // Réf
            Container(
              height: 40,
              width: 120,
              alignment: Alignment.centerLeft,
              color: Colors.transparent,
              child: Row(
                children: [
                  if (isHovering)
                    const Icon(
                      Icons.mouse,
                      size: 12,
                    ),
                  if (isHovering)
                    const SizedBox(
                      width: 2,
                    ),
                  Text(
                    "#${widget.indicateur.reference}", //${widget.indicateur.numero} 
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            // Intitule
            Expanded(
              child: Container(
                height: 40,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.indicateur.intitule,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Processus
            Container(
              height: 40,
              width: 130,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: Text(widget.indicateur.processus ?? "",
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 12)),
            ),
            //Realise Annee passee
            Container(
              height: 40,
              width: 140,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: buildRealisePastYearColumn(),
            ),
            // Réalise Annuel
            Container(
              height: 40,
              width: 150,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: buildRealiseAnColumn(),
            ),
            // Réalise Mois
            Container(
              height: 40,
              width: 170,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: estContributeur
                  ? const Text("verrouille",
                      style: TextStyle(color: Colors.black))
                  : buildRealiseMoisColumn(context),
            ),
            //cible
            // Container(
            //   height: 40,
            //   width: 130,
            //   color: Colors.transparent,
            //   alignment: Alignment.centerLeft,
            //   child: builCibleColumn(context),
            // ),
//ecart
accesAdmin
  ? Container(
      height: 40,
      width: 100,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: buildEcartsColumn(),
    )
  : SizedBox(), // Affichez un conteneur vide si accessAdmin est faux

//actif/inactif
accesAdmin
  ? Container(
      height: 40,
      width: 100,
      color: Colors.transparent,
      alignment: Alignment.centerLeft,
      child: _toggleButons, // Affichez _toggleButtons si accessAdmin est vrai
    )
  : SizedBox(), // Affichez un conteneur vide si accessAdmin est faux
          ]),
        ),
      ),
    );
  }

  void _buildToggleButtons() {
    int numeroLigne = widget.indicateur.numero - 1;
    var valIndex = getValeurStatusEntity(numeroLigne);
    _toggleButons = ToggleSwitch(
      cornerRadius: 90.0,
      initialLabelIndex: valIndex,
      inactiveBgColor: Colors.grey,
      activeFgColor: Colors.white,
      activeBgColors: [
        [Colors.red[800]!],
        [Colors.green[800]!]
      ],
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      minHeight: 15,
      minWidth: 15,
      radiusStyle: true,
      onToggle: (index) {
        print('switched to: $index');
      },
      cancelToggle: (index) async {
        String selection = index == 0 ? 'desactiver' : 'activer';
        return await showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            content: Text("Voulez vous $selection l'indicateur ?"),
            actions: [
              TextButton(
                child: const Text(
                  "Non",
                  style: TextStyle(color: Color.fromARGB(255, 114, 244, 54)),
                ),
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
              ),
              TextButton(
                child: const Text(
                  "Oui",
                  style: TextStyle(color: Color.fromARGB(255, 232, 142, 31)),
                ),
                onPressed: () async {
                  var result = await changeStatusEntityIndic(
                      index, widget.indicateur.numero - 1);
                  if (result == true) {
                    await tableauBordController.updateDataIndicateur();
                    await Future.delayed(const Duration(seconds: 1));
                    var message = "Action effectuée";
                    ScaffoldMessenger.of(context).showSnackBar(
                        showSnackBar("Succès", message, Colors.green));
                  } else {
                    var message = "Traitement non effectué";
                    ScaffoldMessenger.of(context).showSnackBar(
                        showSnackBar("Echec", message, Colors.red));
                  }
                  await Future.delayed(const Duration(milliseconds: 500));
                  Navigator.pop(dialogContext, false);
                  //Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildRealiseAnColumn() {
    return Obx(() {
      int numeroLigne = widget.indicateur.numero - 1;

      var valeur = getValeur(numeroLigne, 0);
      var valide = getValidation(numeroLigne, 0);

      if (widget.indicateur.unite == "%" && valeur != null) {
        valeur = valeur * 100;
      }

      return widget.indicateur.type == "Test"
          ? Row(
              children: [
                Container(
                  height: 40,
                  width: 110,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        "${formatNumber(valeur) ?? "---"} ",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Row(
              children: [
                Container(
                  height: 40,
                  width: 110,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        "${formatNumber(valeur) ?? "---"} ",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "(${widget.indicateur.unite ?? ""})",
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 12),
                      )
                    ],
                  ),
                ),
                isValidatingRealise
                    ? loadingValidation()
                    : Checkbox(
                        value: valide ?? false,
                        splashRadius: 15,
                        checkColor:
                            valide == true ? Colors.white : Colors.transparent,
                        side: MaterialStateBorderSide.resolveWith(
                          (states) {
                            var validated = valide;
                            return BorderSide(
                                width: 2.0,
                                color: validated == true
                                    ? Colors.green
                                    : valeur != null
                                        ? Colors.amber
                                        : Colors.grey);
                          },
                        ),
                        fillColor: MaterialStateProperty.resolveWith((states) =>
                            valide == true ? Colors.green : Colors.transparent),
                        onChanged: (valeur == null)
                            ? null
                            : (value) async {
                                final acces = await checkAccesValidation();
                                if (acces) {
                                  var validation = value;
                                  if (validation == true) {
                                    await validerIndicateur(
                                        validation!,
                                        valeur,
                                        widget.indicateur.numero - 1,
                                        0,
                                        widget.indicateur.reference);
                                    tableauBordController.consolidation(
                                        tableauBordController
                                            .currentYear.value);
                                    setState(() {
                                      isValidatingRealise = true;
                                    });
                                  }
                                  if (validation == false) {
                                    await annulerValidationIndic(
                                        validation!,
                                        widget.indicateur.numero - 1,
                                        0,
                                        widget.indicateur.reference);
                                    tableauBordController.consolidation(
                                        tableauBordController
                                            .currentYear.value);
                                    await tableauBordController
                                        .updateDataIndicateur();
                                    setState(() {
                                      isValidatingRealise = true;
                                      valide = false;
                                      valideState = true;
                                    });
                                  }
                                } else {
                                  _showMyDialog(
                                      "Vous n'avez pas dorit a cette action");
                                }
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                setState(() {
                                  isValidatingRealise = false;
                                });
                              }),
                const SizedBox(
                  width: 3,
                ),
                Container(
                  height: 35,
                  color: Colors.grey,
                  width: 2,
                )
              ],
            );
    });
  }

  Widget buildRealisePastYearColumn() {
    return Obx(() {
      int numeroLigne = widget.indicateur.numero - 1;

      var valeur = getValeurPastYear(numeroLigne, 0);

      if (widget.indicateur.unite == "%" && valeur != null) {
        valeur = valeur * 100;
      }

      return widget.indicateur.type == "Test"
          ? Row(
              children: [
                Container(
                  height: 40,
                  width: 110,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        "${formatNumber(valeur) ?? "---"} ",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Row(children: [
              Container(
                height: 40,
                width: 110,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "${formatNumber(valeur) ?? "---"} ",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "(${widget.indicateur.unite ?? ""})",
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 12),
                    )
                  ],
                ),
              ),
                const SizedBox(
                  width: 3,
                ),
                Container(
                  height: 35,
                  color: Colors.grey,
                  width: 2,
                )
            ]);
    });
  }

  Widget buildEcartsColumn() {
    return Obx(() {
      int numeroLigne = widget.indicateur.numero - 1;

      var valeur = getValeurEcart(numeroLigne);

      return Row(
        children: [
          Container(
            height: 40,
            width: 80,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  "${valeur != null ? (valeur < 0 ? -valeur : valeur).toStringAsFixed(2) : "---"} %",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: valeur != null
                        ? valeur <= 0
                            ? Colors.green
                            : valeur <= 50
                                ? Colors.yellow
                                : Colors.red
                        : Colors.blue,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                // Container(
                //   height: 35,
                //   color: Colors.grey,
                //   width: 2,
                // )
              ],
            ),
          ),
        ],
      );
    });
  }

  String formatNumber(dynamic number) {
    if (number is int) {
      if (number >= 1e9) {
        return '${(number / 1e9)}G';
      } else if (number >= 1e6) {
        return '${(number / 1e6)}M';
      } else if (number >= 1e3) {
        return '${(number / 1e3)}K';
      } else {
        return '$number';
      }
    } else if (number is double) {
      if (number >= 1e9) {
        return '${(number / 1e9).toStringAsFixed(2)}G';
      } else if (number >= 1e6) {
        return '${(number / 1e6).toStringAsFixed(2)}M';
      } else if (number >= 1e3) {
        return '${(number / 1e3).toStringAsFixed(2)}K';
      } else if (number > 0 && number < 0.10) {
        return '${(number * 1000).toStringAsFixed(2)} e-3';
      } else {
        return number.toStringAsFixed(2);
      }
    } else {
      return '---';
    }
  }

  Future<bool> checkAccesValidation() async {
    final access = profilPilotageController.accesPilotageModel.value;
    if (access.estAdmin == true) {
      return true;
    }
    if (access.estValidateur == true) {
      return true;
    }
    return false;
  }

  bool checkAccesAdmin() {
    final access = profilPilotageController.accesPilotageModel.value;
    if (access.estAdmin == true) {
      return true;
    }
    return false;
  }

  bool checkAccesEdition() {
    final access = profilPilotageController.accesPilotageModel.value;
    if (access.estAdmin == true) {
      return true;
    }
    if (access.estEditeur == true) {
      return true;
    }
    return false;
  }

  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/forbidden.png",
                  width: 50,
                  height: 50,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildRealiseMoisColumn(BuildContext context) {
    return Obx(() {
      final estConsolide =
          entitePilotageController.getCurrentEntiteRes()["est_consolide"];
      List<Icon> icons = [
        const Icon(
          Icons.verified,
          color: Colors.green,
        ),
        const Icon(
          Icons.circle,
          color: Colors.yellow,
        ),
        const Icon(
          Icons.circle,
          color: Colors.red,
        ),
      ];
      int numeroLigne = widget.indicateur.numero - 1;
      int currentMonth = tableauBordController.currentMonth.value;

      var valideRealise = getValidation(numeroLigne, 0);

      var valeur = getValeur(numeroLigne, currentMonth);
      if (widget.indicateur.unite == "%" && valeur != null) {
        valeur = valeur * 100;
      }
      var valide = getValidation(numeroLigne, currentMonth);

      return widget.indicateur.type == "Test"
          ? Row(
              children: [
                Container(
                  height: 40,
                  width: 110,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        "${formatNumber(valeur) ?? "---"} ",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Row(
              children: [
                Container(
                    width: 64,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(formatNumber(valeur) ?? "")),
                Container(
                    width: 32,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: estConsolide
                        ? null
                        : (widget.indicateur.type == "Primaire" &&
                                valide != true &&
                                valideRealise != true)
                            ? IconButton(
                                splashRadius: 15,
                                splashColor: Colors.amber,
                                onPressed: () async {
                                  final acces = checkAccesEdition();
                                  if (acces) {
                                    renseignerLaDonnee(
                                        context,
                                        widget.indicateur,
                                        valeur,
                                        currentMonth,
                                        numeroLigne);
                                  } else {
                                    _showMyDialog(
                                        "Vous n'avez pas l'accès à éditeur.");
                                  }
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 12,
                                ))
                            : null),
                Container(
                    width: 32,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2.0, left: 2.0),
                      child: isValidatingMonth
                          ? loadingValidation()
                          : Checkbox(
                              value: valide ?? false,
                              splashRadius: 15,
                              checkColor: valide == true
                                  ? Colors.white
                                  : Colors.transparent,
                              side: MaterialStateBorderSide.resolveWith(
                                (states) {
                                  var validated = valide;
                                  return BorderSide(
                                      width: 2.0,
                                      color: validated == true
                                          ? Colors.green
                                          : valeur != null
                                              ? Colors.amber
                                              : Colors.grey);
                                },
                              ),
                              fillColor: MaterialStateProperty.resolveWith(
                                  (states) => valide == true
                                      ? Colors.green
                                      : Colors.transparent),
                              onChanged: (valeur == null ||
                                      valideRealise == true ||
                                      isValidatingMonth == true)
                                  ? null
                                  : (value) async {
                                      final acces =
                                          await checkAccesValidation();
                                      if (acces) {
                                        var validation = value;
                                        if (validation == true) {
                                          await validerIndicateur(
                                              validation!,
                                              valeur,
                                              widget.indicateur.numero - 1,
                                              currentMonth,
                                              widget.indicateur.reference);
                                          tableauBordController.consolidation(
                                              tableauBordController
                                                  .currentYear.value);
                                          setState(() {
                                            isValidatingMonth = true;
                                          });
                                        }
                                        if (validation == false) {
                                          await annulerValidationIndic(
                                              validation!,
                                              widget.indicateur.numero - 1,
                                              currentMonth,
                                              widget.indicateur.reference);
                                          tableauBordController.consolidation(
                                              tableauBordController
                                                  .currentYear.value);
                                          await tableauBordController
                                              .updateDataIndicateur();
                                          setState(() {
                                            isValidatingMonth = false;
                                            valide = false;
                                            valideState = true;
                                          });
                                        }
                                      } else {
                                        _showMyDialog(
                                            "Vous n'avez pas l'accès à validateur.");
                                      }
                                      tableauBordController.updateSuiviDate(
                                          tableauBordController
                                              .currentYear.value,
                                          null,
                                          null,
                                          null);
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      setState(() {
                                        isValidatingMonth = false;
                                      });
                                    }),
                    )),
                Container(
                  width: 32,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: valeur != null
                      ? valide == true
                          ? icons[0]
                          : icons[1]
                      : icons[2],
                ),
                const SizedBox(
                  width: 3,
                ),
                Container(
                  height: 35,
                  color: Colors.grey,
                  width: 2,
                )
              ],
            );
    });
  }

  //widget pour la editer la cible
  Widget builCibleColumn(BuildContext context) {
    return Obx(() {
      int numeroLigne = widget.indicateur.numero - 1;
      int currentMonth = tableauBordController.currentMonth.value;
      var dataCible = getValeurCible(numeroLigne);

      return Row(
        children: [
          Container(
              width: 64,
              height: 60,
              alignment: Alignment.center,
              child: Text(formatNumber(dataCible) ?? "")),
          Container(
            width: 32,
            height: 40,
            alignment: Alignment.centerLeft,
            child: IconButton(
              splashRadius: 15,
              splashColor: Colors.amber,
              onPressed: () async {
                final acces = checkAccesAdmin();
                if (acces) {
                  renseignerDonneeCible(context, widget.indicateur, dataCible,
                      numeroLigne, currentMonth);
                } else {
                  _showMyDialog("Vous n'avez pas droit a cette action");
                }
              },
              icon: const Icon(
                Icons.edit,
                size: 12,
              ),
            ),
          ),
          Container(
            height: 35,
            color: Colors.grey,
            width: 2,
          )
        ],
      );
    });
  }

  Future validerIndicateur(
      bool valide, num? valeur, int numero, int colonne, String idLigne) async {
    if (valeur == null) {
      var message = "La donnée n'est pas encore renseignée..";
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnackBar("Erreur", message, Colors.red));
    } else {
      var result = await tableauBordController.validerIndicateurMois(
        valide: valide,
        numeroLigne: numero,
        colonne: colonne,
      );
      if (result == true) {
        tableauBordController.updateDataIndicateur();
        var message = "La donnée a été validée avec succès.";
        ScaffoldMessenger.of(context)
            .showSnackBar(showSnackBar("Succès", message, Colors.green));
      } else {
        var message = "La donnée n'a pas été validée.";
        ScaffoldMessenger.of(context)
            .showSnackBar(showSnackBar("Echec", message, Colors.red));
      }
    }
  }

  Future annulerValidationIndic(
      bool valide, int numero, int colonne, String idLigne) async {
    var result = await tableauBordController.annulerValidationMois(
        valide: valide, numeroLigne: numero, colonne: colonne);
    var message = "Validation annulee avec succes";
    if (result == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnackBar("Succes", message, Colors.green));
    } else {
      var message = "Validation non annulee";
      ScaffoldMessenger.of(context)
          .showSnackBar(showSnackBar("Echec", message, Colors.red));
    }
  }

  String getIdDoc(String idIndicateur) {
    return idIndicateur;
  }

  Widget loadingValidation() {
    return const Center(
      child: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.blue,
          )),
    );
  }

  Future validateDataIndicator(bool? value, int numeroIndicateur) async {}

  Future<bool> renseignerLaDonnee(
      BuildContext context,
      IndicateurModel indicator,
      num? value,
      int? colonne,
      int? numeroLigne) async {
    if (colonne != null && numeroLigne != null) {
      DashBoardUtils.editDataRow(
          context, indicator, value, colonne, numeroLigne);
      return true;
    }
    return false;
  }

  Future<bool> renseignerDonneeCible(
      BuildContext context,
      IndicateurModel indicator,
      num? value,
      int? numeroLigne,
      int? colonne) async {
    DashBoardUtils.editDataCible(
        context, indicator, value, numeroLigne!, colonne!);
    return true;
  }

  Future<bool> changeStatusEntityIndic(int? index, int ligne) async {
    bool result = await tableauBordController.changeStatusEntityIndic(
        statusIndex: index, numeroLigne: ligne);
    return result;
  }

  num? getValeur(int numeroLigne, int colonne) {
    try {
      final value = tableauBordController
          .dataIndicateur.value.valeurs[numeroLigne][colonne];
      return value;
    } catch (e) {
      return null;
    }
  }

  num? getValeurPastYear(int numeroLigne, int colonne) {
    try {
      final value = tableauBordController
          .dataIndicateurPastYear.value.valeurs[numeroLigne][colonne];
      return value;
    } catch (e) {
      return null;
    }
  }

  num? getValeurEcart(int numeroLigne) {
    try {
      final value =
          tableauBordController.dataIndicateur.value.ecarts[numeroLigne];
      return value;
    } catch (e) {
      return null;
    }
  }

  int? getValeurStatusEntity(int numeroLigne) {
    try {
      final value =
          tableauBordController.dataIndicateur.value.statusEntity[numeroLigne];
      int result;
      if (value == true) {
        result = 1;
      } else {
        result = 0;
      }
      return result;
    } catch (e) {
      return 1;
    }
  }

  //recuperer valeur de la cible courante
  num? getValeurCible(int numeroLigne) {
    try {
      final value =
          tableauBordController.dataIndicateur.value.cibles[numeroLigne];
      return value;
    } catch (e) {
      return null;
    }
  }

  // statut de l'indicateur verouille ou deverouille
  int getStatusIndic(int numeroLigne) {
    final value =
        tableauBordController.dataIndicateur.value.statusEntity[numeroLigne];
    if (value == true) {
      return 1;
    } else {
      return 0;
    }
  }

  bool? getValidation(int numeroLigne, int colonne) {
    try {
      final validation = tableauBordController
          .dataIndicateur.value.validations[numeroLigne][colonne];
      return validation;
    } catch (e) {
      return null;
    }
  }
}
