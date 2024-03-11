import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../controllers/performs_data_controller.dart';
import 'package:get/get.dart';
import '../../../../controllers/entite_pilotage_controler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerformanceEnjeux extends StatefulWidget {
  const PerformanceEnjeux({Key? key}) : super(key: key);

  @override
  State<PerformanceEnjeux> createState() => _PerformanceEnjeuxState();
}

class _PerformanceEnjeuxState extends State<PerformanceEnjeux> {
  late double _columnWidth;
  late double _columnSpacing;
  List<ChartSampleData>? chartData;
  TooltipBehavior? _tooltipBehavior;
  bool _isLoaded = false;
  bool isCardView = true;
  String entiteName = "";

  final supabase = Supabase.instance.client;
  final PerformsDataController performsDataController = Get.find();
  final EntitePilotageController entitePilotageController = Get.find();

  void initialisationPerformsEnjeux() async {
    final entiteID = entitePilotageController.currentEntite.value;
    final idPerformsA = "${entiteID}_${performsDataController.annee.value}";
    final idPerformsB = "${entiteID}_${performsDataController.annee.value - 1}";
    final List performsDataListA =
        await supabase.from('Performance').select().eq('id', idPerformsA);
    final List performsDataListB =
        await supabase.from('Performance').select().eq('id', idPerformsB);
    // final List<dynamic> entite = await supabase
    //     .from('Entites')
    //     .select('nom_entite')
    //     .eq('id_entite', entiteID);
    // var entiteVal = entite.first["nom_entite"];
    // setState(() {
    //   entiteName = entiteVal;
    // });

    final datasEnjeuA = performsDataListA.first["performs_enjeux"];
    final datasEnjeuB = performsDataListB.first["performs_enjeux"];

    final datasEnjeuListA = calculPerforms(datasEnjeuA);
    final datasEnjeuListB = calculPerforms(datasEnjeuB);

    _columnWidth = 0.8;
    _columnSpacing = 0.2;
    _tooltipBehavior = TooltipBehavior(enable: true);
    chartData = <ChartSampleData>[
      ChartSampleData(
          x: '1.a Gouvernance DD et stratégie',
          y: datasEnjeuListB[0] ?? 0,
          secondSeriesYValue: datasEnjeuListA[0] ?? 0,
          thirdSeriesYValue: 13),
      ChartSampleData(
          x: '1.b Pilotage DD',
          y: datasEnjeuListB[1] ?? 0,
          secondSeriesYValue: datasEnjeuListA[1] ?? 0,
          thirdSeriesYValue: 5),
      ChartSampleData(
          x: '2. Éthique des affaires et achats responsables',
          y: datasEnjeuListB[2] ?? 0,
          secondSeriesYValue: datasEnjeuListA[2] ?? 0,
          thirdSeriesYValue: 14),
      ChartSampleData(
          x: '3. Intégration des attentes DD des clients et consommateurs',
          y: datasEnjeuListB[3] ?? 0,
          secondSeriesYValue: datasEnjeuListA[3] ?? 0,
          thirdSeriesYValue: 13),
      ChartSampleData(
          x: '4. Égalité de traitement',
          y: datasEnjeuListB[4] ?? 0,
          secondSeriesYValue: datasEnjeuListA[4] ?? 0,
          thirdSeriesYValue: 7),
      ChartSampleData(
          x: '5. Conditions de travail',
          y: datasEnjeuListB[5] ?? 0,
          secondSeriesYValue: datasEnjeuListA[5]  ?? 0,
          thirdSeriesYValue: 5),
      ChartSampleData(
          x: '6. Amélioration du cadre de vie',
          y: datasEnjeuListB[6] ?? 0,
          secondSeriesYValue: datasEnjeuListA[6] ?? 0,
          thirdSeriesYValue: 14),
      ChartSampleData(
          x: '7. Inclusion sociale et développement des communautés',
          y: datasEnjeuListB[7] ?? 0,
          secondSeriesYValue: datasEnjeuListA[7] ?? 0,
          thirdSeriesYValue: 13),
      ChartSampleData(
          x: '8. Changement climatique et déforestation',
          y: datasEnjeuListB[8] ?? 0,
          secondSeriesYValue: datasEnjeuListA[8] ?? 0,
          thirdSeriesYValue: 7),
      ChartSampleData(
          x: '9. Gestion et traitement de l’eau',
          y: datasEnjeuListB[9] ?? 0,
          secondSeriesYValue: datasEnjeuListA[9] ?? 0,
          thirdSeriesYValue: 5),
      ChartSampleData(
          x: '10. Gestion des ressources et déchets',
          y: datasEnjeuListB[10]  ?? 0,
          secondSeriesYValue: datasEnjeuListA[10] ?? 0,
          thirdSeriesYValue: 14)
    ];
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    initialisationPerformsEnjeux();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? _buildSpacingColumnChart()
        : const Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                    strokeWidth: 4,
                  )),
              SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                      color: Colors.amber, strokeWidth: 4)),
            ],
          );
  }

  SfCartesianChart _buildSpacingColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: 'PERFORMANCE PAR ENJEU PRIORITAIRE',
          textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              decoration: TextDecoration.underline)),
      primaryXAxis: CategoryAxis(
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        title: AxisTitle(
            text: "Les enjeux prioritaires",
            textStyle: const TextStyle(fontSize: 18)),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          labelAlignment: LabelAlignment.center,
          title: AxisTitle(
              text: "Performance en %",
              textStyle: const TextStyle(fontSize: 18)),
          maximum: 100,
          minimum: 0,
          interval: 5,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumn(),
      legend: Legend(isVisible: true),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  ///Get the column series
  List<BarSeries<ChartSampleData, String>> _getDefaultColumn() {
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(

          /// To apply the column width here.
          width: isCardView ? 0.8 : _columnWidth,

          /// To apply the spacing betweeen to two columns here.
          spacing: isCardView ? 0.2 : _columnSpacing,
          dataSource: chartData!,
          color: const Color.fromRGBO(177, 183, 188, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: '${performsDataController.annee.value - 1}'),
      BarSeries<ChartSampleData, String>(
          dataSource: chartData!,
          width: isCardView ? 0.8 : _columnWidth,
          spacing: isCardView ? 0.2 : _columnSpacing,
          color: Colors.blue,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: '${performsDataController.annee.value}'),
    ];
  }

  List calculPerforms(List listdata) {
    if (listdata.isEmpty) {
      return [];
    }

    //List result = [];
    for (var element in listdata) {
      if (element != null) {
        //result.add(-element + 100);
        listdata[listdata.indexOf(element)] = -element + 100;
      }
    }
    return listdata;
  }

  @override
  void dispose() {
    //chartData!.clear();
    super.dispose();
  }
}

class ChartSampleData {
  final String x;
  final double y;
  final double secondSeriesYValue;
  final double thirdSeriesYValue;
  ChartSampleData({
    required this.thirdSeriesYValue,
    required this.x,
    required this.y,
    required this.secondSeriesYValue,
  });
}
