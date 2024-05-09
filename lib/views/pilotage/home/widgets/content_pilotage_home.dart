import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/constants/constant_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../helper/helper_methods.dart';
import '/modules/styled_scrollview.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../widgets/custom_text.dart';
import 'overview_card.dart';
import 'overview_item.dart';

class ContentPilotageHome extends StatefulWidget {
  const ContentPilotageHome({Key? key}) : super(key: key);

  @override
  State<ContentPilotageHome> createState() => _ContentPilotageHomeState();
}

class _ContentPilotageHomeState extends State<ContentPilotageHome> {
  ScrollController scrollController = ScrollController();
  double mheight = 150;
  double height = 200;
  double bHeight = 250;

  Future<void> _showMyDialog(String imagePath, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, //// user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          scrollable: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Color(0xFFFFC000),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: ImageWidget(imagePath: imagePath),
          actions: [
            TextButton(
              onPressed: () {
                // Gérer la logique lorsque l'utilisateur appuie sur ce bouton
                Navigator.of(context).pop(); // Fermez la boîte de dialogue
              },
              child: const Text("Fermer",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StyledScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 4.0,
            children: [
              // Consolidation Groupe
              const SizedBox(
                height: 200,
                width: 300,
                child: OverviewCard(
                  title: "Consolidation Groupe",
                  titleColor: Color(0xffb66600),
                  children: [
                    EntityTextButton(
                      title: "COMEX",
                      color: Color(0xffb66600),
                      entiteID: "comex",
                    ),
                    EntityTextButton(
                      title: "GROUPE SIFCA",
                      color: Color(0xffb66600),
                      entiteID: "groupe-sifca",
                    ),
                  ],
                ),
              ),
              // Oléagineux
              const SizedBox(
                width: 300,
                child: OverviewCard(
                  title: "Oléagineux",
                  titleColor: Colors.red,
                  children: [
                    EntityTextButton(
                      title: "SANIA",
                      color: Colors.red,
                      entiteID: "sania",
                    ),
                    EntityTextButton(
                      title: "MOPP",
                      color: Colors.red,
                      entiteID: "mopp",
                    ),
                    OverviewExpansionItem(
                      title: "PALMCI",
                      titleColor: Colors.red,
                      entiteID: 'palmci',
                      children: [
                        EntityTextButton(
                          title: "Palmci Siège",
                          color: Colors.black54,
                          entiteID: "palmci-siege",
                        ),
                        EntityTextButton(
                          title: "Blidouba",
                          color: Colors.black54,
                          entiteID: "palmci-blidouba",
                        ),
                        EntityTextButton(
                          title: "Boubo",
                          color: Colors.black54,
                          entiteID: "palmci-boubo",
                        ),
                        EntityTextButton(
                          title: "Ehania",
                          color: Colors.black54,
                          entiteID: "palmci-ehania",
                        ),
                        EntityTextButton(
                          title: "Gbapet",
                          color: Colors.black54,
                          entiteID: "palmci-gbapet",
                        ),
                        EntityTextButton(
                          title: "Iboké",
                          color: Colors.black54,
                          entiteID: "palmci-iboke",
                        ),
                        EntityTextButton(
                          title: "Irobo",
                          color: Colors.black54,
                          entiteID: "palmci-irobo",
                        ),
                        EntityTextButton(
                          title: "Neka",
                          color: Colors.black54,
                          entiteID: "palmci-neka",
                        ),
                        EntityTextButton(
                          title: "Toumanguié",
                          color: Colors.black54,
                          entiteID: "palmci-toumanguie",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Catouchou Naturel
              const SizedBox(
                width: 300,
                child: OverviewCard(
                  title: "Catouchou Naturel",
                  titleColor: Colors.green,
                  children: [
                    EntityTextButton(
                      title: "CRC",
                      color: Colors.green,
                      entiteID: "crc",
                    ),
                    OverviewExpansionItem(
                      title: "GREL",
                      height: 60,
                      titleColor: Colors.green,
                      entiteID: "grel",
                      children: [
                        EntityTextButton(
                          title: "Apimenim",
                          color: Colors.black54,
                          entiteID: "grel-apimenim",
                        ),
                        EntityTextButton(
                          title: "Tsibu",
                          color: Colors.black54,
                          entiteID: "grel-tsibu",
                        ),
                      ],
                    ),
                    EntityTextButton(
                      title: "RENL",
                      color: Colors.green,
                      entiteID: "renl",
                    ),
                    OverviewExpansionItem(
                      title: "SAPH",
                      titleColor: Colors.green,
                      entiteID: 'saph',
                      children: [
                        EntityTextButton(
                          title: "SAPH Siège",
                          color: Colors.black54,
                          entiteID: "saph-siege",
                        ),
                        EntityTextButton(
                          title: "Béttié",
                          color: Colors.black54,
                          entiteID: "saph-bettie",
                        ),
                        EntityTextButton(
                          title: "Bongo",
                          color: Colors.black54,
                          entiteID: "saph-bongo",
                        ),
                        EntityTextButton(
                          title: "Loeth",
                          color: Colors.black54,
                          entiteID: "saph-loeth",
                        ),
                        EntityTextButton(
                          title: "PH/CC",
                          color: Colors.black54,
                          entiteID: "saph-ph-cc",
                        ),
                        EntityTextButton(
                          title: "Rapides-Grah",
                          color: Colors.black54,
                          entiteID: "saph-rapides-grah",
                        ),
                        EntityTextButton(
                          title: "Toupah",
                          color: Colors.black54,
                          entiteID: "saph-toupah",
                        ),
                        EntityTextButton(
                          title: "Yacoli",
                          color: Colors.black54,
                          entiteID: "saph-yacoli",
                        ),
                      ],
                    ),
                    EntityTextButton(
                      title: "SIPH",
                      color: Colors.green,
                      entiteID: "siph",
                    ),
                  ],
                ),
              ),
              // Sucre
              const SizedBox(
                height: 200,
                width: 300,
                child: OverviewCard(
                  title: "Sucre",
                  titleColor: Colors.blue,
                  children: [
                    OverviewExpansionItem(
                      title: "SUCRIVOIRE",
                      titleColor: Colors.blue,
                      entiteID: "sucrivoire",
                      children: [
                        EntityTextButton(
                          title: "Sucrivoire-Siège",
                          color: Colors.black54,
                          entiteID: "sucrivoire-siege",
                        ),
                        EntityTextButton(
                          title: "Borotou-Koro",
                          color: Colors.black54,
                          entiteID: "sucrivoire-borotou-koro",
                        ),
                        EntityTextButton(
                          title: "Zuénoula",
                          color: Colors.black54,
                          entiteID: "sucrivoire-zuenoula",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Consolidaltion Filières
              SizedBox(
                height: mheight,
                width: 300,
                child: const OverviewCard(
                  title: "Consolidaltion Filières",
                  titleColor: Color(0xffb66600),
                  children: [
                    EntityTextButton(
                      title: 'Oléagineux',
                      entiteID: 'oleagineux',
                      color: Colors.red,
                    ),
                    EntityTextButton(
                      title: 'Sucre',
                      entiteID: 'sucre',
                      color: Colors.blue,
                    ),
                    EntityTextButton(
                      title: 'Caoutchouc Naturel',
                      entiteID: 'caoutchouc-naturel',
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              // SIFCA HOLDING
              SizedBox(
                height: mheight,
                width: 300,
                child: const OverviewCard(
                  title: "SIFCA HOLDING",
                  titleColor: Colors.grey,
                  children: [
                    EntityTextButton(
                      title: 'SIFCA Holding',
                      entiteID: 'sifca-holding',
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 210,
              //   width: 650,
              //   child: OverviewCard(
              //     title: "Outils de Gestions",
              //     titleColor: Colors.orange,
              //     children: [
              //       Row(
              //         children: [
              //           // Outils des Dirigeants
              //           SizedBox(
              //             height: mheight,
              //             width: 300,
              //             child: OverviewCard(
              //               title: "Outils des Dirigeants",
              //               titleColor: Colors.black,
              //               children: [
              //                 TextButton(
              //                     onPressed: () {
              //                       _showMyDialog(
              //                           "assets/images/gouvernance-strategie-dd-2021-2025.png",
              //                           "Feuille de Route");
              //                     },
              //                     child: const CustomText(
              //                       text: "Feuille de Route",
              //                       color: Colors.black,
              //                       weight: FontWeight.bold,
              //                     )),
              //               ],
              //             ),
              //           ),
              //           // Ressources
              //           SizedBox(
              //             height: mheight,
              //             width: 300,
              //             child: Container(
              //               width: 200,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(20),
              //                   border:
              //                       Border.all(color: headerApp, width: 2.0)),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Container(
              //                     height: 25,
              //                     width: double.maxFinite,
              //                     decoration: BoxDecoration(
              //                         color: headerApp,
              //                         borderRadius: BorderRadius.circular(20)),
              //                     child: const Center(
              //                       child: CustomText(
              //                         text: "Ressources",
              //                         color: Colors.black,
              //                         weight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ),
              //                   TextButton.icon(
              //                       onPressed: () {
              //                         _showMyDialog(
              //                             "assets/images/organigramme.png",
              //                             "Arborescence des pages de Performance RSE");
              //                       },
              //                       icon: const Icon(
              //                         Icons.account_tree,
              //                         color: Colors.amber,
              //                       ),
              //                       label: const Text("Organigramme",
              //                           style: TextStyle(color: activeBlue))),
              //                   TextButton.icon(
              //                       onPressed: () {
              //                         _showMyDialog(
              //                             "assets/images/strategie.jpg",
              //                             "Stratégie RSE");
              //                       },
              //                       icon: const Icon(
              //                         Icons.telegram,
              //                         color: Colors.green,
              //                       ),
              //                       label: const Text("Stratégie RSE",
              //                           style: TextStyle(color: activeBlue))),
              //                   TextButton.icon(
              //                       onPressed: () {},
              //                       icon: const Icon(
              //                         Icons.person,
              //                         color: Colors.orange,
              //                       ),
              //                       label: const Text("Contributeurs",
              //                           style: TextStyle(color: activeBlue))),
              //                   TextButton.icon(
              //                       onPressed: () {
              //                         _showMyDialog(
              //                             "assets/images/politique-durabilite.jpg",
              //                             "Politique Durabilité");
              //                       },
              //                       icon: const Icon(
              //                         Icons.batch_prediction,
              //                         color: Colors.brown,
              //                       ),
              //                       label: const Text(
              //                         "Politique Durabilité",
              //                         style: TextStyle(color: activeBlue),
              //                       ))
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class Element extends StatelessWidget {
  const Element({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 300,
      color: Colors.red,
    );
  }
}

class EntityTextButton extends StatefulWidget {
  final String title;
  final String entiteID;
  final Color color;
  final Function()? onTap;
  const EntityTextButton(
      {super.key,
      required this.title,
      required this.entiteID,
      this.onTap,
      required this.color});

  @override
  State<EntityTextButton> createState() => _EntityTextButtonState();
}

class _EntityTextButtonState extends State<EntityTextButton> {
  final supabase = Supabase.instance.client;
  final storage = const FlutterSecureStorage();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accès refusé'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text("Vous n'avez pas accès à cet espace."),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/forbidden.png",
                  width: 50,
                  height: 50,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> goToEspaceEntitePilotage(String idEntite) async {
    print(idEntite);
    EasyLoading.show(status: 'Chargement...');
    await Future.delayed(const Duration(seconds: 2));
    String? email = await storage.read(key: 'email');
    if (email == null) {
      EasyLoading.dismiss();
      await Future.delayed(const Duration(milliseconds: 100));
      _showMyDialog();
      return false;
    }
    final result =
        await supabase.from("AccesPilotage").select().eq("email", email);
    final acces = result[0];
    if (acces["est_bloque"]) {
      EasyLoading.dismiss();
      await Future.delayed(const Duration(milliseconds: 100));
      _showMyDialog();
      return false;
    }
    final List userRestrictionList = acces["restrictions"];
    final checkEntite =
        entityIsnotInRestriction(userRestrictionList, widget.entiteID);
    if (acces["est_admin"] && checkEntite) {
      EasyLoading.dismiss();
      final path = "/pilotage/espace/$idEntite/accueil";
      await Future.delayed(const Duration(milliseconds: 100));
      context.go(path);
      return true;
    }
    final bool verfication = (acces["est_spectateur"] ||
        acces["est_editeur"] ||
        acces["est_validateur"]);
    //final bool checkEntite = (acces["entite"] == widget.entiteID);
    if (verfication && checkEntite) {
      EasyLoading.dismiss();
      final path = "/pilotage/espace/$idEntite/accueil";
      await Future.delayed(const Duration(milliseconds: 100));
      context.go(path);
      return true;
    }
    EasyLoading.dismiss();
    await Future.delayed(const Duration(milliseconds: 100));
    _showMyDialog();
    return false;
  }

  bool entityIsnotInRestriction(List userRestrictionList, String entity) {
    return userRestrictionList.isEmpty || !userRestrictionList.contains(entity);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.onTap ??
            () async {
              goToEspaceEntitePilotage(widget.entiteID);
            },
        child: CustomText(
          text: widget.title,
          color: widget.color,
          weight: FontWeight.bold,
        ));
  }
}

class ImageWidget extends StatelessWidget {
  final String imagePath;

  const ImageWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      width: 700,
      imagePath,
      fit: BoxFit.fill,
      frameBuilder:
          (BuildContext context, Widget child, int? pixel, bool isShow) {
        if (pixel == null) {
          return SizedBox(
            width: 700,
            height: 500,
            child: Column(
              children: [
                loadingPageWidget(),
              ],
            ),
          );
        }
        return child;
      },
    );
  }
}
