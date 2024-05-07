
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';


enum LegendShape { circle, rectangle }

class PieChartEvaluation extends StatefulWidget {
  final Map<String,double> dataMap;
  final Map <String,String>legendLabels;
  final List<Color>listColorLegends;
  final ChartType? chartType;
  final LegendPosition legendPosition;
  const PieChartEvaluation({Key? key, required this.dataMap, required this.legendLabels, required this.listColorLegends, required this.chartType, required this.legendPosition}) : super(key: key);

  @override
  PieChartEvaluationState createState() => PieChartEvaluationState();
}

class PieChartEvaluationState extends State<PieChartEvaluation> {


  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ]
  ];
  double? _ringStrokeWidth = 20;
  double? _chartLegendSpacing = 8;

  bool _showLegendsInRow = false;
  bool _showLegends = true;
  bool _showLegendLabel = false;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  bool _showGradientColors = false;


  @override
  Widget build(BuildContext context) {
    final chart = PieChart(
      dataMap: widget.dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: _chartLegendSpacing!,
      chartRadius: 200,
      colorList: widget.listColorLegends,
      initialAngleInDegree: 0,
      chartType: widget.chartType!,
      legendLabels: widget.legendLabels,
      legendOptions: LegendOptions(
        showLegendsInRow: _showLegendsInRow,
        legendPosition: widget.legendPosition!,
        showLegends: _showLegends,
        legendShape: BoxShape.rectangle,
        legendTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: _showChartValueBackground,
        showChartValues: _showChartValues,
        showChartValuesInPercentage: _showChartValuesInPercentage,
        showChartValuesOutside: _showChartValuesOutside,
      ),
      ringStrokeWidth: _ringStrokeWidth!,
      emptyColor: Colors.grey,
      gradientList: _showGradientColors ? gradientList : null,
      emptyColorGradient: const [
        Color(0xff6c5ce7),
        Colors.blue,
      ],
      baseChartColor: Colors.transparent,
    );
            return Container(
              child: chart,
            );
  }
}

class HomePage2 extends StatelessWidget {
  HomePage2({Key? key}) : super(key: key);

  final dataMap = <String, double>{
    "Flutter": 5,
  };

  final colorList = <Color>[
    Colors.greenAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PieChart(
          dataMap: dataMap,
          chartType: ChartType.ring,
          baseChartColor: Colors.grey[50]!.withOpacity(0.15),
          colorList: colorList,
          chartValuesOptions: const ChartValuesOptions(
            showChartValuesInPercentage: true,
          ),
          totalValue: 20,
        ),
    );
  }
}