import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:perf_rse/api/send_mail.dart';
import 'package:perf_rse/constants/constant_translation_maps.dart';
import 'package:perf_rse/helper/helper_methods.dart';
import 'package:perf_rse/models/pilotage/acces_pilotage_model.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/views/pilotage/controllers/entite_pilotage_controler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../controllers/profil_pilotage_controller.dart';

class ContributeurScreen extends StatefulWidget {
  const ContributeurScreen({super.key});

  @override
  State<ContributeurScreen> createState() => _ContributeurScreenState();
}

class _ContributeurScreenState extends State<ContributeurScreen> {
  late ContributeurDataGridSource contributeurDataGridSource;
  final ProfilPilotageController profilcontroller = Get.find();
  final EntitePilotageController entitePilotageController = Get.find();
  final TextEditingController _textEditingController = TextEditingController();

  final supabase = Supabase.instance.client;
  List<ContributeurModel> filteredContributorsList = [];
  List<ContributeurModel> contributorsList = [];

  bool isLoading = false;

  bool edition = false;

  List<String> entitesName = [];
  List<String> userEntitesName = [];
  List<String> entitesId = [];
  List<String> filiales = [];
  List<String> processList = [];
  List<Map<String, dynamic>> processAll = [];
  void loadEntite() async {
    final email = profilcontroller.userModel.value.email;
    List accessibleEntityId = [];
    final List response = await supabase.from("Entites").select();
    final List responseRestrictions = await supabase
        .from("AccesPilotage")
        .select("restrictions")
        .eq("email", email);
    final List restrictionList = responseRestrictions.first["restrictions"];
    final List<Map<String, dynamic>> responseProcess = await supabase
        .from("Processus")
        .select("nom_processus, nom_processus_en");
    processAll = responseProcess;
    processList = getProcessus(responseProcess);

    for (var data in response) {
      entitesName.add(data["nom_entite"]);
      entitesId.add(data["id_entite"]);
      filiales.add(data["filiale"]);
    }
    if (restrictionList.isNotEmpty) {
      accessibleEntityId = listFilter(restrictionList, entitesId);
      for (var idEntite in accessibleEntityId) {
        userEntitesName.add(entitesName[entitesId.indexOf(idEntite)]);
      }
    } else {
      accessibleEntityId = entitesId;
      userEntitesName = entitesName;
    }
  }

  List listFilter(List listA, List<String> listB) {
    Set convertListA = listA.toSet();
    Set<String> convertListB = listB.toSet();

    final diffBtoA = convertListB.difference(convertListA);

    return diffBtoA.toList();
  }

  List<String> getProcessus(List<Map<String, dynamic>> liste) {
    Set<String> result = {};

    for (var element in liste) {
      if (tr.abrLange.toLowerCase() == 'en') {
        if (element.containsKey("nom_processus_en") &&
            element["nom_processus_en"] != null) {
          result.add(element["nom_processus_en"]);
        }
      } else {
        if (element.containsKey("nom_processus") &&
            element["nom_processus"] != null) {
          result.add(element["nom_processus"]);
        }
      }
    }

    return result.toList();
  }

  Future<List<ContributeurModel>> translateEnProcessContributeurs(
      List<ContributeurModel> contributeurs) async {
    final List<ContributeurModel> currentContributeur = [];
    for (var contrib in contributeurs) {
      List<String>? userProcess = contrib.accesPilotageModel!.processus;
      contrib.accesPilotageModel!.processus =
          getTranslationCheckListProcess(userProcess);
      currentContributeur.add(contrib);
    }

    return currentContributeur;
  }

