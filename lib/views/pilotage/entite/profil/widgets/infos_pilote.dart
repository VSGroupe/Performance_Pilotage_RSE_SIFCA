import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../../api/supabse_db.dart';
import '../../../../../helper/helper_methods.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/custom_text_form_field.dart';
import '../../../controllers/profil_pilotage_controller.dart';

class InfosPilote extends StatefulWidget {
  const InfosPilote({Key? key}) : super(key: key);

  @override
  State<InfosPilote> createState() => _InfosPiloteState();
}

class _InfosPiloteState extends State<InfosPilote> {

  final ProfilPilotageController profilController = Get.find();
  final DataBaseController dataBaseController = DataBaseController();

  late TextEditingController nomTextEditingController;
  late TextEditingController prenomTextEditingController;
  late TextEditingController villeTextEditingController;
  late TextEditingController adresseTextEditingController;
  late TextEditingController numeroTextEditingController;
  late TextEditingController fonctionTextEditingController;
  late TextEditingController paysTextEditingController;
  late TextEditingController titreTextEditingController;
  late String entite;
  late String filiale;

String concatenationListe(List liste) {
  List<String> strings = liste.map((e) => e.toString()).toList();
  return strings.join(", ");
}


  void initialisation() {

    nomTextEditingController.text = profilController.userModel.value.nom;
    prenomTextEditingController.text = profilController.userModel.value.prenom!;
    titreTextEditingController.text = profilController.userModel.value.titre ?? "";

    villeTextEditingController.text = profilController.userModel.value.ville?? "" ;
    adresseTextEditingController.text = profilController.userModel.value.addresse?? "";
    numeroTextEditingController.text = profilController.userModel.value.numero?? "";
    fonctionTextEditingController.text = profilController.userModel.value.fonction ?? "";
    paysTextEditingController.text = profilController.userModel.value.pays ?? "";

    entite = concatenationListe(profilController.accesPilotageModel.value.nomEntite!);
    filiale = concatenationListe(profilController.userModel.value.entreprise!);
  }


  void updateInfoPilote() async {
    setState(() {
      isUpdating = true;
    });
    EasyLoading.show(status: 'Mise à jour du profil ...');
    await Future.delayed(const Duration(seconds: 1));
    String email = profilController.userModel.value.email;
    final reponse = await dataBaseController.updateUser(
        email: email,
        nom: nomTextEditingController.text,
        prenom: prenomTextEditingController.text,
        titre: titreTextEditingController.text,
        ville: villeTextEditingController.text,
        pays: paysTextEditingController.text,
        adresse: adresseTextEditingController.text,
        numero: numeroTextEditingController.text,
        fonction: fonctionTextEditingController.text,
    );

    if (reponse) {
      await profilController.updateProfil();
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Succès", "La mise à jour a été éffectué avec succès." , Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar("Echec", "Un problème est survenu.", Colors.red));
    }
    EasyLoading.dismiss();
    setState(() {
      isUpdating = false;
    });
  }

  bool isUpdating = false;

  @override
  void initState() {

    nomTextEditingController = TextEditingController();
    prenomTextEditingController = TextEditingController();
    villeTextEditingController = TextEditingController();
    adresseTextEditingController = TextEditingController();
    numeroTextEditingController = TextEditingController();
    fonctionTextEditingController = TextEditingController();
    paysTextEditingController = TextEditingController();
    titreTextEditingController = TextEditingController();

    initialisation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerPilote(),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 350,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(flex: 1, child: piloteInfoPilote()),
                  Expanded(flex: 3, child: contactPilote()),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: InkWell(
            onTap: isUpdating ? null : () {
              updateInfoPilote();
            },
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                  color: isUpdating ? Colors.grey : Colors.amber,
                  border: Border.all(
                    color: Colors.amber,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(40))),//
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

  Widget piloteInfoPilote() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Contributeur",
            size: 20,
            weight: FontWeight.bold,
          ),
          Card(
            elevation: 3,
            child: Container(
              height: 300,
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Titre",
                            size: 15,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          textNonModifiable(titreTextEditingController.text,250),
                          const SizedBox(
                            height: 10,
                          ),
                          const CustomText(
                            text: "Nom",
                            size: 15,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextFormField(
                            controller: nomTextEditingController,
                            width: 250,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const CustomText(
                            text: "Prénom",
                            size: 15,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextFormField(
                            controller: prenomTextEditingController,
                            width: 250,
                          ),
                        ],
                      )
                ],
              ),
            ),
          ),
        ],
      );
  }

  Widget contactPilote() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        const CustomText(
          text: "Contacts",
          size: 20,
          weight: FontWeight.bold,
        ),
        Card(
          elevation: 3,
          child: Container(
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Numéro de téléphone",
                      size: 15,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      controller: numeroTextEditingController,
                      width: 250,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const CustomText(
                      text: "Pays",
                      size: 15,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      controller: paysTextEditingController,
                      width: 250,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const CustomText(
                      text: "Ville",
                      size: 15,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      controller: villeTextEditingController,
                      width: 250,
                    ),
                  ],
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Filiale",
                      size: 15,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    textNonModifiable(filiale,250),
                    const SizedBox(
                      height: 10,
                    ),
                    const CustomText(
                      text: "Entité",
                      size: 15,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    textNonModifiable(entite,250),
                    const SizedBox(
                      height: 10,
                    ),
                    const CustomText(
                      text: "Fonction",
                      size: 15,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      controller: fonctionTextEditingController,
                      width: 250,
                    ),
                  ],
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Adresse",
                      size: 15,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      controller: adresseTextEditingController,
                      width: 250,
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ]);
  }

  Widget headerPilote() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx((){
          String nom = profilController.userModel.value.nom;
          String? prenom = profilController.userModel.value.prenom;
          String email = profilController.userModel.value.email;
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFFFFF00),
              child: Center(
                child: CustomText(
                  text: "${nom[0]}${prenom![0]}",
                  color: const Color(0xFFF1C232),
                  weight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              '$prenom $nom',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(email),
          );
        }),
      ),
    );
  }

  Widget textNonModifiable(String text,double width) {
    return Container(
        height: 50,
        alignment: Alignment.centerLeft,
        width: width,
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
