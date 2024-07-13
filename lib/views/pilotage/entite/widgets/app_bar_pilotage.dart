import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/utils/localization_provider.dart';
import 'package:provider/provider.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/custom_text.dart';
import '../../controllers/entite_pilotage_controler.dart';
import '../../controllers/side_menu_controller.dart';
import 'entity_widget_pilotage.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
class AppBarPilotage extends StatefulWidget {
  final String shortName;
  const AppBarPilotage({super.key, required this.shortName});

  @override
  State<AppBarPilotage> createState() => _AppBarPilotageState();
}

class _AppBarPilotageState extends State<AppBarPilotage> {

  final SideMenuController sideMenuController = Get.find();
  final EntitePilotageController entitePilotageController = Get.find();
  static const logoSifca = "https://djlcnowdwysqbrggekme.supabase.co/storage/v1/object/public/LogoEntites/logo_sifca_bon.png";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.round();
    String responsive = responsiveRule(width);
      final providerLocal =  Provider.of<LocalizationProvider>(context);
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
              top: BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
      child: Obx((){
        var entiteRes = entitePilotageController.getCurrentEntiteRes();
        entitePilotageController.downloadImageAsUint8List(entiteRes["logo"]);
        var mapColor = getEntiteColor(entiteRes["couleur"]);
        return Row(
          children: [
            IconButton(
              onPressed: () {
                if (responsive == "cas-4"){
                  sideMenuController.controlMenuCas4();
                }else {
                  sideMenuController.controlMenu();
                }
              },
              splashRadius: 20,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.menu,
                size: 30,
                color: Colors.black,
              ),
              hoverColor: const Color(0xFFEEEEEE),
            ),
            SizedBox(
              width: responsive == "cas-0" ? 10 : 20,
            ),
            responsive == "cas-0" ? Container() : Image.network(entiteRes["logo"] != "" ? entiteRes["logo"] : logoSifca, height: 40, fit: BoxFit.fitWidth),
            SizedBox(
              width: responsive == "cas-0" ? 10 : 20,
            ),
            responsive == "cas-0" ? const Text("Votre Espace ",style: TextStyle(fontSize: 18),) :
            EntityWidget(title: entiteRes["nom_entite"],color: mapColor["secondary"]!,hoverColor: mapColor["primary"]!,),
            Expanded(child: Container()),
            const Icon(
              Icons.notifications_none_outlined,
              size: 30,
              color: Colors.black,
            ),
            SizedBox(
              width: responsive == "cas-0" ? 10 : 20,
            ),
            InkWell(
              onTap: (){
                context.go("/pilotage/espace/${entitePilotageController.currentEntite.value}/profil");
              },
              radius: 20,
              child: CircleAvatar( backgroundColor: const Color(0xFFFFFF00),
                  child: Center(child: CustomText(text: widget.shortName,color: const Color(0xFFF1C232),weight: FontWeight.bold,),)),
            ),
             SizedBox(
              width: responsive == "cas-0" ? 10 : 20,
            ),
            Container(
                child: Row(children: [
                  Icon(Icons.language_rounded),
                          SizedBox(
                            height: 50,
                            width: 150,
                            child:  Container(
                              child: CustomDropdown(
                                  hintText:tr.abrLange.toLowerCase()=="en" ? "English":"Français",
                                  items:  ["Français","English"],
                                  onChanged: (value){
                                      providerLocal.chnageLanguage(value);
                                      context.go('/');
                                    },
                              ),
                          ),
                        )
                ],),
              )
            //Image.asset("assets/images/person1.png", height: 50,width: 50, fit: BoxFit.fitWidth)),
          ],
        );
      }),
    );
  }

  Map<String,Color> getEntiteColor (String colorString) {
    switch(colorString) {
      case "bleu-ciel":
        return {
          "primary":const Color(0xFF019FE6),
          "secondary":const Color(0xFF476282),
        };
      case "rouge":
        return {
          "primary":Colors.red,
          "secondary":const Color(0xFFA22C24),
        };
      case "vert":
        return {
          "primary":Colors.green,
          "secondary":const Color(0xFF327435),
        };
      default:
        return {
          "primary":Colors.black,
          "secondary":Colors.grey,
        };
    }
  }
}