  Future<List<ContributeurModel>> getListContributeurs() async {
    setState(() {
      isLoading = true;
    });
    List dataMap = [];
    List resultEntreprise = await supabase
        .from('Entites')
        .select('filiale')
        .eq("id_entite", entitePilotageController.currentEntite.value);
    final entreprise = resultEntreprise.first["filiale"];
    final List userResponse = await supabase
        .from("Users")
        .select()
        .contains("entreprise", ["$entreprise"]);
    final List<Map<String, dynamic>> accesPilotageResponse =
        await supabase.from("AccesPilotage").select();
    for (Map acces in accesPilotageResponse) {
      Map dataContributeur = {};
      dataContributeur["acces_pilotage"] = acces;
      Map<String, dynamic>? user;
      try {
        user = userResponse.firstWhere(
            (element) => element["email"] == acces["email"],
            orElse: () => <String, dynamic>{});
      } catch (e) {
        print(e);
        user = null;
      }
      List userEntities = acces["entite"];

      if (!userEntities
              .contains(entitePilotageController.currentEntite.value) ||
          acces["est_admin"] == true) {
        continue;
      }

      if (user != null && user.isNotEmpty) {
        dataContributeur["email"] = user["email"];
        dataContributeur["nom"] = user["nom"];
        dataContributeur["prenom"] = user["prenom"];
        dataContributeur["fonction"] = user["fonction"];
        dataMap.add(dataContributeur);
      }
    }
    final listContribteurs =
        dataMap.map((json) => ContributeurModel.fromJson(json)).toList();
    setState(() {
      isLoading = false;
    });
    return listContribteurs;
  }

  void refreshData() async {
    try {
      final response = await getListContributeurs();
      contributorsList = tr.abrLange.toLowerCase() == 'en'
          ? await translateEnProcessContributeurs(response)
          : response;
      filteredContributorsList = contributorsList;
      setState(() {
        contributeurDataGridSource = ContributeurDataGridSource(
            contributeurs: filteredContributorsList,
            edition: edition,
            adminEntitiesNamesList: userEntitesName,
            entitiesNamesList: entitesName,
            entitiesIdList: entitesId,
            processusList: processList);
      });
    } catch (e) {
      print(e);
    }
  }

