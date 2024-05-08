import 'dart:convert';


class IndicateurModel {
  final int numero;
  final String reference;
  final String terminologie;
  final String axe;
  final String enjeu;
  final String intitule;
  final String definition;
  final String unite;
  final String type;
  final String? gri;
  final String? odd;
  final String? formule;
  final String? processus;
  final String? frequence;


  IndicateurModel(
      {required this.numero,
      required this.reference,
      required this.terminologie,
      required this.axe,
      required this.enjeu,
      required this.intitule,
      required this.definition,
      required this.unite,
      required this.type,
      required this.gri,
      required this.odd,
      required this.formule,
      required this.processus,
      required this.frequence,});


  factory IndicateurModel.fromRawJson(String str) =>
      IndicateurModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

factory IndicateurModel.fromJson(Map<String, dynamic> json) =>

  IndicateurModel(
    numero: json["numero"],
    reference: json["reference"],
    terminologie: json["terminologie"],
    axe: json["axe"],
    enjeu: json["enjeu"],
    intitule: json["intitule"],
    definition: json["definition"],
    unite: json["unite"],
    type: json["type"],
    gri: json["gri"],
    odd: json["odd"],
    formule: json["formule"],
    processus: json["processus"],
    frequence: json["frequence"],
  );

  Map<String, dynamic> toJson() => {
        "numero": numero,
        "reference": reference,
        "terminologie": terminologie,
        "axe": axe,
        "enjeu": enjeu,
        "intitule": intitule,
        "definition": definition,
        "unite": unite,
        "type": type,
        "gri": gri,
        "odd": odd,
        "formule": formule,
        "processus": processus,
        "frequence": frequence,
      };
}
