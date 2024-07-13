import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';
import '../../controllers/profil_pilotage_controller.dart';
import 'menu_nav_pilotage.dart';



class DrawerMenuPilotage extends StatefulWidget {
  const DrawerMenuPilotage({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerMenuPilotage> createState() => _DrawerMenuPilotageState();
}

class _DrawerMenuPilotageState extends State<DrawerMenuPilotage> {

  final ProfilPilotageController profilPilotageController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isExtended = true;
    return Obx((){
      final estAdmin = profilPilotageController.accesPilotageModel.value.estAdmin;
      return SizedBox(
        width: 250,
        child: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                CustomMenuButton(
                    pathMenu: '/accueil',
                    isFullPath: false,
                    image: "assets/icons/home.png",
                    icon: Icons.home,
                    label:tr.home,
                    isExtended: isExtended),
                //SizedBox(height: 10),
                CustomMenuButton(
                    pathMenu: '/tableau-de-bord',
                    icon: Icons.table_chart_rounded,
                    image: "assets/icons/table.png",
                    isFullPath: false,
                    label: tr.dashboard,
                    isExtended: isExtended),
                //SizedBox(height: 10),
                CustomMenuButton(
                    pathMenu: '/performances',
                    icon: Icons.show_chart,
                    image: "assets/icons/performance.png",
                    isFullPath: false,
                    label: "Performances",
                    isExtended: isExtended),
                //SizedBox(height: 10),
                CustomMenuButton(
                    pathMenu: '/suivi-des-donnees',
                    icon: Icons.monitor_outlined,
                    image: "assets/icons/monitoring.png",
                    isFullPath: false,
                    label: tr.dataTacking,
                    isExtended: isExtended
                ),
                //SizedBox(height: 10),
                CustomMenuButton(
                    pathMenu: '/profil',
                    image: "assets/icons/profil.png",
                    icon: Icons.person,
                    isFullPath: false,
                    label:tr.profile,
                    isExtended: isExtended),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                if (estAdmin == true ) CustomMenuButton(
                    pathMenu: '/admin',
                    image: "assets/icons/admin.png",
                    icon: Icons.settings,
                    isFullPath: false,
                    label: tr.settings,
                    isExtended: isExtended),
                //SizedBox(height: 10),
                CustomMenuButton(
                    pathMenu: '/historique-des-modifications',
                    icon: Icons.track_changes_outlined,
                    label:tr.logs,
                    image: "",
                    isFullPath: false,
                    isExtended: isExtended),
                //SizedBox(height: 10),
                CustomMenuButton(
                    pathMenu: '/support-client',
                    image: "assets/icons/casque.png",
                    icon: Icons.comment,
                    isFullPath: false,
                    label: tr.support,
                    isExtended: isExtended),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                CustomMenuButton(
                    pathMenu: '/pilotage',
                    icon: Icons.arrow_circle_left_sharp,
                    label: tr.homeControl,
                    image: "assets/icons/back.png",
                    isFullPath: true,
                    isExtended: isExtended),
                const SizedBox(height: 10),
                isExtended ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.sunny,
                        color: Colors.yellow,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Switcher(
                          value: false,
                          onTap: () {},
                          size: SwitcherSize.medium,
                          switcherButtonRadius: 50,
                          enabledSwitcherButtonRotate: true,
                          iconOff: Icons.circle_outlined,
                          iconOn: Icons.circle_outlined,
                          colorOff: Colors.yellow,
                          colorOn: Colors.black,
                          onChanged: (bool state) {
                            //
                          },
                        ),
                      ),
                      const Icon(
                        Icons.shield_moon_rounded,
                        color: Colors.black,
                      )
                    ],
                  ),
                ) : Container(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