  late bool isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    loadEntite();
    refreshData();
    _textEditingController.addListener(() {
      _onSearchTextChanged(_textEditingController.text);
    });
  }

  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    try {
      setState(() {
        filteredContributorsList = contributorsList
            .where((item) =>
                item.email!.toLowerCase().contains(text.toLowerCase()) ||
                item.nom!.toLowerCase().contains(text.toLowerCase()) ||
                item.prenom!.toLowerCase().contains(text.toLowerCase()))
            .toList();
        contributeurDataGridSource = ContributeurDataGridSource(
            contributeurs: filteredContributorsList,
            edition: edition,
            adminEntitiesNamesList: userEntitesName,
            entitiesNamesList: entitesName,
            entitiesIdList: entitesId,
            processusList: processList);
      });
    } catch (e) {
      print(e);
    }
  }

  SfDataGridTheme _buildDataGridForWeb() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          //brightness: Brightness.light,
          rowHoverColor: Colors.amber.withOpacity(0.5),
          headerHoverColor: Colors.white.withOpacity(0.3),
          headerColor: Colors.blue),
      child: SfDataGrid(
        source: contributeurDataGridSource,
        columnWidthMode: ColumnWidthMode.fill,
        isScrollbarAlwaysShown: true,
        headerRowHeight: 40,
        gridLinesVisibility: GridLinesVisibility.horizontal,
        columns: <GridColumn>[
          GridColumn(
              width: 130,
              columnName: 'nom',
              label: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tr.name,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          GridColumn(
            columnName: 'prenom',
            width: 150,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tr.forename,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'mail',
            width: 250.0,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                tr.email,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'entite',
            width: 150.0,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tr.entity,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
              columnName: 'acces',
              width: 200,
              label: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tr.access,
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'filiale',
              width: 165,
              label: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tr.subsidiarie,
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
            columnName: 'filiere',
            width: 165,
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  tr.filiere,
                  overflow: TextOverflow.ellipsis,
                )),
          ),
          GridColumn(
            columnName: 'processus',
            width: 200,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tr.process,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'fonction',
            width: 200,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tr.fonction,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget actionWidget() {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onHover: (value) {},
          onTap: () async {
            refreshData();
          },
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(Icons.refresh_sharp, size: 25, color: Colors.green),
                const SizedBox(
                  width: 5,
                ),
                Text(tr.reflesh)
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(tr.edition),
        const SizedBox(width: 5),
        Switch(
          value: edition,
          onChanged: (value) async {
            setState(() {
              edition = value;
            });
            refreshData();
          },
          activeColor: Colors.blue,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 300,
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: tr.searchBarManageUser,
              border: const OutlineInputBorder(),
            ),
            onChanged: _onSearchTextChanged,
          ),
        ),
        const SizedBox(width: 10),
        Tooltip(
          message:
              tr.validatorEditAccesTooltip, // Validator capable of collecting
          child: Row(
            children: [
              Text(
                tr.typeacccesList("validator"),
                style: const TextStyle(color: Color.fromARGB(255, 33, 33, 243)),
              ),
              const Icon(
                Icons.info_outline,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Tooltip(
          message:
              tr.validatorNoEditAccesTooltip, // Validator unable to collect
          child: Row(
            children: [
              Text(
                tr.typeacccesList("validator"),
                style:
                    const TextStyle(color: Color.fromARGB(255, 12, 150, 157)),
              ),
              const Icon(
                Icons.info_outline,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
        ElevatedButton(
            onPressed: () {
              if (entitesName.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        tr.addContributeur,
                        style: const TextStyle(color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.all(30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      titlePadding:
                          const EdgeInsets.only(top: 20, right: 20, left: 20),
                      titleTextStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                      content: AjoutContributeur(
                        entitesName: entitesName,
                        userEntitesName: userEntitesName,
                        entitesId: entitesId,
                        filiales: filiales,
                        processus: processList,
                      ),
                    );
                  },
                );
              }
            },
            child: Row(
              children: [
                const Icon(Icons.add),
                const SizedBox(
                  width: 10,
                ),
                Text(tr.add)
              ],
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: actionWidget(),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildDataGridForWeb())
        ],
      ),
    );
  }
}

class ContributeurDataGridSource extends DataGridSource {
  ContributeurDataGridSource(
      {required List<ContributeurModel> contributeurs,
      required bool edition,
      required List<String> adminEntitiesNamesList,
      required List<String> entitiesNamesList,
      required List<String> entitiesIdList,
      required List<String> processusList}) {
    _contributeurs = contributeurs;
    _edition = edition;
    _adminEntitiesNamesList = adminEntitiesNamesList;
    _entitiesNamesList = entitiesNamesList;
    _entitiesIdList = entitiesIdList;
    _processusList = processusList;
    buildDataGridRow();
  }

  final EntitePilotageController entitePilotageController = Get.find();
  List<ContributeurModel> _contributeurs = <ContributeurModel>[];
  bool _edition = false;
  List<String> _adminEntitiesNamesList = [];
  List<String> _entitiesNamesList = [];
  List<String> _entitiesIdList = [];
  List<String> _processusList = [];

  final supabase = Supabase.instance.client;

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  void buildDataGridRow() {
    dataGridRows =
        _contributeurs.map<DataGridRow>((ContributeurModel contributeur) {
      final filiale = entitePilotageController.filialeCurrentEntity.value;
      final filiere = entitePilotageController.filiereCurrentEntity.value;
      var nomEntites =
          concatenationListe(contributeur.accesPilotageModel?.nomEntite);
      var processus =
          concatenationListe(contributeur.accesPilotageModel?.processus!);
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<Map<String, dynamic>>(columnName: 'nom', value: {
          "valeur": contributeur.nom,
          "mail": contributeur.email,
          "entitesList": contributeur.accesPilotageModel?.nomEntite!,
          "processus": contributeur.accesPilotageModel?.processus!
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'prenom', value: {
          "valeur": contributeur.prenom,
          "mail": contributeur.email,
          "entitesList": contributeur.accesPilotageModel?.nomEntite!,
          "processus": contributeur.accesPilotageModel?.processus!
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'mail', value: {
          "valeur": contributeur.email,
          "mail": contributeur.email,
          "entitesList": contributeur.accesPilotageModel?.nomEntite!,
          "processus": contributeur.accesPilotageModel?.processus!
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'entite', value: {
          "valeur": nomEntites,
          "mail": contributeur.email,
          "entitesList": contributeur.accesPilotageModel?.nomEntite!,
          "processus": contributeur.accesPilotageModel?.processus!
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'acces', value: {
          "valeur": contributeur.accesPilotageModel!,
          "mail": contributeur.email,
          "entitesList": contributeur.accesPilotageModel?.nomEntite!,
          "processus": contributeur.accesPilotageModel?.processus!
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'filiale', value: {
          "valeur": filiale,
          "mail": contributeur.email,
          "entitesList": contributeur.accesPilotageModel?.nomEntite!,
          "processus": contributeur.accesPilotageModel?.processus!
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'filiere', value: {
          "valeur": filiere,
          "mail": contributeur.email,
          "entitesList": contributeur.accesPilotageModel?.nomEntite!,
          "processus": contributeur.accesPilotageModel?.processus!
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'processus', value: {
          "valeur": processus,
          "mail": contributeur.email,
          "entitesList": contributeur.accesPilotageModel?.nomEntite!,
          "processus": contributeur.accesPilotageModel?.processus!
        }),
        DataGridCell<Map<String, dynamic>>(columnName: 'fonction', value: {
          "valeur": contributeur.fonction,
          "mail": contributeur.email,
          "entitesList": contributeur.accesPilotageModel?.nomEntite!,
          "processus": contributeur.accesPilotageModel?.processus!
        }),
      ]);
    }).toList();

    //print("data build row ok");
  }

  // Overrides
  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell dataCell) {
      switch (dataCell.columnName) {
        case "entite":
          return Container(
            padding: const EdgeInsets.only(left: 8.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Flexible(
                    child: SelectableText(dataCell.value["valeur"].toString())),
                if (_edition)
                  EditContributeur(
                    mail: dataCell.value["mail"],
                    champ: "entite",
                    accesUser: null,
                    adminEntites: _adminEntitiesNamesList,
                    processus: [],
                    entitiesNamesList: _entitiesNamesList,
                    entitesIdList: _entitiesIdList,
                    selectedItems: dataCell.value["entitesList"],
                  )
              ],
            ),
          );
        case "acces":
          return Container(
            padding: const EdgeInsets.only(left: 8.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                getAcces(dataCell.value["valeur"]),
                if (_edition)
                  EditContributeur(
                    mail: dataCell.value["mail"],
                    champ: "acces",
                    accesUser: dataCell.value["valeur"],
                    entitiesNamesList: [],
                    entitesIdList: [],
                    adminEntites: [],
                    processus: [],
                    selectedItems: [],
                  )
              ],
            ),
          );
        case "processus":
          return Container(
            padding: const EdgeInsets.only(left: 8.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Flexible(
                    child: SelectableText(dataCell.value["valeur"].toString())),
                if (_edition)
                  EditContributeur(
                    mail: dataCell.value["mail"],
                    champ: "processus",
                    processus: _processusList,
                    accesUser: null,
                    adminEntites: [],
                    entitiesNamesList: [],
                    entitesIdList: [],
                    selectedItems: dataCell.value["processus"],
                  )
              ],
            ),
          );
        default:
          return Container(
            padding: const EdgeInsets.only(left: 8.0),
            alignment: Alignment.centerLeft,
            child: Text("${dataCell.value["valeur"] ?? "---"}"),
          );
      }
    }).toList());
  }

  Widget getAcces(AccesPilotageModel acces) {
    if (acces.estAdmin == true) {
      return Text(
        tr.typeacccesList("admin"),
        style: const TextStyle(color: Colors.green),
      );
    }
    if (acces.estValidateur == true) {
      return Text(
        tr.typeacccesList("validator"),
        style: const TextStyle(color: Color.fromARGB(255, 12, 150, 157)),
      );
    }
    if (acces.estValidateur == true && acces.estEditeur == true) {
      return Text(
        tr.typeacccesList("validator"),
        style: const TextStyle(color: Color.fromARGB(255, 33, 33, 243)),
      );
    }
    if (acces.estEditeur == true) {
      return Text(
        tr.typeacccesList("editor"),
        style: const TextStyle(color: Colors.black),
      );
    }
    if (acces.estSpectateur == true) {
      return Text(
        tr.typeacccesList("spectator"),
        style: const TextStyle(color: Colors.grey),
      );
    }
    return Container();
  }

  String concatenationListe(List? liste) {
    List<String> strings = liste!.map((e) => e.toString()).toList();
    return strings.join(", ");
  }
}

class EditContributeur extends StatefulWidget {
  final String mail;
  final String champ;
  final AccesPilotageModel? accesUser;
  final List<String> adminEntites;
  final List<String> entitiesNamesList;
  final List<String> entitesIdList;
  final List<String> processus;
  final List<String> selectedItems;

  const EditContributeur(
      {super.key,
      required this.mail,
      required this.champ,
      required this.accesUser,
      required this.adminEntites,
      required this.entitiesNamesList,
      required this.entitesIdList,
      required this.processus,
      required this.selectedItems});

  @override
  State<EditContributeur> createState() => _EditContributeurState();
}

class _EditContributeurState extends State<EditContributeur> {
  final TextEditingController emailValueController = TextEditingController();

  List<String> itemsSelected = [];
  List<String> selectedEntites = [];
  List<String> selectedProcess = [];
  List<String> selectedAccess = [];
  List restrictedEntities = [];

  void _selectProcessus() async {
    List<String> dropDownMenuItems = widget.processus;
    itemsSelected = widget.selectedItems;

    final List<String>? results = await showDialog<List<String>>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(
              items: dropDownMenuItems, selectedItems: itemsSelected);
        });

    if (results == null) {
      return;
    }

    EasyLoading.show(status: tr.loadingUpdating);
    try {
      await Supabase.instance.client.from('AccesPilotage').update(
          {"processus": getProcessUser(results)}).eq("email", widget.mail);
      setState(() {
        selectedProcess = results;
        itemsSelected = results;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar(tr.success, "changement effectue", Colors.green));
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(tr.fail,
          "Une erreur est survenue", Colors.red, const Duration(seconds: 6)));
    }
    EasyLoading.dismiss();
  }

  void _selectEntites() async {
    List<String> dropDownMenuItems = widget.adminEntites;
    itemsSelected = widget.selectedItems;

    final List<String>? results = await showDialog<List<String>>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(
              items: dropDownMenuItems, selectedItems: itemsSelected);
        });

    if (results == null) {
      return;
    }

    EasyLoading.show(status: tr.loadingUpdating);
    try {
      setState(() {
        selectedEntites = getIdEntities(results);
        itemsSelected = results;
        restrictedEntities =
            restrictElementFilter(widget.entitesIdList, selectedEntites);
      });
      await Supabase.instance.client
          .from('AccesPilotage')
          .update({"entite": selectedEntites}).eq("email", widget.mail);
      await Supabase.instance.client
          .from('AccesPilotage')
          .update({"nom_entite": itemsSelected}).eq("email", widget.mail);
      await Supabase.instance.client.from('AccesPilotage').update(
          {"restrictions": restrictedEntities}).eq("email", widget.mail);
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar(tr.success, "changement effectue", Colors.green));
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(tr.fail,
          "Une erreur est survenue", Colors.red, const Duration(seconds: 6)));
    }
    EasyLoading.dismiss();
  }

  List<String> getIdEntities(List<String> entitiesNames) {
    List<String> result = [];

    for (var entity in entitiesNames) {
      var index = widget.entitiesNamesList.indexOf(entity);
      result.add(widget.entitesIdList[index]);
    }

    return result;
  }

  void _selectAcces() async {
    List<String> dropDownMenuItems = [
      tr.typeacccesList("admin"),
      tr.typeacccesList("validator"),
      tr.typeacccesList("editor"),
      tr.typeacccesList("spectator")
    ];
    itemsSelected = getAccesList(widget.accesUser!);

    final List<String>? results = await showDialog<List<String>>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(
              items: dropDownMenuItems, selectedItems: itemsSelected);
        });

    if (results == null) {
      return;
    }

    final List<String>? diffListResults =
        restrictElementFilter(dropDownMenuItems, results);

    EasyLoading.show(status: tr.loadingUpdating);
    try {
      for (String acces in results) {
        String accesBD = accesToDoc[acces]!;
        await Supabase.instance.client
            .from('AccesPilotage')
            .update({accesBD: true}).eq("email", widget.mail);
      }
      if (diffListResults != null && diffListResults.isNotEmpty) {
        for (String acces in diffListResults) {
          String accesBD = accesToDoc[acces]!;
          await Supabase.instance.client
              .from('AccesPilotage')
              .update({accesBD: false}).eq("email", widget.mail);
        }
      }
      setState(() {
        itemsSelected = results;
        selectedAccess = results;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar(tr.success, "changement effectue", Colors.green));
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(tr.fail,
          "Une erreur est survenue", Colors.red, const Duration(seconds: 6)));
    }
    EasyLoading.dismiss();
  }

  List<String> getAccesList(AccesPilotageModel acces) {
    List<String> result = [];

    if (acces.estAdmin == true) {
      result.add(tr.typeacccesList("admin"));
    }
    if (acces.estEditeur == true) {
      result.add(tr.typeacccesList("editor"));
    }
    if (acces.estValidateur == true) {
      result.add(tr.typeacccesList("validator"));
    }
    if (acces.estSpectateur == true) {
      result.add(tr.typeacccesList("spectator"));
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    emailValueController.text = widget.mail;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        IconButton(
            onPressed: () async {
              if (widget.champ == "mail") {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Mise a jour ${widget.champ}"),
                        contentPadding: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        titlePadding:
                            const EdgeInsets.only(top: 20, right: 20, left: 20),
                        titleTextStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                        content: SizedBox(
                          width: 400,
                          height: 200,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: emailValueController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Expanded(child: Container()),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    child: Text(tr.cancel),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        // changement de mail : suppression du mail/compte puis creation d'un nouveau compte avec le mail renseignee
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(tr.confirm))
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              } else if (widget.champ == "entite") {
                _selectEntites();
              } else if (widget.champ == "acces") {
                _selectAcces();
              } else if (widget.champ == "processus") {
                _selectProcessus();
              }
            },
            splashRadius: 15,
            icon: const Icon(
              Icons.edit,
              size: 20,
              color: Colors.green,
            ))
      ],
    );
  }
}

