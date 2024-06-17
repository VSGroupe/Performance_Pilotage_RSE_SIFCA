import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/views/pilotage/entite/overview/widgets/suivi_details/collectes_mensuelles.dart';
import 'package:perf_rse/views/pilotage/entite/overview/widgets/suivi_details/collectes_processus.dart';
import '../../../../constants/constant_double.dart';
import '../../../../widgets/custom_text.dart';
import 'widgets/suivi_details/collecte_globale_filiale.dart';
import 'widgets/suivi_details/section_suivi.dart';
import 'widgets/contributeur/liste_contributeur.dart';

class OverviewPilotage extends StatelessWidget {
  const OverviewPilotage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
            flex: 5,
            child: Column(
              children: [
                SectionSuivi(),
                SizedBox(height: defaultPadding),
                ListeContributeur()
              ],
            )),
        const SizedBox(width: defaultPadding),
        SizedBox(
          width: 320,
          height: 1000,
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              CustomText(
                text:tr.collectionProgress,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: defaultPadding),
             const  CollecteByProcessus(),
             const  CollecteMensuelleEntites(),
              //SizedBox(height: defaultPadding),
              const CollecteGlobaleEntites()
            ],
          ),
        ),
        const SizedBox(width: defaultPadding),
      ],
    );
  }
}
