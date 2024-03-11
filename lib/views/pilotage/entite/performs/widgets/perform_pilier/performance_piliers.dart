import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import '../../../../controllers/performs_data_controller.dart';
import '../../../../controllers/entite_pilotage_controler.dart';

class PerformancePiliers extends StatefulWidget {
  const PerformancePiliers({Key? key}) : super(key: key);

  @override
  State<PerformancePiliers> createState() => _PerformancePiliersState();
}

class _PerformancePiliersState extends State<PerformancePiliers> {
  late double _columnWidth;
  late double _columnSpacing;
  List<ChartSampleData>? chartData;
  TooltipBehavior? _tooltipBehavior;
  bool _isLoaded = false;
  bool isCardView = true;
  String entiteName = "";

  final supabase = Supabase.instance.client;
  final EntitePilotageController entitePilotageController = Get.find();
  final PerformsDataController performsDataController = Get.find();

  void initialisationPerformsPiliers() async {
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

    final datasPilierA = performsDataListA.first["performs_piliers"];
    final datasPilierB = performsDataListB.first["performs_piliers"];

    final datasPilierListA = calculPerforms(datasPilierA);
    final datasPilierListB = calculPerforms(datasPilierB);

    _columnWidth = 0.8;
    _columnSpacing = 0.2;
    _tooltipBehavior = TooltipBehavior(enable: true);
    chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Gouvernance',
          y: datasPilierListB[0] ?? 0,
          secondSeriesYValue:
              datasPilierListA[0] ?? 0,
          thirdSeriesYValue: 13),
      ChartSampleData(
          x: 'Emploi',
          y: datasPilierListB[1] ?? 0,
          secondSeriesYValue:
              datasPilierListA[1] ?? 0,
          thirdSeriesYValue: 7),
      ChartSampleData(
          x: 'Société', y: datasPilierListB[2] ?? 0, secondSeriesYValue: datasPilierListA[2] ?? 0, thirdSeriesYValue: 5),
      ChartSampleData(
          x: 'Environnement',
          y: datasPilierListB[3] ?? 0,
          secondSeriesYValue: datasPilierListA[3] ?? 0,
          thirdSeriesYValue: 14)
    ];
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    initialisationPerformsPiliers();
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
          text: 'PERFORMANCE PAR AXE STRATEGIQUE',
          textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              decoration: TextDecoration.underline)),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: "Les axes stratégiques"),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: "Performance en %"),
          maximum: 100,
          minimum: 0,
          interval: 1,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumn(),
      legend: Legend(isVisible: true),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  ///Get the column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumn() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(

          /// To apply the column width here.
          width: isCardView ? 0.8 : _columnWidth,

          /// To apply the spacing betweeen to two columns here.
          spacing: isCardView ? 0.2 : _columnSpacing,
          dataSource: chartData!,
          color: const Color.fromRGBO(177, 183, 188, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: '${performsDataController.annee.value - 1}'),
      ColumnSeries<ChartSampleData, String>(
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
