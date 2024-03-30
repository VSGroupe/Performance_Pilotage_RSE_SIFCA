// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../api/supabse_db.dart';
import '../../../controller/time_system_controller.dart';
import '../../../models/pilotage/data_indicateur_row_model.dart';
import '../../../models/pilotage/indicateur_model.dart';
import '../../../models/pilotage/acces_pilotage_model.dart';
import 'drop_down_controller.dart';
import 'entite_pilotage_controler.dart';
import 'profil_pilotage_controller.dart';
import 'package:http/http.dart' as http;

class TableauBordController extends GetxController {
  final DropDownController dropDownController = Get.find();

  final indicateursList = <IndicateurModel>[].obs;

  //final accesPilotage = AccesPilotageModel;

  Map<String, dynamic>? dataMapExport;
  final indicateursListApparente = <IndicateurModel>[].obs;

  final dataIndicateur = DataIndicateurRowModel.init().obs;
  final dataIndicateurPastYear = DataIndicateurRowModel.init().obs;

  final DataBaseController dataBaseController = DataBaseController();

  final ProfilPilotageController profilPilotageController = Get.find();
  final EntitePilotageController entitePilotageController = Get.find();

  final supabase = Supabase.instance.client;

  final isLoading = false.obs;
  final statusIntialisation = false.obs;

  final triggerValeur = 0.obs;

  final isLoadingData = false.obs;
  final editing = false.obs;
  var currentYear = 0.obs;
  var currentMonth = 0.obs;
  var allYearsList = [].obs;

  var colonnesTableauBord = [
    "realise",
    "janvier",
    "fevrier",
    "mars",
    "avril",
    "mai",
    "juin",
    "juillet",
    "aout",
    "septembre",
    "octobre",
    "novembre",
    "decembre"
  ];

  var listMonth = [
    "Janvier",
    "Février",
    "Mars",
    "Avril",
    "Mai",
    "Juin",
    "Juillet",
    "Août",
    "Septembre",
    "Octobre",
    "Novembre",
    "Décembre"
  ];

  int getIndicateurLength() {
    return indicateursList.length;
  }

  void filtreListApparente() {
    if (dropDownController.filtreProcessus.isEmpty) {
      indicateursListApparente.value = indicateursList;
    } else {
      final List<IndicateurModel> Klist = [];
      for (var indicateur in indicateursList) {
        if (dropDownController.filtreProcessus.contains(indicateur.processus)) {
          Klist.add(indicateur);
        }
      }
      indicateursListApparente.value = Klist;
    }
  }

  void filtreListApparenteOtherUser() {
    if (dropDownController.filtreProcessus.isEmpty) {
      final List<IndicateurModel> userIncateurList = [];
      List<String>? processListUser =
          profilPilotageController.accesPilotageModel.value.processus;
      if (processListUser!.isNotEmpty) {
        for (var process in processListUser) {
          for (var instance in indicateursList) {
            if (process == instance.processus) {
              userIncateurList.add(instance);
            }
          }
        }
      }
      indicateursListApparente.value = userIncateurList;
    } else {
      final List<IndicateurModel> Klist = [];
      for (var indicateur in indicateursList) {
        if (dropDownController.filtreProcessus.contains(indicateur.processus)) {
          Klist.add(indicateur);
        }
      }
      indicateursListApparente.value = Klist;
    }
  }

  List<String>? getProcessUser(AccesPilotageModel userProcessus) {
    return userProcessus.processus;
  }

  bool? estAdmin(AccesPilotageModel status) {
    return status.estAdmin;
  }

  void initDateTime() {
    var dateTime = TimeSystemController.date;
    currentYear.value = dateTime.year;
    currentMonth.value = dateTime.month;
  }

  void changeMonth(int month) {
    currentMonth.value = month;
  }

  bool changeYear(int year) {
    if (currentYear.value == year) {
      return false;
    }
    var dateTime = DateTime.now();
    if (year == dateTime.year) {
      currentYear.value = year;
      currentMonth.value = dateTime.month;
      return true;
    } else {
      currentYear.value = year;
      currentMonth.value = 12;
      return true;
    }
  }

