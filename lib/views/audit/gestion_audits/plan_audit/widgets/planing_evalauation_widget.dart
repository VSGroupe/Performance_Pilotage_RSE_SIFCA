import 'package:flutter/material.dart';
import '../../../constant/constants.dart';
class PlaningEvaluation extends StatefulWidget {
  final String date;
  const PlaningEvaluation({super.key, required this.date});

  @override
  State<PlaningEvaluation> createState() => _PlaningEvaluationState();
}

class _PlaningEvaluationState extends State<PlaningEvaluation> {
  @override
  Widget rowPlannig(){
    return Container(
      padding: EdgeInsets.only(top:7),
      child:Row(
        children: [
          CircleAvatar(radius: 14,backgroundColor:blueColor,),
          SizedBox(width: 9,),
          Text("De 08h00-10h00",style: globalNormalStyle,),
          SizedBox(width: 15,),
          Text("Administration",style: globalNormalStyle,),
          SizedBox(width: 15,),
          Text("RA + A",style: globalNormalStyle,),
        ],
      ),
    );
  }
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:10),
      padding: EdgeInsets.only(top:10,left: 10,right: 10,bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color:Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0,4),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0xFF00000040).withOpacity(0.5)
          )
        ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Planning audit: ${widget.date}",style: globalBoldStyle,),
              Expanded(child: Container()),
              IconButton(onPressed: (){}, icon: Icon(Icons.more_vert_outlined, size: 18,)),
              SizedBox(width: 8,),
              IconButton(onPressed:(){}, icon:Image.asset("assets/images/delete.png",color:Colors.red,width: 28,height: 28,)),
            ],
          ),
          Column(
            children: List.generate(2, (index) => rowPlannig()),
          )
        ],
      ),
    );

  }
}
