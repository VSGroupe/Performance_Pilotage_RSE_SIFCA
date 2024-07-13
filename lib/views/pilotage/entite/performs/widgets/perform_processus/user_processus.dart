import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:perf_rse/utils/i18n.dart';

import 'package:perf_rse/views/pilotage/controllers/profil_pilotage_controller.dart';

class ProcessGrid extends StatelessWidget {
  const ProcessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    final ProfilPilotageController profilPilotageController = Get.find();
    final List<String> processListUser =
        profilPilotageController.accesPilotageModel.value.processus!;
    return GridView.builder(
      itemCount: profilPilotageController.accesPilotageModel.value.processus!
          .length, // nombre de processus a determiner
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2.8,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          hoverColor: Colors.transparent,
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/box${random.nextInt(4) + 1}.png"),
                  fit: BoxFit.fill),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        processListUser[index],
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 34,
                          color: Colors.white,
                        ),
                      ),
                       Text(
                        "90 ${tr.indicators}",
                        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            "90 %",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 34,
                              color: Color.fromARGB(255, 0, 129, 15),
                            ),
                          ),
                          const Icon(
                            Icons.trending_up,
                            color: Color.fromARGB(255, 0, 129, 15),
                            size: 60,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