class ContributeurModel {
  String? email;
  String? nom;
  String? prenom;
  String? fonction;
  AccesPilotageModel? accesPilotageModel;

  ContributeurModel({
    this.email,
    this.nom,
    this.prenom,
    this.fonction,
    this.accesPilotageModel,
  });

  factory ContributeurModel.fromRawJson(String str) =>
      ContributeurModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContributeurModel.fromJson(Map<dynamic, dynamic> json) =>
      ContributeurModel(
        email: json["email"],
        nom: json["nom"],
        prenom: json["prenom"],
        fonction: json["fonction"],
        accesPilotageModel: AccesPilotageModel.fromJson(json["acces_pilotage"]),
      );

  Map<String, dynamic> toJson() => {
        "email": nom,
        "nom": nom,
        "prenom": prenom,
        "fonction": fonction,
        "acces_pilotage": accesPilotageModel?.toJson(),
      };
}

class AjoutContributeur extends StatefulWidget {
  final List<String> entitesName;
  final List<String> userEntitesName;
  final List<String> entitesId;
  final List<String> filiales;
  final List<String> processus;
  const AjoutContributeur(
      {super.key,
      required this.entitesName,
      required this.userEntitesName,
      required this.entitesId,
      required this.processus,
      required this.filiales});

  @override
  State<AjoutContributeur> createState() => _AjoutContributeurState();
}

