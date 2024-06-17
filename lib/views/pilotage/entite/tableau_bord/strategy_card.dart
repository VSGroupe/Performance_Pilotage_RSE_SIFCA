import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/constants/constant_colors.dart';
import 'package:perf_rse/utils/i18n.dart';
import '../../../../widgets/custom_text.dart';
import '../../controllers/drop_down_controller.dart';
import '../../controllers/entite_pilotage_controler.dart';

class StrategieContainer extends StatefulWidget {
  const StrategieContainer({super.key});

  @override
  State<StrategieContainer> createState() => _StrategieContainerState();
}

class _StrategieContainerState extends State<StrategieContainer> {
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 500,
      width: 900,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
              left: 0,
              bottom: 0,
              child: SizedBox(
                width: 400,
                height: 200,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StrategyButton(
                    axeId: "axe_3",
                    color: Color(0xFFFAAF7B),
                    imagePilier: "assets/icons/social.png",
                    titlePilier: tr.axe3,
                    enjeux: [
                      {
                        "key": "7",
                        "enjeu":tr.socialInclusionCommunity
                      },
                    ],
                  ),
                ),
              )),
           Positioned(
              left: 500,
              bottom: 300,
              child: SizedBox(
                width: 400,
                height: 200,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StrategyButton(
                    axeId: "axe_1",
                    color: Color(0xFF3F93D0),
                    imagePilier: "assets/icons/gouvernance.png",
                    titlePilier:tr.axe1,
                    enjeux: [
                      {
                        "key": "1",
                        "enjeu":tr.issue1
                      },
                      {
                        "key": "2",
                        "enjeu": tr.issue2
                      },
                      {
                        "key": "3",
                        "enjeu":tr.issue3
                      },
                    ],
                  ),
                ),
              )),
          Positioned(
              left: 500,
              bottom: 0,
              child: SizedBox(
                width: 400,
                height: 200,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StrategyButton(
                    axeId: "axe_2",
                    color: Color(0xFFEABF64),
                    imagePilier: "assets/icons/economie.png",
                    titlePilier:tr.axe2,
                    enjeux: [
                      {"key": "4", "enjeu": tr.issue4},
                      {"key": "5", "enjeu": tr.issue5},
                      {"key": "10", "enjeu":tr.issue6},
                    ],
                  ),
                ),
              )),
          Positioned(
              left: 0,
              bottom: 300,
              child: SizedBox(
                width: 400,
                height: 200,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StrategyButton(
                    axeId: "axe_4",
                    color: Color(0xFF97C3A8),
                    imagePilier: "assets/icons/environnement.png",
                    titlePilier:tr.environment,
                    enjeux: [
                      {
                        "key": "8",
                        "enjeu": tr.issue8
                      },
                      {"key": "9", "enjeu": tr.issue9},
                      {
                        "key": "10",
                        "enjeu": tr.issue10b
                      },
                    ],
                  ),
                ),
              )),
          const Positioned(left: 375, bottom: 175, child: GeneralButton()),
        ],
      ),
    );
  }
}

class StrategyButton extends StatefulWidget {
  final String axeId;
  final String titlePilier;
  final String imagePilier;
  final List<Map> enjeux;
  final Color color;
  const StrategyButton(
      {super.key,
      required this.titlePilier,
      required this.imagePilier,
      required this.enjeux,
      required this.color,
      required this.axeId});

  @override
  State<StrategyButton> createState() => _StrategyButtonState();
}

class _StrategyButtonState extends State<StrategyButton> {
  final EntitePilotageController entitePilotageController = Get.find();
  final DropDownController dropDownController = Get.find();
  double elevation = 5;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          dropDownController.filtreViewAxe.value = {
            widget.axeId: true,
          };
          context.go(
              "/pilotage/espace/${entitePilotageController.currentEntite.value}/tableau-de-bord/indicateurs");
        },
        onHover: (value) {
          if (value) {
            setState(() {
              elevation = 20;
            });
          } else {
            setState(() {
              elevation = 5;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: widget.color,
        ),
        child: SizedBox(
          width: 400,
          height: 200,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      widget.imagePilier,
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: Text(
                      widget.titlePilier,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                    children: widget.enjeux.map((enjeu) {
                  return InkWell(
                    radius: 10,
                    hoverColor: primaryColor.withOpacity(0.5),
                    onTap: () {
                      dropDownController.filtreViewAxe.value = {
                        "enjeu": true,
                        widget.axeId: true,
                        "enjeu_${enjeu["key"]}": true,
                      };
                      context.go(
                          "/pilotage/espace/${entitePilotageController.currentEntite.value}/tableau-de-bord/indicateurs");
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle),
                                child: Center(child: Text("${enjeu["key"]}")),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                  child: CustomText(
                                text: "${enjeu["enjeu"]}",
                                size: 13,
                                fontStyle: FontStyle.italic,
                              ))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList())
              ],
            ),
          ),
        ));
  }
}

class GeneralButton extends StatefulWidget {
  const GeneralButton({super.key});

  @override
  State<GeneralButton> createState() => _GeneralButtonState();
}

class _GeneralButtonState extends State<GeneralButton> {
  final EntitePilotageController entitePilotageController = Get.find();
  final DropDownController dropDownController = Get.find();
  double elevation = 5;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        dropDownController.filtreViewAxe.value = {
          "axe_0": true,
          "axe_1": true,
          "axe_2": true,
          "axe_3": true,
          "axe_4": true
        };
        context.go(
            "/pilotage/espace/${entitePilotageController.currentEntite.value}/tableau-de-bord/indicateurs");
      },
      onHover: (value) {
        if (value) {
          setState(() {
            elevation = 20;
          });
        } else {
          setState(() {
            elevation = 5;
          });
        }
      },
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          elevation: elevation,
          backgroundColor: Colors.brown,
          padding: EdgeInsets.zero),
      child: SizedBox(
          width: 150,
          height: 150,
          child: Container(
            width: 50,
            height: 50,
            color: Colors.transparent,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: tr.show,
                  color: Colors.white,
                  size: 18,
                ),
                CustomText(
                  text:tr.all,
                  color: Colors.white,
                  size: 18,
                ),
                CustomText(
                  text:tr.indicators,
                  color: Colors.white,
                  size: 18,
                )
              ],
            ),
          )),
    );
  }
}
