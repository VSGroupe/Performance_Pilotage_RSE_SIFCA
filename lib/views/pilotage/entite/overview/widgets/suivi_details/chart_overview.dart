import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';

import '../../../../../../constants/constant_double.dart';

class ChartOverview extends StatefulWidget {
  final int nombreTotal;
  final int numberVide;
  final int numberCollecte;
  const ChartOverview({
    Key? key, required this.nombreTotal, required this.numberVide, required this.numberCollecte,
  }) : super(key: key);

  @override
  State<ChartOverview> createState() => _ChartOverviewState();
}

class _ChartOverviewState extends State<ChartOverview> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 70,
                startDegreeOffset: -90,
                sections: showingSections(),
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                )),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Text(
                  "${widget.numberCollecte}",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text("(${tr.collectedValidated})",style: Theme.of(context).textTheme.bodySmall,),
                Text("${tr.on} ${widget.nombreTotal}  ${tr.indicators}",style: Theme.of(context).textTheme.bodyMedium,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 22.0 : 15.0;
      final radius = isTouched ? 40.0 : 30.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
              color: Colors.amber,
              value: widget.numberCollecte.toDouble(),
              title: '${widget.numberCollecte}',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              )
          );
        case 1:
          return PieChartSectionData(
              color: Colors.red,
              value: widget.numberVide.toDouble(),
              title: '${widget.numberVide}',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              )
          );
        default:
          throw Error();
      }
    });
  }
}

