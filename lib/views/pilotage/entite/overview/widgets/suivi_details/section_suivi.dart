import 'package:flutter/material.dart';
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "Les Axes Stratégiques",
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
      itemCount: demoPiliers.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
itemBuilder: (context, index) => PilierInfoCard(info: demoPiliers[index], annee: DateTime.now().year,),
    );
  }
}
