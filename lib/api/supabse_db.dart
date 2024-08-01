import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:perf_rse/views/pilotage/controllers/entite_pilotage_controler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/pilotage/data_indicateur_row_model.dart';
import '../models/pilotage/indicateur_model.dart';
import '../models/common/user_model.dart';
import '../models/pilotage/acces_pilotage_model.dart';

class DataBaseController {
  final supabase = Supabase.instance.client;
  final EntitePilotageController entitePilotageController = Get.find();

  static const baseUrl =
      "http://127.0.0.1:5000"; //http://127.0.0.1:5000 // https://api-performance-rse-sifca-xrk2.onrender.com

  Future<List<IndicateurModel>> getAllIndicateur() async {
    final List<dynamic> docs = await supabase
        .from('Indicateurs')
        .select()
        .order('reference', ascending: true);
    final indicateurs =
        docs.map((json) => IndicateurModel.fromJson(json)).toList();
    return indicateurs;
  }

  Future<List<IndicateurModel>> getAllIndicateurEN() async {
    final List<dynamic> docs = await supabase
        .from('Indicateurs_en')
        .select()
        .order('reference', ascending: true);
    final indicateurs =
        docs.map((json) => IndicateurModel.fromJson(json)).toList();
    return indicateurs;
  }

  Future<List<IndicateurModel>> getProcessUserIndicators(
      List<String> UserProcessList) async {
    final List<dynamic> docs = await supabase
        .from('Indicateurs')
        .select()
        .inFilter('processus', UserProcessList);

    final UserIndicators =
        docs.map((json) => IndicateurModel.fromJson(json)).toList();
    return UserIndicators;
  }

  //recuprer valeur de la cible de l'indicateur
  // Future<List<dynamic>> getCibleListIndicateur(String id) async {
  //   try {
  //     final List<dynamic> response =
  //         await supabase.from('DataIndicateur').select('cibles').eq('id', id);
  //     final data = response[0];
  //     final result = data["cibles"];
  //     return result;
  //   } catch (e) {
  //     print('Error fetching cible value:$e');
  //     return [];
  //   }
  // }

  Future<DataIndicateurRowModel> getAllDataRowIndicateur(
      String idDataIndicateur) async {
    try {
      final List<dynamic> datas = await supabase
          .from('DataIndicateur')
          .select()
          .eq('id', idDataIndicateur);

      if (datas.isEmpty) {
        return DataIndicateurRowModel.init();
      }

      final data = datas[0];
      final result = DataIndicateurRowModel(
          entite: data["entite"],
          annee: data["annee"],
          valeurs: data["valeurs"],
          validations: data["validations"],
          ecarts: data["ecarts"],
          cibles: data["cibles"],
          statusEntity: data["status_entity"]);
      return result;
    } catch (e) {
      return DataIndicateurRowModel.init();
    }
  }

  Future<bool> updateAPIDatabase(String id) async {
    final Map<String, dynamic> data = {"id": id};

    const String apiUrl =
        "$baseUrl/data-entite-indicateur/update-data-from-supabase";

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
  }

  Future<bool> updateSuiviDataEntite(String entite, int annee,
      String? processus, int? numeroLigne, int? colonne) async {
    final Map<String, dynamic> data = {
      "entite": entite,
      "annee": annee,
      "processus": processus,
      "numeroLigne": numeroLigne,
      "colonne": colonne,
    };

    //print("$entite updating");

    const String apiUrl = "$baseUrl/data-entite-suivi";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    //print(response.statusCode);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> consolidation(int annee) async {
    final Map<String, dynamic> data = {"annee": annee};

    const String apiUrl = "$baseUrl/data-entite-indicateur/consolidation";

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
  }

  Future<Map<String, dynamic>?> getExportEntite(
      String entite, int annee) async {

    List sousEntites = entitePilotageController.sousEntite;

    final Map<String, dynamic> data = {
      "annee": annee,
      "entiteId": entite,
      "sousEntites": sousEntites
    };

    const String apiUrl = "$baseUrl/data-entite-indicateur/export-all-data";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      return null;
    }
  }

  Future<List<UserModel>> getAllUser() async {
    final List<Map<dynamic, dynamic>> docUsers =
        await supabase.from('Users').select();
    final users = docUsers.map((json) => UserModel.fromJson(json)).toList();
    return users;
  }

  Future<bool> updateUser(
      {required String email,
      required String nom,
      required String prenom,
      required String titre,
      required String ville,
      required String adresse,
      required String fonction,
      required String numero,
      required String pays}) async {
    try {
      await Supabase.instance.client.from('Users').update({
        'nom': nom,
        'prenom': prenom,
        'titre': titre,
        'ville': ville,
        'addresse': adresse,
        'fonction': fonction,
        'numero': numero,
        'pays': pays
      }).eq('email', email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePasswordUser(
      {required String email, required String checkPassWord}) async {
    try {
      await supabase.auth.updateUser(UserAttributes(
        email: email,
        password: checkPassWord,
      ));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserLanguage(
      {required String email, required String langue}) async {
    try {
      if (langue.isNotEmpty) {
        await Supabase.instance.client
            .from('Users')
            .update({'langue': langue}).eq('email', email);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<AccesPilotageModel>> getAllUsersAccesPilotage() async {
    final List<Map<dynamic, dynamic>> docAcces =
        await supabase.from('AccesPilotage').select();
    final accesPilotage =
        docAcces.map((json) => AccesPilotageModel.fromJson(json)).toList();
    return accesPilotage;
  }

  Future<void> addUsersAccesPilotage(
      {required email, required password, required data}) async {
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
      );
      supabase.from('Users').insert(data);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