  void initialisation(BuildContext context) async {
    allYearsList.value = TimeSystemController.years;
    //dataCibleList.value = await dataBaseController.getValeurCibleIndicateur();
    isLoading.value = true;
    indicateursList.value = await dataBaseController.getAllIndicateur();
    await initialisationDataIndicateur();
    indicateursListApparente.value = indicateursList;
    final idDataIndicateur =
        '${entitePilotageController.currentEntite.value}_${currentYear.value}';
    final idDataIndicateurPastYear =
        '${entitePilotageController.currentEntite.value}_${currentYear.value - 1}';
    dataIndicateur.value =
        await dataBaseController.getAllDataRowIndicateur(idDataIndicateur);
    dataIndicateurPastYear.value = await dataBaseController
        .getAllDataRowIndicateur(idDataIndicateurPastYear);
    if (dataIndicateur.value.entite != "" && dataIndicateur.value.annee != 0) {
      dataBaseController.updateAPIDatabase(idDataIndicateur);
      statusIntialisation.value = true;
      isLoading.value = false;
    } else {
      statusIntialisation.value = false;
      isLoading.value = false;
    }
  }

  Future resetTotal() async {
    List listEntites = [
      "comex", "groupe-sifca", "caoutchouc-naturel", "sifca-holding",
      "oleagineux", "sucre", //6
      "sucrivoire", "sucrivoire-siege", "sucrivoire-borotou-koro",
      "sucrivoire-zuenoula", //4
      "palmci",
      "palmci-siege",
      "palmci-blidouba",
      "palmci-boubo",
      "palmci-ehania",
      "palmci-gbapet",
      "palmci-iboke",
      "palmci-irobo",
      "palmci-neka",
      "palmci-toumanguie", //9
      "sania", "mopp", //3
      "saph", "saph-siege", "saph-bettie", "saph-bongo", "saph-loeth",
      "saph-ph-cc", "saph-rapides-grah", "saph-toupah", "saph-yacoli", //9
      "grel", "grel-tsibu", "grel-apimenim", //3,
      "siph", "crc", "renl" // 3
    ];
    var annnes = [2021, 2022, 2023, 2024, 2025, 2026];

    for (var entite in listEntites) {
      for (var an in annnes) {
        final idDataIndicateur = '${entite}_$an';
        final List datasEntite = await supabase
            .from('DataIndicateur')
            .select()
            .eq('id', idDataIndicateur);
        if (datasEntite.isEmpty) {
          final List<List<num?>> initData = List.generate(
              280,
              (index) => [
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
                  ]).toList();
          await supabase.from('DataIndicateur').insert(
            {
              'id': idDataIndicateur,
              'annee': currentYear.value,
              'entite': entitePilotageController.currentEntite.value,
              "valeurs": initData,
              "validations": initData
            },
          );
          await dataBaseController.updateAPIDatabase(idDataIndicateur);
        }
      }
    }
  }

  Future initialisationDataIndicateur() async {
    final idDataIndicateur =
        '${entitePilotageController.currentEntite.value}_${currentYear.value}';
    final List datasEntite = await supabase
        .from('DataIndicateur')
        .select()
        .eq('id', idDataIndicateur);
    if (datasEntite.isEmpty) {
      final List<List<num?>> initData = List.generate(
          280,
          (index) => [
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
              ]).toList();
      await supabase.from('DataIndicateur').insert(
        {
          'id': idDataIndicateur,
          'annee': currentYear.value,
          'entite': entitePilotageController.currentEntite.value,
          "valeurs": initData,
          "validations": initData
        },
      );
    }
  }
/*
  Future getValeurCibleIndicateur() async {
    final valeurCible = 
  }
  */

  void refreshData() async {
    allYearsList.value = TimeSystemController.years;
    isLoading.value = false;
    //indicateursList.value = await dataBaseController.getAllIndicateur();
    final idDataIndicateur =
        '${entitePilotageController.currentEntite.value}_${currentYear.value}';
    final idDataIndicateurPastYear =
        '${entitePilotageController.currentEntite.value}_${currentYear.value - 1}';
    dataIndicateur.value =
        await dataBaseController.getAllDataRowIndicateur(idDataIndicateur);
    dataIndicateurPastYear.value = await dataBaseController
        .getAllDataRowIndicateur(idDataIndicateurPastYear);
    if (dataIndicateur.value.entite != "" && dataIndicateur.value.annee != 0) {
      statusIntialisation.value = true;
      isLoading.value = false;
    } else {
      statusIntialisation.value = false;
      isLoading.value = false;
    }
  }

