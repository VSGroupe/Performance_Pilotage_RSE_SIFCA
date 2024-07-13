import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';
import '../../../../../../constants/constant_double.dart';
import '../../../../../../helper/responsive.dart';
import 'pilier_model.dart';
import 'pilier_info_card.dart';

class StrategyInfoCard extends StatelessWidget {
  const StrategyInfoCard({
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
            Text(tr.strategicAxes,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: PilierInfoCardGridView(
            crossAxisCount: size.width < 650 ? 2 : 4,
            childAspectRatio: size.width < 650 ? 1.3 : 1,
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
      itemBuilder: (context, index) => PilierInfoCard(info:  tr.abrLange.toLowerCase()=='en' ? enDemoPiliers[index] :demoPiliers[index] ,annee: DateTime.now().year,),
    );
  }
}
