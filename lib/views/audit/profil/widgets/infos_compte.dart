import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:perf_rse/api/supabse_db.dart';
import 'package:perf_rse/helper/helper_methods.dart';
import 'package:perf_rse/widgets/custom_text.dart';

//import '../../../../../api/supabase.dart';
import '../../../../../models/common/user_model.dart';
import '../../../../../models/pilotage/acces_pilotage_model.dart';
//import '../../../../../widgets/customtext.dart';
import '../../../../../widgets/menu_deroulant.dart';
import '../controller/profil_pilotage_controller.dart';

class InfosCompte extends StatefulWidget {
  final UserModel userModel;
  final AccesPilotageModel accesPilotageModel;
  const InfosCompte(
      {Key? key, required this.userModel, required this.accesPilotageModel})
      : super(key: key);

  @override
  State<InfosCompte> createState() => _InfosCompteState();
}

class _InfosCompteState extends State<InfosCompte> {
  final DataBaseController dbController = DataBaseController();
  final ProfilPilotageController userController = Get.find();
  String? dropDownLangue = "fr";
  double widthTextForm = 350;

  updateLanguage(langue) async {
    final result = await dbController.updateUserLanguage(
        email: widget.userModel.email, langue: langue);
    if (result) {
      userController.userModel.value.langue = langue;
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
          "Succès", "Modification éffectuée avec succès", Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar("Echec", "Un problème est survenu", Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Card(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 10,
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Email utilisateur",
                              size: 15,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            textNonModifiable("${widget.accesPilotageModel.email}"),
                          ],
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Type d'accès",
                              size: 15,
                            ),
                            // SizedBox(
                            //   height: 5,
                            // ),
                            // textNonModifiable(
                            //     getAccesType(widget.accesPilotageModel)),
                          ],
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Langue",
                              size: 15,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            MenuDeroulant(
                              indication: "",
                              initValue: widget.userModel.langue == "fr"
                                  ? "Française"
                                  : widget.userModel.langue == "en"
                                  ? "English"
                                  : "",
                              width: widthTextForm,
                              height: 50,
                              items: ["Française", "English"],
                              onChanged: (value) {
                                dropDownLangue = value!;
                              },
                            )
                          ],
                        )),
                  ],
                ),
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: InkWell(
            onTap: () {
              updateLanguage(dropDownLangue ?? "Française");
            },
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.amber,
                  border: Border.all(
                    color: Colors.amber,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(40))),
              child: const Center(
                  child: CustomText(
                    text: "Enregistrer",
                    size: 20,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  )),
            ),
          ),
        )
      ],
    );
  }

  // String getAccesType(AccesPilotageModel accesPilotageModel) {
  //   if (accesPilotageModel.estAdmin ?? false) {
  //     return "Admin";
  //   }
  //   if (accesPilotageModel.estValidateur ?? false) {
  //     return "Validateur";
  //   }
  //   if (accesPilotageModel.estCollecteur ?? false) {
  //     return "Collecteur";
  //   }
  //   if (accesPilotageModel.estSpectateur ?? false) {
  //     return "Spectateur";
  //   }
  //   return "";
  // }

  Widget textNonModifiable(String text) {
    return Container(
        height: 50,
        alignment: Alignment.centerLeft,
        width: widthTextForm,
        decoration: const BoxDecoration(
            color: Color(0xFFF2F4F5),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText(
            text,
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ));
  }
}
