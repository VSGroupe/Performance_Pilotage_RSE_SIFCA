import 'package:flutter/material.dart';

class AppBarEvaluation extends StatefulWidget {

  const AppBarEvaluation({Key? key}) : super(key: key);

  @override
  State<AppBarEvaluation> createState() => _AppBarEvaluationState();
}

class _AppBarEvaluationState extends State<AppBarEvaluation> {


  @override
  Widget build(BuildContext context) {
      final nom ="AMANI";
      final prenom ="EMMANUEL";
      final email ="projet.dd@visionstrategie.com";
      return Container(
        height: 50,
        color: Color.fromRGBO(170, 160, 150,1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // const SizedBox(
                //   width: 17,
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Image.asset(
                //     "assets/logos/Logo_perfQSE.png",
                //     height: 50,
                //   ),
                // ),
                const SizedBox(
                  width: 20,
                ),
                Text("Accueil Général Evaluation RSE",
                    style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    )
                )
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    Center(
                      child: Text("${prenom} ${nom}",style:TextStyle(
                        fontSize: 18,fontWeight: FontWeight.bold,
                        color:Colors.white,
                      )),
                    ),
                    SizedBox(width: 7,),
                    CircleAvatar(
                        backgroundColor: Colors.yellowAccent,
                        child: Center(
                          child: Text(
                            "${prenom[0]}${nom[0]}",style: TextStyle(
                            color:Color(0xFFF1CD0B),
                            fontWeight: FontWeight.bold,
                          fontSize: 20,
                          )),
                        ),
                      ),

                  ],
                ),
                const SizedBox(width: 25,),
                IconButton(
                  icon:Icon(Icons.add_alert_outlined,size:38,color:Colors.white),
                  onPressed: (){

                  },
                )
              ],
            )
          ],
        ),
      );
  }
}