class _AjoutContributeurState extends State<AjoutContributeur> {
  final supabase = Supabase.instance.client;

  final SendMailController sendMailController = SendMailController();

  bool isSubmetted = false;
  List<String> entiteName = [];
  List<String> selectedProcess = [];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    List<String> dropDownMenuItems = widget.userEntitesName;

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: dropDownMenuItems, selectedItems: entiteName);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        entiteName = results;
      });
    }
  }

  void _selectProcess() async {
    List<String> dropDownMenuItems = widget.processus;

    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(
              items: dropDownMenuItems, selectedItems: selectedProcess);
        });

    if (results != null) {
      setState(() {
        selectedProcess = results;
      });
    }
  }

  static const listTitres = ["M.", "Mme", "Mlle"];
  static List<String> listAcces = [
    tr.typeacccesList('spectator'),
    tr.typeacccesList('editor'),
    tr.typeacccesList('validator'),
    tr.typeacccesList('admin')
  ];

  Map accesToDoc = {
    tr.typeacccesList('spectator'): "est_spectateur",
    tr.typeacccesList('editor'): "est_editeur",
    tr.typeacccesList('validator'): "est_validateur",
    tr.typeacccesList('admin'): "est_admin"
  };

  String? titre;
  String? acces;

  final _formKey = GlobalKey<FormState>();

  final List<DropdownMenuItem<String>> _dropDownMenuAcces = listAcces
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  final List<DropdownMenuItem<String>> _dropDownMenuTitre = listTitres
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController nomEditingController = TextEditingController();
  final TextEditingController prenomEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
                child: TextFormField(
                  controller: emailEditingController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !GetUtils.isEmail(value)) {
                      return '...';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: tr.email,
                    labelText: tr.email,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                title: const Text("M./Mme/Mlle"),
                trailing: DropdownButton(
                  menuMaxHeight: 400,
                  value: titre,
                  hint: Text(tr.titleUser),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => titre = newValue);
                    }
                  },
                  items: _dropDownMenuTitre,
                ),
              ),
              ListTile(
                title: Text(tr.userSelectMessage),
                trailing: ElevatedButton(
                  onPressed: () async {
                    _showMultiSelect();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        entiteName.isNotEmpty ? Colors.green : Colors.blue,
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(tr.espacePilotage),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(tr.accessType),
                trailing: DropdownButton(
                  menuMaxHeight: 400,
                  value: acces,
                  hint: const Text('Choose'),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => acces = newValue);
                    }
                  },
                  items: _dropDownMenuAcces,
                ),
              ),
              ListTile(
                title: Text(tr.userSelectProcessMessage),
                trailing: ElevatedButton(
                  onPressed: () async {
                    _selectProcess();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedProcess.isNotEmpty ? Colors.green : Colors.blue,
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(tr.process),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                tr.completeAllFields,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(tr.cancel),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Container(
                    child:
                        isSubmetted ? const CircularProgressIndicator() : null,
                  ),
                  ElevatedButton(
                      onPressed: isSubmetted
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate() &&
                                  titre != null &&
                                  entiteName.isNotEmpty &&
                                  acces != null &&
                                  selectedProcess.isNotEmpty) {
                                setState(() {
                                  isSubmetted = true;
                                });
                                List filiale = [];
                                List<String> idEntite = [];

                                for (var entity in entiteName) {
                                  var index =
                                      widget.entitesName.indexOf(entity);
                                  filiale.add(widget.filiales[index]);
                                  idEntite.add(widget.entitesId[index]);
                                }
                                List listUserRestriction =
                                    restrictElementFilter(
                                        widget.entitesId, idEntite);

                                final userMap = {
                                  "email": emailEditingController.text
                                      .toLowerCase(), // .toLowerCase()
                                  "nom": "Nouvel",
                                  "prenom": "Utilisateur",
                                  "acces_pilotage":
                                      emailEditingController.text.toLowerCase(),
                                  "entreprise": filiale,
                                  "est_bloque": false,
                                  "titre": titre,
                                };
                                //print(getProcessUser(selectedProcess));

                                final userAcces = {
                                  "email":
                                      emailEditingController.text.toLowerCase(),
                                  "entite": idEntite,
                                  "nom_entite": entiteName,
                                  "est_bloque": false,
                                  "est_spectateur": false,
                                  "est_editeur": false,
                                  "est_validateur": false,
                                  "restrictions": listUserRestriction,
                                  "est_admin": false,
                                  "processus": getProcessUser(selectedProcess),
                                };

                                userAcces[accesToDoc[acces]] = true;

                                try {
                                  final res2 = await supabase
                                      .from('AccesPilotage')
                                      .insert(userAcces);

                                  final res1 = await supabase
                                      .from('Users')
                                      .insert(userMap);

                                  String pwd = generatePassword();
                                  final AuthResponse res3 = await supabase.auth
                                      .signUp(
                                          email: emailEditingController.text,
                                          password: pwd,
                                          data: {"password": pwd});
                                  final passwordMail =
                                      await sendMailController.sendPasswordMail(
                                          emailEditingController.text, pwd);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 10),
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        e.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  );
                                }

                                setState(() {
                                  isSubmetted = false;
                                });

                                Navigator.of(context).pop();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      tr.accountHasCreated(
                                          emailEditingController.text),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              }
                            },
                      child: Text(tr.submit))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String generatePassword() {
    const String validChars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#';

    Random random = Random();
    String password = '';

    for (int i = 0; i < 10; i++) {
      int randomIndex = random.nextInt(validChars.length);
      password += validChars[randomIndex];
    }

    return password;
  }

  List<String> restrictElementFilter(List<String> listA, List<String> listB) {
    Set<String> convertListA = listA.toSet();
    Set<String> convertListB = listB.toSet();

    final diffA = convertListA.difference(convertListB);
    final diffB = convertListB.difference(convertListA);

    final differenceinAtoB = diffA.union(diffB);

    return differenceinAtoB.toList();
  }
}

