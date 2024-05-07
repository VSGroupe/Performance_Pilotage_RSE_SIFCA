import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../graph_evaluation/barChart.dart';
import '../../graph_evaluation/pie_chart.dart';


class HeaderCardOverviewEvaluation extends StatefulWidget {
  final String? title;
  final double? width;
  final Map<String,double>? dataMap;
  final Map <String,String>? legendLabels;
  final List<Color>? listColorLegends;
  final ChartType? chartType;
  final LegendPosition? legendPosition;
  final String typeChart;
  const HeaderCardOverviewEvaluation({super.key,this.width,required this.title, this.dataMap, this.legendLabels, this.listColorLegends, this.chartType, this.legendPosition, required this.typeChart,});

  @override
  State<HeaderCardOverviewEvaluation> createState() => _HeaderCardOverviewEvaluationState();
}

class _HeaderCardOverviewEvaluationState extends State<HeaderCardOverviewEvaluation> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0,right: 12.0),
      child: Container(
        height: 190,
        width:widget.width?? 244,
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
        child: Card(
          elevation: 6,
          surfaceTintColor:Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children:[
                Center(child:Text(widget.title!,style: TextStyle(color:Colors.black,fontSize: 13,fontWeight: FontWeight.bold),)),
                Expanded(
                  child: Container(
                    child:widget.typeChart=="PieChart"?PieChartEvaluation(dataMap: widget.dataMap!, legendLabels:widget.legendLabels!, listColorLegends:widget.listColorLegends!, chartType: widget.chartType, legendPosition: widget.legendPosition!,)
                    :BarChartEvaluation()
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}