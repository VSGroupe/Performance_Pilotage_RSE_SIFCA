import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:perf_rse/models/pilotage/acces_pilotage_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/pilotage/contributeur_model.dart';
import '../../../utils/utils.dart';
import 'entite_pilotage_controler.dart';

class OverviewPilotageController extends GetxController {
  final EntitePilotageController entitePilotageController = Get.find();
  final supabase = Supabase.instance.client;

  var contributeurs = <ContributeurModel>[].obs;

  Future<bool> getAllUserEntite() async {
    try {
      List<ContributeurModel> listUserEntite = [];
      const storage = FlutterSecureStorage();
      String? email = await storage.read(key: 'email');
      if (email == null) {
        return false;
      }

      List resultEntreprise = await supabase
          .from('Entites')
          .select('filiale')
          .eq("id_entite", entitePilotageController.currentEntite.value);
      final entreprise = resultEntreprise.first["filiale"];

      final usersList = await supabase
          .from('Users')
          .select()
          .contains("entreprise", ["$entreprise"]);
      final List<Map<String, dynamic>> accesPilotagesList =
          await supabase.from('AccesPilotage').select();

      for (var user in usersList) {
        final accesPilotageJson = accesPilotagesList.firstWhere(
            (element) => element["email"] == user["email"],
            orElse: () => {});
        List userEntities = accesPilotageJson["entite"];

        if (accesPilotageJson["est_editeur"] != true ||
            !userEntities.contains(entitePilotageController.currentEntite.value)) {
          continue;
        }

        final resultEntites = accesPilotageJson == null
            ? "----"
            : accesPilotageJson["nom_entite"];

        final entite = concatenationListe(resultEntites);

        final acces = accesPilotageJson != null
            ? getAccesTypeUtils(AccesPilotageModel.fromJson(accesPilotageJson))
            : "---";
        final resultProcessus =
            concatenationListe(accesPilotageJson["processus"]);
        final resultFiliale = concatenationListe(user["entreprise"]);

        final kUser = ContributeurModel(
          entite: "$entite",
          nom: user["nom"],
          prenom: user["prenom"],
          access: acces,
          filiale: "$resultFiliale",
          processus: "$resultProcessus",
        );
        listUserEntite.add(kUser);
      }
      contributeurs.value = listUserEntite;
      //print(listUserEntite.length);

      if (contributeurs.isEmpty) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  String concatenationListe(List liste) {
    List<String> strings = liste.map((e) => e.toString()).toList();
    return strings.join(", ");
  }
}
