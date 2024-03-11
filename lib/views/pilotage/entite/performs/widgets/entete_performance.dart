import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/views/pilotage/controllers/drop_down_controller.dart';
import 'package:perf_rse/views/pilotage/controllers/tableau_controller.dart';
import 'package:perf_rse/widgets/menu_deroulant.dart';
import 'package:perf_rse/views/pilotage/entite/performs/widgets/perform_global/performance_global.dart';

import '../../../../../constants/constant_colors.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/unimpleted_widget.dart';

class EntetePerformance extends StatefulWidget {
  const EntetePerformance({Key? key}) : super(key: key);

  @override
  State<EntetePerformance> createState() => _EntityWidgetWidgetState();
}

class _EntityWidgetWidgetState extends State<EntetePerformance> {
  //final TableauBordController tableauBordController = Get.find();
  //final DropDownController dropDownController = Get.find();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // const CustomText(text: "Filtre",size: 20,),
        // const SizedBox(width: 5,),
        // Container(height: 40,width: 1,color: Colors.grey,),
        // const SizedBox(width: 20,),
        // const CustomText(text: "Année",size: 20,),
        // const SizedBox(width: 5,),
        // MenuDeroulant(
        //   indication: "",
        //   initValue: "2023",
        //   items: const ["2022","2023"],
        //   width: 100,
        //   onChanged: (value){
        //   },
        // ),
        Expanded(
            child: Container(
          child: const YearFiltreWidget(),
        )),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () async {},
              splashRadius: 20,
              icon: const Icon(
                Icons.refresh_sharp,
                color: Color(0xFF4F80B5),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () {
                UnimplementedWidget.showDialog();
              },
              icon: const Icon(
                Icons.print,
                color: Colors.white,
              ),
              label: const CustomText(
                text: "Imprimer",
                color: light,
                size: 15,
              )),
        ),
      ],
    );
  }
}

class YearFiltreWidget extends StatefulWidget {
  const YearFiltreWidget({super.key});

  @override
  State<YearFiltreWidget> createState() => _YearFiltreWidgetState();
}

class _YearFiltreWidgetState extends State<YearFiltreWidget> {
  //final DropDownController dropDownController = Get.find();
  static const availbleYearList = <String>[
    '2024',
    '2023',
    '2022',
    '2021',
  ];

  List<PopupMenuItem<String>> _popUpMenuYearItems() {
    return availbleYearList.map(
      (String value) {
        return PopupMenuItem<String>(
            value: value,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Row(
                children: [
                  Text(value),
                ],
              );
            }));
      },
    ).toList();
  }

  final TableauBordController tableauBordController = Get.find();

  String _btn3SelectedYear = "";

  void initialisation() {
    setState(() {
      _btn3SelectedYear = tableauBordController.currentYear.value.toString();
    });
  }

  @override
  void initState() {
    initialisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const Text(
            "Année: ",
            style: TextStyle(fontSize: 18),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5E7))),
            child: Row(
              children: [
                Text(_btn3SelectedYear, style: const TextStyle(fontSize: 15)),
                const SizedBox(
                  width: 5,
                ),
                PopupMenuButton<String>(
                  splashRadius: 15,
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.grey,
                  ),
                  onSelected: (String newValue) {
                    setState(() {
                      _btn3SelectedYear = newValue;
                      tableauBordController
                          .changeYear(int.parse(_btn3SelectedYear));
                    });
                    //tableauBordController.initialisation(context);
                  },
                  itemBuilder: (BuildContext context) => _popUpMenuYearItems(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
