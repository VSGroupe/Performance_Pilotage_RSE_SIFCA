import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/helper/helper_methods.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/utils/localization_provider.dart';
import 'package:provider/provider.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import '../../../../widgets/export_widget.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
class HeaderMainPage extends StatefulWidget {
  final String title;
  final Map mainPageData;

  const HeaderMainPage(
      {Key? key, required this.title, required this.mainPageData})
      : super(key: key);

  @override
  State<HeaderMainPage> createState() => _HeaderMainPageState();
}

class _HeaderMainPageState extends State<HeaderMainPage> {
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final nom = widget.mainPageData["user"]["nom"];
    final prenom = widget.mainPageData["user"]["prenom"];
    final email = widget.mainPageData["user"]["email"];
    final providerLocal =  Provider.of<LocalizationProvider>(context);
    return Container(
      height: 60,
      color: const Color(0xFFAAA095),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Image.asset(
                "assets/logos/logo_sifca_blanc.jpg",
                height: 50,
              ),
              const SizedBox(
                width: 20,
              ),
               CustomText(
                text: tr.home,
                color: Colors.black,
                weight: FontWeight.bold,
                size: 30,
              )
            ],
          ),
          Row(
            children: [
              Center(
                child: CustomText(
                  text: "$prenom $nom",
                  color: Colors.white,
                  weight: FontWeight.bold,
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              QudsPopupButton(
                items: getMenuItems(
                    shortName: "${prenom![0]}${nom![0]}",
                    name: "$prenom $nom",
                    email: email!),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFFFFF00),
                  child: Center(
                    child: CustomText(
                      text: "${prenom![0]}${nom![0]}",
                      color: const Color(0xFFF1C232),
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              TextButton(
                child:  Text(tr.about,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  _showMyDialog(context, "assets/images/Presentation-PERFORMANCE-RSE.jpg", "Performance RSE");
                },
              ),
              const SizedBox(
                width: 30,
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
                                      context.go("/");  
                                     },
                              ),
                          ),
                        )
                ],),
              )
            ],
          )
        ],
      ),
    );
  }

  List<QudsPopupMenuBase> getMenuItems({
    required String shortName,
    required String name,
    required String email,
  }) {
    return [
      QudsPopupMenuItem(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFFFFF00),
            child: Center(
              child: CustomText(
                text: shortName,
                color: const Color(0xFFF1C232),
                weight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          subTitle: Text(email),
          onPressed: () {}),
      QudsPopupMenuDivider(),
      QudsPopupMenuWidget(
          builder: (c) => Container(
              padding: const EdgeInsets.all(10),
              width: 800,
              child: IntrinsicHeight(
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:  Text(
                                "'${tr.logOutQuestion}?"),
                            content:  SizedBox(
                                width: 200,
                                child: Text(
                                    "${tr.logOutWarning}.")),
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            actions: <Widget>[
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child:  Text(tr.no),
                              ),
                              OutlinedButton(
                                onPressed: () async {
                                  await storage.write(key: 'logged', value: "");
                                  await storage.write(key: 'email', value: "");
                                  await storage.deleteAll();
                                  context.go('/account/login');
                                },
                                child:  Text(tr.yes),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: const StadiumBorder(),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child:  CustomText(
                        text: tr.logOut,
                        color: Colors.white,
                      ),
                    )),
              )))
    ];
  }
}

Future<void> _showMyDialog(
    BuildContext context, String imagePath, String title) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        scrollable: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFFC000),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: ImageWidget(imagePath: imagePath),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child:  Text(tr.close,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class ImageWidget extends StatelessWidget {
  final String imagePath;

  const ImageWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      width: 700,
      imagePath,
      fit: BoxFit.fill,
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? pixel,
        bool isShow,
      ) {
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

