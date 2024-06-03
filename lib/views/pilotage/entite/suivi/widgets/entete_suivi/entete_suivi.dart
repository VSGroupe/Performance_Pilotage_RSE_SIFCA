import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../constants/constant_colors.dart';
import '../../../../../../widgets/custom_text.dart';
import '../../../../../../widgets/menu_deroulant.dart';
import '../../../../../../widgets/unimpleted_widget.dart';
import '../../../../controllers/suivi_data_controller.dart';

class EnteteSuivi extends StatefulWidget {
  const EnteteSuivi({Key? key}) : super(key: key);

  @override
  State<EnteteSuivi> createState() => _EnteteSuiviState();
}

class _EnteteSuiviState extends State<EnteteSuivi> {

  var listAnnee = <String>[];

  final SuiviDataController suiviDataController = Get.find();

  void initialisation() {
    final dateNow = DateTime.now();
    setState(() {
      listAnnee.add("${dateNow.year}");
      listAnnee.add("${dateNow.year-1}");
      listAnnee.add("${dateNow.year-2}");
    });
  }

  @override
  void initState() {
    initialisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CustomText(text: "Fiktre", size: 20,),
        const SizedBox(width: 5,),
        Container(height: 30,width: 1,color: Colors.grey,),
        const SizedBox(width: 20,),
        const CustomText(text: "Année",size: 20,),
        const SizedBox(width: 5,),
        MenuDeroulant(
          indication: "",
          initValue: listAnnee.first,
          items: listAnnee,
          width: 100,
          onChanged: (value){
            if (value != null ) {
              suiviDataController.loadDataSuivi(int.parse(value));
            }
          },
        ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () async {
                int an = suiviDataController.annee.value;
                suiviDataController.loadDataSuivi(an);
              },
              splashRadius: 20,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.refresh,color: Color(0xFF4F80B5),)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () {
                UnimplementedWidget.showDialog();
              },
              icon: const Icon(Icons.print,color: Colors.white,),
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
