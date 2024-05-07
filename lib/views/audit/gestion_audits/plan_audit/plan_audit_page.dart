import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import '../../constant/constants.dart';
import '../../widget/button_header_progress.dart';
import '../../widget/material_global_button.dart';
import 'widgets/planing_evalauation_widget.dart';

class PlanAuditPage extends StatefulWidget {
  const PlanAuditPage({super.key});

  @override
  State<PlanAuditPage> createState() => _PlanAuditPageState();
}

class _PlanAuditPageState extends State<PlanAuditPage> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Expanded(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top:12.0,bottom: 12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: backgroundCircleColor,
                child:Text("Logo",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),),
              Expanded(child:Container()),
              Container(
                width: 430,
                height: 43,
                decoration: BoxDecoration(
                    color:activeColor,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0,4),
                        blurRadius: 4,
                        spreadRadius: 0,
                        color:Color(0xFF000000).withOpacity(.5),
                      )
                    ]
                ),
                child: Center(child:Text("Plan d'audit",style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),
              ),
              SizedBox(width: 30,),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            width:1,
                            color: Color(0xFF0055BD)
                        )
                    )
                ),
                icon:Icon(Icons.remove_red_eye_rounded,color:Colors.black),
                onPressed: () {},
                label:Text("Apercu",style:TextStyle(fontSize: 15,color: Colors.black)),
              ),
              SizedBox(width: 12,),
              OutlinedButton.icon(
                style:OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                icon:Icon(Icons.print,color: Colors.black,),
                onPressed: () {},
                label:Text("Imprimer",style: TextStyle(fontSize: 15,color: Colors.black),),
              )

            ],
          ),
        ),
        Text("Entetes",style: globalBoldStyle,),
        Card(
          elevation: 6,
          child: Container(
            height: 155,
            width: double.infinity,
            padding: EdgeInsets.only(top:10,left:10.0,right: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:Colors.white
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(text:TextSpan(
                        text:"Entreprise:  ",
                        style: globalNormalStyle,
                        children: [
                          TextSpan(
                              text:" "
                          )
                        ])),
                    SizedBox(height: 10,),
                    RichText(text:TextSpan(
                        text:"Période:  ",
                        style: globalNormalStyle,
                        children: [
                          TextSpan(
                              text:" "
                          )
                        ])),
                    SizedBox(height: 20,),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Périmetres: ",style: globalNormalStyle,),
                          Container(
                            height: 61,
                            width: 296,
                            decoration: BoxDecoration(
                              color: unselectColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(width: 50,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(text:TextSpan(
                        text:"Référentiel:  ",
                        style: globalNormalStyle,
                        children: [
                          TextSpan(
                              text:" "
                          )
                        ])),
                    SizedBox(height: 5,),
                    RichText(text:TextSpan(
                        text:"Equipe d'évaluation:  ",
                        style: globalNormalStyle,
                        children: [
                          TextSpan(
                              text:" "
                          )
                        ])),
                    SizedBox(height: 5,),
                    RichText(text:TextSpan(
                        text:"Désignation:  ",
                        style: globalNormalStyle,
                        children: [
                          TextSpan(
                              text:" "
                          )
                        ])),
                    SizedBox(height: 10,),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Processus à évaluer: ",style: globalNormalStyle,),
                          Container(
                            height: 61,
                            width: 310,
                            decoration: BoxDecoration(
                              color: unselectColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
          child: Text("Planing d'évaluation",style: globalBoldStyle,),
        ),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                  height: 250,
                  child: VsScrollbar(
                    controller: _scrollController,
                    showTrackOnHover: true, // default false
                    isAlwaysShown: true, // default false
                    scrollbarFadeDuration: Duration(
                        milliseconds:
                        500), // default : Duration(milliseconds: 300)
                    scrollbarTimeToFade: Duration(
                        milliseconds:
                        800), // default : Duration(milliseconds: 600)
                    style: VsScrollbarStyle(
                      hoverThickness: 10.0, // default 12.0
                      radius:
                      Radius.circular(10), // default Radius.circular(8.0)
                      thickness: 10.0, // [ default 8.0 ]
                      color: Colors.black, // default ColorScheme Theme
                    ),
                    child: ListView(
                      padding: EdgeInsets.only(right: 12),
                      controller: _scrollController,
                      children: [
                        PlaningEvaluation(date: "19/07/2023"),
                        PlaningEvaluation(date: "20/07/2023"),
                        PlaningEvaluation(date: "21/07/2023"),
                      ],
                    ),
                  )),
            )),
      ],
    ));
  }
}
