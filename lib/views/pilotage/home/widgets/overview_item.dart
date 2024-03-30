import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/modules/styled_scrollview.dart';

import '../../../../widgets/custom_text.dart';

class OverviewExpansionItem extends StatefulWidget {
  final String title;
  final String entiteID;
  final Color titleColor;
  final List<Widget> children;
  final Function()? onPress;
  final double? height;

  const OverviewExpansionItem(
      {Key? key,
      required this.title,
      required this.titleColor,
      required this.children,
      required this.entiteID,
      this.onPress,
      this.height})
      : super(key: key);

  @override
  _OverviewExpansionItemState createState() => _OverviewExpansionItemState();
}

class _OverviewExpansionItemState extends State<OverviewExpansionItem> {
  late bool isVisible;
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
    EasyLoading.show(status: 'Chargement...');
    String? email = await storage.read(key: 'email');
    if (email == null) {
      EasyLoading.dismiss();
      _showMyDialog();
      return false;
    }
    final result =
        await supabase.from("AccesPilotage").select().eq("email", email);
    final acces = result[0];
    //print(acces);
    if (acces["est_bloque"]) {
      EasyLoading.dismiss();
      _showMyDialog();
      return false;
    }
    final List userRestrictionList = acces["restrictions"];
    final checkEntite =
        entityIsnotInRestriction(userRestrictionList, widget.entiteID);
    // verification de checkEntite parce qu'il existe plusieurs niveaux d'admin : Super admin et admin ayant acces a un ensemble defini d'entites
    if (acces["est_admin"] && checkEntite) {
      EasyLoading.dismiss();
      final path = "/pilotage/espace/$idEntite/accueil";
      context.go(path);
      return true;
    }
    final bool verfication = (acces["est_spectateur"] ||
        acces["est_editeur"] ||
        acces["est_validateur"]);
    // final bool checkEntite = (acces["entite"] ==
    //     widget.entiteID);
    if (verfication && checkEntite) {
      EasyLoading.dismiss();
      final path = "/pilotage/espace/$idEntite/accueil";
      context.go(path);
      return true;
    }
    EasyLoading.dismiss();
    _showMyDialog();
    return false;
  }

bool entityIsnotInRestriction(List userRestrictionList, String entity) {
  return userRestrictionList.isEmpty || !userRestrictionList.contains(entity);
}


  @override
  void initState() {
    isVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                style: const ButtonStyle(alignment: Alignment.centerLeft),
                onPressed: widget.onPress ??
                    () {
                      goToEspaceEntitePilotage(widget.entiteID);
                    },
                child: CustomText(
                  text: widget.title,
                  color: widget.titleColor,
                  weight: FontWeight.bold,
                )),
            RotatedBox(
              quarterTurns: isVisible == true ? 1 : 3,
              child: InkWell(
                  onTap: () async {
                    setState(() {
                      if (isVisible) {
                        isVisible = false;
                      } else if (isVisible == false) {
                        isVisible = true;
                      }
                    });
                    await Future.delayed(const Duration(seconds: 1));
                    setState(() {});
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: isVisible == true ? widget.titleColor : Colors.black,
                  )),
            )
          ],
        ),
        Visibility(
            visible: isVisible,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                height: widget.height ?? 100,
                width: double.maxFinite,
                child: StyledScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.children),
                ),
              ),
            ))
      ],
    );
  }
}
