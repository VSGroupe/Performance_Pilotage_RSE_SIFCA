import 'package:d_chart/commons/axis.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:flutter/material.dart';

class BarChartEvaluation extends StatefulWidget {
  const BarChartEvaluation({super.key});

  @override
  State<BarChartEvaluation> createState() => _BarChartEvaluationState();
}

class _BarChartEvaluationState extends State<BarChartEvaluation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 200,
      child:  DChartBarO(
        animate:true,
        groupList: [
          OrdinalGroup(id:"1",
              color:Colors.blue,
              data:[
            OrdinalData(domain: 'axe 1', measure: 120),
            OrdinalData(domain: 'axe 2', measure: 100),
            OrdinalData(domain: 'axe 3', measure: 150),
                OrdinalData(domain: 'axe 4', measure: 200),
          ])
        ],
      ),
    );
  }
}
