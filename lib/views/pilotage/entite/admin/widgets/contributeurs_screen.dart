import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/models/pilotage/acces_pilotage_model.dart';
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
  ContributeurDataGridSource contributeurDataGridSource =
      ContributeurDataGridSource(contributeurs: []);
  final ProfilPilotageController profilcontroller = Get.find();
  final EntitePilotageController entitePilotageController = Get.find();

  final supabase = Supabase.instance.client;
  bool isLoading = false;

  List<String> entitesName = [];
  List<String> userEntitesName = [];
  List<String> entitesId = [];
  List<String> filiales = [];
  List<String> processList = [];

  void loadEntite() async {
    final email = profilcontroller.userModel.value.email;
    List accessibleEntityId = [];
    final List response = await supabase.from("Entites").select();
    final List responseRestrictions = await supabase
        .from("AccesPilotage")
        .select("restrictions")
        .eq("email", email);
    final List restrictionList = responseRestrictions.first["restrictions"];
    final List<Map<String, dynamic>> responseProcess =
        await supabase.from("Indicateurs").select("processus");
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
      if (element.containsKey("processus") && element["processus"] != null) {
        result.add(element["processus"]);
      }
    }

    return result.toList();
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
    final response = await getListContributeurs();
    setState(() {
      contributeurDataGridSource =
          ContributeurDataGridSource(contributeurs: response);
    });
  }

  late bool isWebOrDesktop;

  @override
  void initState() {
    refreshData();
    loadEntite();
    super.initState();
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
                child: const Text(
                  'Nom',
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          GridColumn(
            columnName: 'prenom',
            width: 150,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Prénom',
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
              child: const Text(
                'E-mail',
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
              child: const Text(
                'Entité',
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
                  child: const Text(
                    'Accès',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'filiale',
              width: 165,
              label: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Filiale',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
            columnName: 'filiere',
            width: 165,
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Filière',
                  overflow: TextOverflow.ellipsis,
                )),
          ),
          GridColumn(
            columnName: 'processus',
            width: 200,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Processus',
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
              child: const Text(
                'Fonction',
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
            child: const Row(
              children: [
                Icon(Icons.refresh_sharp, size: 25, color: Colors.green),
                SizedBox(
                  width: 5,
                ),
                Text("Rafraîchir")
              ],
            ),
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
                      title: const Text(
                        "Ajouter un contributeur",
                        style: TextStyle(color: Colors.blue),
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
            child: const Row(
              children: [
                Icon(Icons.add),
                SizedBox(
                  width: 10,
                ),
                Text("Ajouter")
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
  ContributeurDataGridSource({required List<ContributeurModel> contributeurs}) {
    _contributeurs = contributeurs;
    buildDataGridRow();
  }

  final EntitePilotageController entitePilotageController = Get.find();
  List<ContributeurModel> _contributeurs = <ContributeurModel>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  void buildDataGridRow() {
    dataGridRows =
        _contributeurs.map<DataGridRow>((ContributeurModel contributeur) {
      final filiale = entitePilotageController.filialeCurrentEntity.value;
      final filiere = entitePilotageController.filiereCurrentEntity.value;
      var nomEntites =
          concatenationListe(contributeur.accesPilotageModel?.nomEntite);
      var processus =
          concatenationListe(contributeur.accesPilotageModel?.processus);
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<String>(columnName: 'nom', value: contributeur.nom),
        DataGridCell<String>(columnName: 'prenom', value: contributeur.prenom),
        DataGridCell<String>(columnName: 'mail', value: contributeur.email),
        DataGridCell<String>(columnName: 'entite', value: nomEntites),
        DataGridCell<AccesPilotageModel>(
            columnName: 'acces', value: contributeur.accesPilotageModel),
        DataGridCell<String>(columnName: 'filiale', value: filiale),
        DataGridCell<String>(columnName: 'filiere', value: filiere),
        DataGridCell<String>(columnName: 'processus', value: processus),
        DataGridCell<String>(
            columnName: 'fonction', value: contributeur.fonction),
      ]);
    }).toList();
  }

  // Overrides
  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell dataCell) {
      switch (dataCell.columnName) {
        case "acces":
          return Container(
            padding: const EdgeInsets.only(left: 8.0),
            alignment: Alignment.centerLeft,
            child: getAcces(dataCell.value),
          );
        default:
          return Container(
            padding: const EdgeInsets.only(left: 8.0),
            alignment: Alignment.centerLeft,
            child: Text(dataCell.value.toString()),
          );
      }
    }).toList());
  }

  Widget getAcces(AccesPilotageModel acces) {
    if (acces.estBloque == true) {
      return const Text(
        "Est bloqué",
        style: TextStyle(color: Colors.red),
      );
    }
    if (acces.estAdmin == true) {
      return const Text(
        "Admin",
        style: TextStyle(color: Colors.green),
      );
    }
    if (acces.estValidateur == true) {
      return const Text(
        "Validateur",
        style: TextStyle(color: Colors.blue),
      );
    }
    if (acces.estEditeur == true) {
      return const Text(
        "Editeur",
        style: TextStyle(color: Colors.black),
      );
    }
    if (acces.estSpectateur == true) {
      return const Text(
        "Spectateur",
        style: TextStyle(color: Colors.grey),
      );
    }
    return Container();
  }

  String concatenationListe(List? liste) {
    List<String> strings = liste!.map((e) => e.toString()).toList();
    return strings.join(", ");
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

  bool isSubmetted = false;
  List<String> entiteName = [];
  List<String> selectedProcess = [];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    List<String> dropDownMenuItems = widget.userEntitesName;
    //print(dropDownMenuItems);

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
  static const listAcces = ["Spectateur", "Editeur", "Validateur", "Admin"];

  Map accesToDoc = {
    "Spectateur": "est_spectateur",
    "Editeur": "est_editeur",
    "Validateur": "est_validateur",
    "Admin": "est_admin"
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
                  decoration: const InputDecoration(
                    hintText: "Email",
                    labelText: "Email",
                    border: OutlineInputBorder(),
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
                  hint: const Text('Titre'),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => titre = newValue);
                    }
                  },
                  items: _dropDownMenuTitre,
                ),
              ),
              ListTile(
                title: const Text(
                    "Sélectionnez les entités à affecter à l'utilisateur"),
                trailing: ElevatedButton(
                  onPressed: () async {
                    _showMultiSelect();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        entiteName.isNotEmpty ? Colors.green : Colors.blue,
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Espace pilotage'),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: const Text("Le type d'accès"),
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
                title: const Text(
                    "Sélectionnez les processus à affecter à l'utilisateur"),
                trailing: ElevatedButton(
                  onPressed: () async {
                    _selectProcess();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedProcess.isNotEmpty ? Colors.green : Colors.blue,
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Processus'),
                      Icon(
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
              const Text(
                "Renseigner bien tous les champs avant de soumettre ",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('Annuler'),
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
                                  "processus": selectedProcess,
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
                                      'Le compte ${emailEditingController.text} a été crée .',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              }
                            },
                      child: const Text('Soumettre'))
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
  final List<String> _selectedItems = [];
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _selectAll = widget.selectedItems.length == widget.items.length;
  }

  void _toggleSelectAll(bool? newValue) {
    if (newValue != null) {
      setState(() {
        _selectAll = newValue;
        if (_selectAll) {
          widget.selectedItems.clear();
          widget.selectedItems.addAll(widget.items);
        } else {
          widget.selectedItems.clear();
        }
      });
    }
  }

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        widget.selectedItems.add(itemValue);
      } else {
        widget.selectedItems.remove(itemValue);
      }
      _selectAll = widget.selectedItems.length == widget.items.length;
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, widget.selectedItems);
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
                decoration: const InputDecoration(
                  hintText: 'Recherche...',
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
                title: const Text('Tout selectionner'),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: _toggleSelectAll,
                activeColor: Colors.blue,
              ),
              ...filteredItems.map(
                (item) => CheckboxListTile(
                  value: widget.selectedItems.contains(item),
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
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Valider'),
          ),
        ],
      );
    });
  }
}