// Multi Select widget
// This widget is reusable
class MultiSelect extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  const MultiSelect(
      {Key? key, required this.items, required this.selectedItems})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  List<String> _selectedItems = [];
  late List<String> _tempSelectedItems;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _tempSelectedItems = List.from(widget.selectedItems);
    _selectAll = _tempSelectedItems.length == widget.items.length;
  }

  void _toggleSelectAll(bool? newValue) {
    if (newValue != null) {
      setState(() {
        _selectAll = newValue;
        if (_selectAll) {
          _tempSelectedItems.clear();
          _tempSelectedItems.addAll(widget.items);
        } else {
          _tempSelectedItems.clear();
        }
      });
    }
  }

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _tempSelectedItems.add(itemValue);
      } else {
        _tempSelectedItems.remove(itemValue);
      }
      _selectAll = _tempSelectedItems.length == widget.items.length;
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.of(context).pop();
  }

// this function is called when the Submit button is tapped
  void _submit() {
    if (_tempSelectedItems.isEmpty) {
      // Show a dialog if no items are selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(tr.alert),
            content: Text(tr.checkboxListAlertMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context, _tempSelectedItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    List<String> filteredItems = List.from(widget.items);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: '${tr.recherche}...',
                ),
                onChanged: (value) {
                  setState(() {
                    filteredItems = widget.items
                        .where((item) =>
                            item.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              CheckboxListTile(
                value: _selectAll,
                title: Text(tr.uncheckAll),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: _toggleSelectAll,
                activeColor: Colors.blue,
              ),
              ...filteredItems.map(
                (item) => CheckboxListTile(
                  value: _tempSelectedItems.contains(item),
                  title: Text(item),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (isChecked) => _itemChange(item, isChecked!),
                  activeColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _cancel,
            child: Text(tr.cancel),
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text(tr.confirm),
          ),
        ],
      );
    });
  }
}

String getTranslation(String key) {
  return processTransFR[key]!;
}

List<String> getProcessUser(List<String> selectedProcess) {
  List<String> result = [];
  for (String process in selectedProcess) {
    result.add(getTranslation(process));
  }
  return result;
}

List<String>? getTranslationCheckListProcess(List<String>? processList) {
  List<String>? result = [];

  if (processList!.isNotEmpty) {
    for (String process in processList) {
      result.add(processTransEN[process]!);
    }
  } else {
    result = processList;
  }

  return result;
}

List<String> restrictElementFilter(List<String> listA, List<String> listB) {
  Set<String> convertListA = listA.toSet();
  Set<String> convertListB = listB.toSet();

  final diffA = convertListA.difference(convertListB);
  final diffB = convertListB.difference(convertListA);

  final differenceinAtoB = diffA.union(diffB);

  return differenceinAtoB.toList();
}
