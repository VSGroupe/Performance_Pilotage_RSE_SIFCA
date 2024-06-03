import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../api/supabse_db.dart';
import '../../../../../helper/helper_methods.dart';
import '../../../../../models/pilotage/acces_pilotage_model.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/menu_deroulant.dart';
import '../../../controllers/profil_pilotage_controller.dart';

class InfosCompte extends StatefulWidget {
  const InfosCompte({Key? key}) : super(key: key);

  @override
  State<InfosCompte> createState() => _InfosCompteState();
}

class _InfosCompteState extends State<InfosCompte> {
  final supabase = Supabase.instance.client;
  final DataBaseController dbController = DataBaseController();
  final ProfilPilotageController profilController = Get.find();
  String dropDownLangue = "";
  double widthTextForm = 350;

  void updateLanguage(String langue) async {
    EasyLoading.show(status: "Mise à jour en cours");
    final email = profilController.userModel.value.email;
    final result =
        await dbController.updateUserLanguage(email: email, langue: langue);
    if (result) {
      profilController.userModel.value.langue = langue;
      profilController.updateProfil();
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
          "Succès", "La mise à jour a été effectuée avec succès", Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar("Échec", "La mise à jour a échoué", Colors.red));
    }
    EasyLoading.dismiss();
  }

  String concatenationListe(List<String>? liste) {
    List<String> strings = liste!.map((e) => e.toString()).toList();
    return strings.join(", ");
  }

  @override
  void initState() {
    dropDownLangue = profilController.userModel.value.langue ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Card(
              elevation: 3,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 10,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Email de l'utilisateur",
                              size: 15,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            textNonModifiable(
                                profilController.userModel.value.email),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Type d'accès",
                              size: 15,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            textNonModifiable(getAccesType(
                                profilController.accesPilotageModel.value)),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Vos processus",
                              size: 15,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            textNonModifiable(concatenationListe(
                                profilController
                                    .accesPilotageModel.value.processus)),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Langue",
                              size: 15,
                            ),
                            const SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            MenuDeroulant(
                              indication: "",
                              initValue:
                                  profilController.userModel.value.langue ==
                                          "fr"
                                      ? "Français"
                                      : "English",
                              width: 350,
                              dropdownWidth: 350,
                              height: 50,
                              items: const ["Français", "English"],
                              onChanged: (value) {
                                if (value == "Français") {
                                  dropDownLangue = "fr";
                                } else if (value == "English") {
                                  dropDownLangue = "en";
                                }
                              },
                            )
                          ],
                        ),
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
                  updateLanguage(dropDownLangue);
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(
                        color: Colors.amber,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(40))),
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
        ));
  }

  String getAccesType(AccesPilotageModel accesPilotageModel) {
    if (accesPilotageModel.estAdmin ?? false) {
      return "Admin";
    }
    if (accesPilotageModel.estValidateur ?? false) {
      return "Validateur";
    }
    if (accesPilotageModel.estEditeur ?? false) {
      return "Editeur";
    }
    if (accesPilotageModel.estSpectateur ?? false) {
      return "Spectateur";
    }
    return "";
  }

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
