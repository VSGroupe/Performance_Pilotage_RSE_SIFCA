import 'dart:typed_data';

import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:supabase_flutter/supabase_flutter.dart';

class EntitePilotageController extends GetxController {
  Uint8List? bytesLogo;
  final currentEntite = "".obs;
  final filialeCurrentEntity = "".obs;
  final filiereCurrentEntity = "".obs;
  final entityAppartenance = "".obs;
  final sousEntite = [].obs;
  final sousEntiteName = [].obs;
  final supabase = Supabase.instance.client;
  final entites = [].obs;
  var langue = "";

  Future<Uint8List?> downloadImageAsUint8List(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Uint8List? bytes = response.bodyBytes;
        bytesLogo = bytes;
        return bytes;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> initialisation() async {
    try {
      final response = await supabase.from('Entites').select();
      entites.value = response;
      if (entites.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Map getCurrentEntiteRes() {
    for (var entite in entites) {
      if (entite["id_entite"] == currentEntite.value) {
        return entite;
      }
    }
    return {};
  }
}

class EntiteModel {
  String idEntite;
  String nomEntite;
  String entiteAbr;
  String estConsolide;
  List<String> sousEntites;
  String logo;
  String couleur;
  String addresse;
  String pays;
  String ville;
  String langue;
  String filiale;
  String filiere;
  bool blockCreatingData;
  String groupe;

  EntiteModel({
    required this.idEntite,
    required this.nomEntite,
    required this.entiteAbr,
    required this.estConsolide,
    required this.sousEntites,
    required this.logo,
    required this.couleur,
    required this.addresse,
    required this.pays,
    required this.ville,
    required this.langue,
    required this.filiale,
    required this.filiere,
    required this.blockCreatingData,
    required this.groupe,
  });

  factory EntiteModel.fromRawJson(String str) =>
      EntiteModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EntiteModel.fromJson(Map<String, dynamic> json) => EntiteModel(
      idEntite: json["id_entite"],
      nomEntite: json["nom_entite"],
      entiteAbr: json["entite_abr"],
      estConsolide: json["est_consolide"],
      sousEntites: List<String>.from(json["sous_entites"].map((x) => x)),
      logo: json["logo"],
      couleur: json["couleur"],
      addresse: json["addresse"],
      pays: json["pays"],
      ville: json["ville"],
      langue: json["langue"],
      filiale: json["filiale"],
      filiere: json["filiere"],
      blockCreatingData: json["block_creating_data"],
      groupe: json["groupe"]);

  Map<String, dynamic> toJson() => {
        "id_entite": idEntite,
        "nom_entite": nomEntite,
        "entite_abr": entiteAbr,
        "est_consolide": estConsolide,
        "sous_entites": List<dynamic>.from(sousEntites.map((x) => x)),
        "logo": logo,
        "couleur": couleur,
        "addresse": addresse,
        "pays": pays,
        "ville": ville,
        "langue": langue,
        "filiale": filiale,
        "filiere": filiere,
        "groupe": groupe,
      };
}
