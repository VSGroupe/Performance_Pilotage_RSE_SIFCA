import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../controllers/entite_pilotage_controler.dart';
import '../../../../controllers/suivi_data_controller.dart';

class SuiviMensuel extends StatefulWidget {
  const SuiviMensuel({super.key});

  @override
  State<SuiviMensuel> createState() => _SuiviMensuelState();
}

class _SuiviMensuelState extends State<SuiviMensuel> {
  double isHovering = 3;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: (){},
      onHover: (value){
        if(value){
          setState(() {
            isHovering = 10;
          });
        }else {
          setState(() {
            isHovering =3;
          });
        }
      },
      child: Card(
        elevation: isHovering,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 505,
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          child: const SuiviMensuelChart(),
        ),
      ),
    );
  }
}

class SuiviMensuelChart extends StatefulWidget {
  const SuiviMensuelChart({Key? key}) : super(key: key);

  @override
  State<SuiviMensuelChart> createState() => _SuiviMensuelChartState();
}

class _SuiviMensuelChartState extends State<SuiviMensuelChart> {

  late double _columnWidth;
  late double _columnSpacing;
  List<ChartSampleData>? chartData;
  TooltipBehavior? _tooltipBehavior;
  bool _isLoaded = false ;
  bool isCardView = true ;
  int numberTotal = 0;
  String eniteName = "";

  final supabase = Supabase.instance.client;
  final EntitePilotageController entitePilotageController = Get.find();
  final SuiviDataController suiviDataController = Get.find();

  void initialisation() async {

    final entiteID = entitePilotageController.currentEntite.value;
    final idSuivi = "${entiteID}_${suiviDataController.annee.value}";
    final List suiviDocList = await supabase.from('SuiviData').select().eq("id_suivi",idSuivi);

    final String entite = suiviDocList.first["nom_entite"];
    final int number = suiviDocList.first["indicateur_total"];

    setState(() {
      eniteName = entite;
      numberTotal = number;
    });
    final suiviDoc = suiviDocList.first["suivi_mensuel"];
    _columnWidth = 0.8;
    _columnSpacing = 0.2;
    _tooltipBehavior = TooltipBehavior(enable: true);
    chartData = <ChartSampleData>[
      ChartSampleData(
          x: "Jan", y: number.toDouble() - suiviDoc["1"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["1"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["1"]["indicateur_valides"]),
      ChartSampleData(
          x: "Feb", y: number.toDouble() - suiviDoc["2"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["2"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["2"]["indicateur_valides"]),
      ChartSampleData(
          x: "Mar", y: number.toDouble() - suiviDoc["3"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["3"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["3"]["indicateur_valides"]),
      ChartSampleData(
          x: "Apr", y: number.toDouble() - suiviDoc["4"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["4"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["4"]["indicateur_valides"]),
      ChartSampleData(
          x: "May", y: number.toDouble() - suiviDoc["5"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["5"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["5"]["indicateur_valides"]),
      ChartSampleData(
          x: "Jun", y: number.toDouble() - suiviDoc["6"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["6"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["6"]["indicateur_valides"]),
      ChartSampleData(
          x: "Jul", y: number.toDouble() - suiviDoc["7"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["7"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["7"]["indicateur_valides"]),
      ChartSampleData(
          x: "Aug", y: number.toDouble() - suiviDoc["8"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["8"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["8"]["indicateur_valides"]),
      ChartSampleData(
          x: "Sep", y: number.toDouble() - suiviDoc["9"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["9"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["9"]["indicateur_valides"]),
      ChartSampleData(
          x: "Oct", y: number.toDouble() - suiviDoc["10"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["10"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["10"]["indicateur_valides"]),
      ChartSampleData(
          x: "Nov", y: number.toDouble() - suiviDoc["11"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["11"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["11"]["indicateur_valides"]),
      ChartSampleData(
          x: "Dec", y: number.toDouble() - suiviDoc["12"]["indicateur_collectes"], secondSeriesYValue: suiviDoc["12"]["indicateur_collectes"], thirdSeriesYValue: suiviDoc["12"]["indicateur_valides"])
    ];
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      _isLoaded = true;
    });
  }

  Image _getImage(int index) {
    final List<Image> images = <Image>[
      Image.asset('assets/icons/no_data.png'),
      Image.asset('assets/icons/data_collect.png'),
      Image.asset('assets/icons/data_validated.png'),
    ];
    return images[index];
  }

  @override
  void initState() {
    initialisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded ? _buildSpacingColumnChart() : const Stack(
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
            child:
            CircularProgressIndicator(color: Colors.amber, strokeWidth: 4)),
      ],
    );
  }

  SfCartesianChart _buildSpacingColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: 'Suivi mensuel des données pour ${suiviDataController.annee.value} : $eniteName',
          textStyle: const TextStyle(fontSize: 16,decoration: TextDecoration.underline)
      ),
      primaryXAxis: const CategoryAxis(
        title: AxisTitle(text: "",textStyle: TextStyle(fontSize: 14)),
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: "Indicateurs"),
          maximum: numberTotal.toDouble(),
          minimum: 0,
          interval: 40,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumn(),
      legend: Legend(
      isVisible: true,
      position: LegendPosition.bottom,
      orientation: LegendItemOrientation.horizontal,
      overflowMode: LegendItemOverflowMode.wrap,
      toggleSeriesVisibility: false,
      legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
        return SizedBox(
           height: 40,
          width: index == 1 ? 95 : name.length.toDouble()*14,
          child: Row(
            children: [
              SizedBox(height: 30, width: 30,child: _getImage(index),),
              const SizedBox(width: 10,height: 10,),
              Text(name),
              const SizedBox(width: 10,height: 10,),
            ],
          ),
        );
      },
    ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  ///Get the column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumn() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          width: isCardView ? 0.5 : _columnWidth,
          spacing: isCardView ? 0.2 : _columnSpacing,
          dataSource: chartData!,
          color: Colors.red,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: "Champs vides"),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          width: isCardView ? 0.5 : _columnWidth,
          spacing: isCardView ? 0.2 : _columnSpacing,
          color: Colors.amber,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: "Collectés"),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          width: isCardView ? 0.5 : _columnWidth,
          spacing: isCardView ? 0.2 : _columnSpacing,
          color: Colors.green,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: 'Validation'),
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
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

