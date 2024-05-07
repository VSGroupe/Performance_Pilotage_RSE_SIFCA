import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/api/supabse_db.dart';
import 'package:perf_rse/models/pilotage/data_indicateur_row_model.dart';
import 'package:perf_rse/models/pilotage/indicateur_model.dart';
import 'package:perf_rse/views/pilotage/controllers/entite_pilotage_controler.dart';
import 'package:perf_rse/views/pilotage/controllers/profil_pilotage_controller.dart';

class PerformsDataController extends GetxController {
  final indicateursList = <IndicateurModel>[].obs;
  final dataIndicateur = DataIndicateurRowModel.init().obs;
  final DataBaseController dataBaseController = DataBaseController();
  final EntitePilotageController entitePilotageController = Get.find();
  final ProfilPilotageController profilPilotageController = Get.find();
  var listOfDatasAmongYears = [];

  void initialisation(BuildContext context) async {
    List<String>? processListUser =
        profilPilotageController.accesPilotageModel.value.processus;
    indicateursList.value =
        await dataBaseController.getProcessUserIndicators(processListUser!);
    for (int i = 2022; i <= DateTime.now().year; i++) {
      final idDataIndicateur =
          '${entitePilotageController.currentEntite.value}_$i';
      dataIndicateur.value =
          await dataBaseController.getAllDataRowIndicateur(idDataIndicateur);
      listOfDatasAmongYears.add(dataIndicateur.value);
    }
  }

  final annee = 0.obs;
  final isLoading = false.obs;

  void loadDataPerforms(int an) async {
    isLoading.value = true;
    annee.value = an;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }

  void initDate() {
    annee.value = DateTime.now().year;
  }

  @override
  void onInit() {
    initDate();
    super.onInit();
  }
}
