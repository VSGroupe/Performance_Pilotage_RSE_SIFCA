import 'package:dropdown_button2/dropdown_button2.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import 'widgets/card_header_widget.dart';
import '../widget/custom_dropdown.dart';
import 'widgets/item_audit_card.dart';

class OverviewEvaluationPage extends StatefulWidget {
  const OverviewEvaluationPage({super.key});

  @override
  State<OverviewEvaluationPage> createState() => _OverviewEvaluationPageState();
}

var dataMap = [
  {
    "titre": "Performance RSE",
    "statut": {
      "En cours": 50,
      "Terminée": 30,
      "Validée": 20,
    },
    "legendLabls": {
      "En cours": "En cours",
      "Terminée": "Terminée",
      "Validée": "Validée",
    },
    "listColor": [
      Colors.grey,
      Colors.green,
      const Color(0xff6c5ce7),
    ]
  },
  {
    "titre": "Performance Globale",
    "statut": {
      "Performance": 70,
      "Ecart à combler": 30,
    },
    "legendLabls": {
      "Performance": "Performance",
      "Ecart à combler": "Ecart à combler",
    },
    "listColor": [
      Colors.green,
      Colors.red,
    ]
  }
];
ScrollController _scrollController = ScrollController();
String? selectedValue;

class _OverviewEvaluationPageState extends State<OverviewEvaluationPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height - 100,
      width: width - 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 21,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.home,
                color: Color.fromRGBO(170, 160, 150, 1),
              ),
              Text("Accueil",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color.fromRGBO(170, 160, 150, 1),
                  ))
            ],
          ),
          Text(
            "Apercu général des audits",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF3C3D3F),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              height: 600,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text("Statistiques des audits"),
                      SizedBox(
                        width: 80,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: DropdownButtonHideUnderline(
                                child: CustomDropDown(
                              indication: 'Selectionner Audit',
                              items: [
                                "Audit N-2023/10/18",
                                "Audit N-2023/10/19",
                                "Audit N-2023/10/20",
                                "Audit N-2023/10/21",
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                            )),
                            //Text("   Apercu de l'audit N'AUDIT-20-05-2022",textAlign:TextAlign.start),
                          ),
                        ),
                      )
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: 1100,
                        height: 200,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                HeaderCardOverviewEvaluation(
                                    title: "Nombre total d'audit:10",
                                    dataMap: {
                                      "En cours": 50,
                                      "clôturer": 30,
                                      "Validée": 20,
                                    },
                                    legendLabels: {
                                      "En cours": "En cours",
                                      "clôturer": "clôturer",
                                      "Validée": "Validée",
                                    },
                                    listColorLegends: [
                                      Colors.grey,
                                      Colors.green,
                                      const Color(0xff6c5ce7),
                                    ],
                                    chartType: ChartType.disc,
                                    legendPosition: LegendPosition.right,
                                    typeChart: 'PieChart'),
                                HeaderCardOverviewEvaluation(
                                    title: "Performance Globale",
                                    dataMap: {
                                      "Performance": 70,
                                      "Ecart à combler": 30,
                                    },
                                    legendLabels: {
                                      "Performance": "Performance",
                                      "Ecart à combler": "Ecart à combler",
                                    },
                                    listColorLegends: [
                                      Colors.green,
                                      Colors.red,
                                    ],
                                    chartType: ChartType.ring,
                                    legendPosition: LegendPosition.bottom,
                                    typeChart: 'PieChart'),
                                HeaderCardOverviewEvaluation(
                                  title: "Performance par axe strategique",
                                  typeChart: 'BarChart',
                                ),
                                HeaderCardOverviewEvaluation(
                                  width:260,
                                  title: "Conclusion sur la conformte",
                                  dataMap: {
                                    "Non conformité": 10,
                                    "Point sensible": 30,
                                    "conforme": 20,
                                    "Point Fort": 40,
                                  },
                                  legendLabels: {
                                    "Non conformité": "Non conformité",
                                    "Point sensible": "Point sensible",
                                    "Conforme": "Conforme",
                                    "Point Fort": "Point Fort",
                                  },
                                  listColorLegends: [
                                    Colors.red,
                                    const Color(0xFFDCC216),
                                    Colors.green,
                                    const Color(0xff6c5ce7),
                                  ],
                                  chartType: ChartType.disc,
                                  legendPosition: LegendPosition.right,
                                  typeChart: 'PieChart',
                                )
                              ]),
                        )),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Listes des Audits",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              context.go("/audit/list-audits");
                            });
                          },
                          icon: Icon(
                            Icons.format_list_bulleted_rounded,
                            size: 25,
                          ),
                        ),
                        Expanded(child: Container()),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.filter_alt_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                          label: Text("Filtre",
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17)),
                        ),
                        SizedBox(
                          width: 18,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: Container(
                            height: 250,
                            width: 1000,
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
                                radius: Radius.circular(
                                    10), // default Radius.circular(8.0)
                                thickness: 10.0, // [ default 8.0 ]
                                color:
                                    Colors.black, // default ColorScheme Theme
                              ),
                              child: ListView(
                                padding: EdgeInsets.only(right: 12),
                                controller: _scrollController,
                                children: [
                                  ItemAudit(
                                    statut: 'Audit terminé',
                                    perfGlobale: 35,
                                    dateCreation: '26-09-2023',
                                    dateDebut: '28-09-2023',
                                    dateFin: '05-10-2023',
                                    dateValidation: '10-10-2023',
                                  ),
                                  ItemAudit(
                                    statut: 'Audit clôturé',
                                    perfGlobale: 35,
                                    dateCreation: '03-10-2023',
                                    dateDebut: '05-10-2023',
                                    dateFin: '11-10-2023',
                                    dateValidation: '15-10-2023',
                                  ),
                                  ItemAudit(
                                    statut: 'En cours',
                                    perfGlobale: 35,
                                    dateCreation: '26-09-2023',
                                    dateDebut: '28-09-2023',
                                    dateFin: '05-10-2023',
                                    dateValidation: '10-10-2023',
                                  ),
                                ],
                              ),
                            ))),
                  ]),
            ),
          ))
        ],
      ),
    );
  }
}
