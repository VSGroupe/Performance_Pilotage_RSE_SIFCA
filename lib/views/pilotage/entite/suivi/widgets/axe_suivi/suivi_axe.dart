import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/utils/i18n.dart';

import '../../../../../../constants/constant_double.dart';
import '../../../../../../helper/responsive.dart';
import '../../../../../../widgets/custom_text.dart';
import '../../../../controllers/suivi_data_controller.dart';
import '../../../overview/widgets/strategy_info/pilier_info_card.dart';
import '../../../overview/widgets/strategy_info/pilier_model.dart';

class SuiviAxe extends StatefulWidget {
  const SuiviAxe({
    Key? key,
  }) : super(key: key);

  @override
  State<SuiviAxe> createState() => _SuiviAxeState();
}

class _SuiviAxeState extends State<SuiviAxe> {
  final SuiviDataController suiviDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => CustomText(
                  text:
                      "${tr.strategicAxes} ,${tr.year} ${suiviDataController.annee.value}",
                  weight: FontWeight.bold,
                ))
          ],
        ),
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: PilierInfoCardGridView(
            crossAxisCount: size.width < 650 ? 2 : 4,
            childAspectRatio: size.width < 650 && size.width > 350 ? 1.3 : 1,
          ),
          tablet: const PilierInfoCardGridView(),
          desktop: PilierInfoCardGridView(
            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class PilierInfoCardGridView extends StatefulWidget {
  const PilierInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<PilierInfoCardGridView> createState() => _PilierInfoCardGridViewState();
}

class _PilierInfoCardGridViewState extends State<PilierInfoCardGridView> {
  final SuiviDataController suiviDataController = Get.find();

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tr.abrLange.toLowerCase()=='en'  ?  enDemoPiliers.length : demoPiliers.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => Obx(() =>
      PilierInfoCard(
                info:  tr.abrLange.toLowerCase()=='en' ? enDemoPiliers[index] :demoPiliers[index],
                annee: suiviDataController.annee.value,
              )
      ),
    );
  }
}