  Future updateDataIndicateur() async {
    final idDataIndicateur =
        '${entitePilotageController.currentEntite.value}_${currentYear.value}';
    dataIndicateur.value =
        await dataBaseController.getAllDataRowIndicateur(idDataIndicateur);
  }

  Future<bool> renseignerIndicateurMois(
      {required num valeur,
      required int numeroLigne,
      required int colonne,
      required String type,
      required String formule}) async {
    try {
      final currentEntite = entitePilotageController.currentEntite.value;
      final Map<String, dynamic> data = {
        "annee": currentYear.value,
        "entite": currentEntite,
        "valeur": valeur,
        "ligne": numeroLigne,
        "colonne": colonne,
        "type": type,
        "formule": formule,
      };

      const String apiUrl =
          "${DataBaseController.baseUrl}/data-entite-indicateur/update-data";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Erreur lors de la mise à jour de l'indicateur : $e");
      return false;
    }
  }

  Future<bool> renseignerDataCible(
      {required num dataCible,
      required int numeroLigne,
      required int colonne,
      required String type,
      required String formule}) async {
    try {
      final currentEntite = entitePilotageController.currentEntite.value;
      final Map<String, dynamic> data = {
        "annee": currentYear.value,
        "entite": currentEntite,
        "datacible": dataCible,
        "ligne": numeroLigne,
        "colonne": colonne,
        "type": type,
        "formule": formule,
      };

      const String apiUrl =
          "${DataBaseController.baseUrl}/data-entite-indicateur/compute-performs";

      var idEntite =
          '${entitePilotageController.currentEntite.value}_${currentYear.value}';
      var listCibles =
          await dataBaseController.getCibleListIndicateur(idEntite);
      if (listCibles.isEmpty) {
        listCibles = List.generate(280, (_) => null);
      }
      listCibles[numeroLigne] = dataCible;
      await supabase
          .from('DataIndicateur')
          .update({'cibles': listCibles}).eq('id', idEntite);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Erreur lors de la mise à jour de la cible : $e");
      return false;
    }
  }

  Future<bool> changeStatusEntityIndic(
      {required int? statusIndex, required int numeroLigne}) async {
    try {
      final currentEntite = entitePilotageController.currentEntite.value;
      final Map<String, dynamic> data = {
        "annee": currentYear.value,
        "entite": currentEntite,
        "statusButton": statusIndex,
        "ligne": numeroLigne
      };
      const String apiUrl =
          "${DataBaseController.baseUrl}/data-entite-indicateur/change-entity-indic-status";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Une erreur s'est produite: $e");
      return false;
    }
  }

  Future<bool> validerIndicateurMois(
      {required bool valide,
      required int numeroLigne,
      required int colonne}) async {
    try {
      final currentEntite = entitePilotageController.currentEntite.value;
      final Map<String, dynamic> data = {
        "annee": currentYear.value,
        "entite": currentEntite,
        "valide": valide,
        "ligne": numeroLigne,
        "colonne": colonne
      };

      const String apiUrl =
          "${DataBaseController.baseUrl}/data-entite-indicateur/update-validation";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> annulerValidationMois(
      {required bool valide,
      required int numeroLigne,
      required int colonne}) async {
    try {
      final currentEntite = entitePilotageController.currentEntite.value;
      final Map<String, dynamic> data = {
        "annee": currentYear.value,
        "entite": currentEntite,
        "valide": valide,
        "ligne": numeroLigne,
        "colonne": colonne
      };
      const String apiUrl =
          "${DataBaseController.baseUrl}/data-entite-indicateur/update-validation";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> consolidation(int annee) async {
    final result = await dataBaseController.consolidation(annee);
    return result;
  }

  // Future<bool> modifierStatusIndicEntity(int numeroLigne, List statuList) async {
  //   try{
  //   var idEntite = '${entitePilotageController.currentEntite.value}_${currentYear.value}';
  //   await supabase.from('DataIndicateur').update({'status_entity': statuList}).eq('id', idEntite);
  //   }
  // }

  Future<bool> updateSuiviDate(
      int annee, String? processus, int? numeroLigne, int? colonne) async {
    final currentEntite = entitePilotageController.currentEntite.value;
    await dataBaseController.updateSuiviDataEntite(
        currentEntite, annee, processus, numeroLigne, colonne);
    return true;
  }

  void triggerUpdateDataRow() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 120));
      refreshData();
    }
  }

  @override
  void onInit() async {
    initDateTime();
    triggerUpdateDataRow();
    super.onInit();
  }
}
