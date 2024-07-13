import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';
import '../../../../../../constants/constant_double.dart';
import '../../../../../../helper/responsive.dart';
import '../../../../../../widgets/custom_text.dart';
import '../strategy_info/pilier_model.dart';
import '../strategy_info/pilier_info_card.dart';

class SectionSuivi extends StatelessWidget {
  const SectionSuivi({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text:tr.strategicAxes,
              weight: FontWeight.bold,
            ),
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

class PilierInfoCardGridView extends StatelessWidget {
  const PilierInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount:  tr.abrLange.toLowerCase()=='en'  ?  enDemoPiliers.length : demoPiliers.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
itemBuilder: (context, index) => PilierInfoCard(info: tr.abrLange.toLowerCase()=='en' ? enDemoPiliers[index] :demoPiliers[index], annee: DateTime.now().year,),
    );
  }
}
