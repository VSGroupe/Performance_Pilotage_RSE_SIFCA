import 'package:get/get.dart';

import '../../../api/supabse_db.dart';
import 'entite_pilotage_controler.dart';

class SuiviDataController extends GetxController {

  final annee = 0.obs;
  final isLoading = false.obs;
  final dataSuivi = <Map<String,dynamic>>{}.obs;
  final DataBaseController apiClient =  DataBaseController();
  final EntitePilotageController entitePilotageController = Get.find();

  void updateDateSuivi() async {
    final entite = entitePilotageController.currentEntite.value;
    await apiClient.updateSuiviDataEntite(entite,annee.value, null, null, null);
  }

  void loadDataSuivi(int an) async {
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
    updateDateSuivi();
    super.onInit();
  }

}