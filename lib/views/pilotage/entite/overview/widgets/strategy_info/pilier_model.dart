import 'package:flutter/material.dart';


class PilierInfoModel {
  final String axeId;
  final String? svgSrc, title;
  final Color? color;


  PilierInfoModel({
    required this.axeId,
    this.svgSrc,
    this.title,
    this.color,
  });
}

List demoPiliers = [
  PilierInfoModel(
    axeId : "axe_1",
    title: "GOUVERNANCE ET ÉTHIQUE",
    svgSrc: "assets/icons/gouvernance.png",
    color: Colors.purple,
  ),
  PilierInfoModel(
    axeId : "axe_2",
    title: "EMPLOI ET CONDITIONS DE TRAVAIL",
    svgSrc: "assets/icons/economie.png",
    color: const Color(0xFF007EE5),
  ),
  PilierInfoModel(
    axeId : "axe_3",
    title: "COMMUNAUTES ET INNOVATION SOCIETALE",
    svgSrc: "assets/icons/social.png",
    color: Colors.amber,
  ),
  PilierInfoModel(
    axeId : "axe_4",
    title: "PRESERVATION DE L'ENVIRONNEMENT",
    svgSrc: "assets/icons/environnement.png",
    color: Colors.green,
  ),
];

List enDemoPiliers = [
  PilierInfoModel(
    axeId : "axe_1",
    title: "GOVERNANCE AND ETHICS",
    svgSrc: "assets/icons/gouvernance.png",
    color: Colors.purple,
  ),
  PilierInfoModel(
    axeId : "axe_2",
    title: "EMPLOYMENT AND WORKING CONDITIONS",
    svgSrc: "assets/icons/economie.png",
    color: const Color(0xFF007EE5),
  ),
  PilierInfoModel(
    axeId : "axe_3",
    title: "COMMUNITIES AND SOCIAL INNOVATION",
    svgSrc: "assets/icons/social.png",
    color: Colors.amber,
  ),
  PilierInfoModel(
    axeId : "axe_4",
    title: "PRESERVATION OF THE ENVIRONMENT",
    svgSrc: "assets/icons/environnement.png",
    color: Colors.green,
  ),
];
