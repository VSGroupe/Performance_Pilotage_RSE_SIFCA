import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:perf_rse/views/pilotage/controllers/entite_pilotage_controler.dart';
import 'package:perf_rse/views/pilotage/controllers/profil_pilotage_controller.dart';
import '../../controllers/side_menu_controller.dart';

class MenuNavPilotage extends StatefulWidget {
  final String responsive;
  const MenuNavPilotage({super.key, required this.responsive});

  @override
  State<MenuNavPilotage> createState() => _MenuNavPilotageState();
}

class _MenuNavPilotageState extends State<MenuNavPilotage> {
  final SideMenuController sideMenuController = Get.find();
  final ProfilPilotageController profilPilotageController = Get.find();

  @override
  Widget build(BuildContext context) {
    switch (widget.responsive) {
      case "cas-0":
        return Container();
      case "cas-1":
        return Container();
      case "cas-2":
        return menuPilotage(70, false);
      case "cas-3":
        return menuPilotage(70, false);
      case "cas-4":
        return Obx(() => menuPilotage(
            sideMenuController.cas4Extended.value ? 250 : 70,
            sideMenuController.cas4Extended.value));
      default:
        return Container();
    }
  }

  Widget menuPilotage(double largeur, bool isExtended) {
    return Obx(() {
      final estAdmin =
          profilPilotageController.accesPilotageModel.value.estAdmin;
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius:
              const BorderRadius.only(bottomRight: Radius.circular(30)),
        ),
        width: largeur,
        child: Column(
          children: [
            const SizedBox(height: 10),
            CustomMenuButton(
                pathMenu: '/accueil',
                image: "assets/icons/home.png",
                isFullPath: false,
                icon: Icons.home,
                label: tr.home,
                isExtended: isExtended),
            //SizedBox(height: 10),
            CustomMenuButton(
                pathMenu: '/tableau-de-bord',
                image: "assets/icons/table.png",
                icon: Icons.table_chart_rounded,
                isFullPath: false,
                label:tr.dashboard,
                isExtended: isExtended),
            //SizedBox(height: 10),
            CustomMenuButton(
                pathMenu: '/performances',
                image: "assets/icons/performance.png",
                icon: Icons.show_chart,
                isFullPath: false,
                label: "Performances",
                isExtended: isExtended),
            //SizedBox(height: 10),
            CustomMenuButton(
                pathMenu: '/suivi-des-donnees',
                image: "assets/icons/monitoring.png",
                icon: Icons.monitor_outlined,
                isFullPath: false,
                label: tr.dataTacking,
                isExtended: isExtended),
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
            if (estAdmin == true)
              CustomMenuButton(
                  pathMenu: '/admin',
                  image: "assets/icons/admin.png",
                  icon: Icons.settings,
                  isFullPath: false,
                  label: tr.settings,
                  isExtended: isExtended),
            //SizedBox(height: 10),
            CustomMenuButton(
                pathMenu: '/historique-des-modifications',
                image: "",
                icon: Icons.track_changes_outlined,
                label: tr.logs,
                isFullPath: false,
                isExtended: isExtended),
            //SizedBox(height: 10),
            CustomMenuButton(
                pathMenu: '/support-client',
                image: "assets/icons/casque.png",
                icon: Icons.comment,
                isFullPath: false,
                label:tr.support,
                isExtended: isExtended),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            const SizedBox(
              height: 5,
            ),
            CustomMenuButton(
                pathMenu: '/d',
                directPath: "/pilotage",
                image: "assets/icons/back.png",
                isFullPath: true,
                icon: Icons.arrow_circle_left_sharp,
                label: tr.homeControl,
                isExtended: isExtended),
            //const SizedBox(height: 10),
            // isExtended
            //     ? Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 20),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const Icon(
            //               Icons.sunny,
            //               color: Colors.yellow,
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //               child: Switcher(
            //                 value: false,
            //                 onTap: () {},
            //                 size: SwitcherSize.medium,
            //                 switcherButtonRadius: 50,
            //                 enabledSwitcherButtonRotate: true,
            //                 iconOff: Icons.circle_outlined,
            //                 iconOn: Icons.circle_outlined,
            //                 colorOff: Colors.yellow,
            //                 colorOn: Colors.black,
            //                 onChanged: (bool state) {},
            //               ),
            //             ),
            //             const Icon(
            //               Icons.shield_moon_rounded,
            //               color: Colors.black,
            //             )
            //           ],
            //         ),
            //       )
            //Container(),
          ],
        ),
      );
    });
  }
}

class CustomMenuButton extends StatefulWidget {
  final String pathMenu;
  final String? directPath;
  final bool isExtended;
  final String image;
  final bool isFullPath;
  final String label;
  final IconData icon;
  const CustomMenuButton(
      {super.key,
      required this.isExtended,
      required this.label,
      required this.icon,
      required this.pathMenu,
      required this.isFullPath,
      required this.image,
      this.directPath});

  @override
  State<CustomMenuButton> createState() => _CustomMenuButtonState();
}

class _CustomMenuButtonState extends State<CustomMenuButton> {
  bool _isHovering = false;
  bool isSelected = false;
  final EntitePilotageController entitePilotageController = Get.find();

  final SideMenuController sideMenuController = Get.find();

  bool calculateSelectedIndex(BuildContext context) {
    if (widget.pathMenu == "/pilotage") {
      return false;
    }
    final String location = GoRouterState.of(context).location;
    if (location.contains(widget.pathMenu)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final String _rootLocation = "/pilotage/espace/${entitePilotageController.currentEntite.value}";
    isSelected = calculateSelectedIndex(context);
    return widget.isExtended
        ? InkWell(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            onTap: () {},
            onHover: (isHovering) {
              setState(() {
                _isHovering = isHovering;
              });
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: isSelected
                      ? _isHovering
                          ? const Color(0xFFFBF3DD)
                          : const Color(0xFFF7E5B4)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                ),
                onPressed: () async {
                  if (widget.directPath != null) {
                    GoRouter.of(context).go(widget.directPath!);
                  } else {
                    if (widget.pathMenu != "/d") {
                      if (widget.isFullPath == false) {
                        GoRouter.of(context)
                            .go(_rootLocation + widget.pathMenu);
                        bool isOpenDrawer =
                            sideMenuController.checkIsDrawerOpen();
                        if (isOpenDrawer) {
                          await Future.delayed(
                              const Duration(milliseconds: 33));
                          sideMenuController.controlMenu();
                        }
                      } else if (widget.isFullPath == true) {
                        GoRouter.of(context).go(widget.pathMenu);
                      }
                    }
                  }
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    widget.image == ""
                        ? Icon(
                            widget.icon,
                            size: 25,
                            color: isSelected
                                ? const Color(0xFF114693)
                                : Colors.black,
                          )
                        : Image.asset(
                            widget.image,
                            width: 25,
                          ),
                    /*,*/
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.label,
                      style: TextStyle(
                          fontSize: 18,
                          color: isSelected
                              ? const Color(0xFF114693)
                              : Colors.black),
                    )
                  ],
                ),
              ),
            ),
          )
        : smallMenu(isSelected);
  }

  Widget smallMenu(bool isSelected) {
    final String _rootLocation = "/pilotage/espace/${entitePilotageController.currentEntite.value}";
    return Row(
      children: [
        const SizedBox(
          width: 19,
        ),
        InkWell(
          hoverColor: Colors.transparent,
          onHover: (value) {
            setState(() {
              _isHovering = value;
            });
          },
          onTap: () {},
          child: JustTheTooltip(
            preferredDirection: AxisDirection.right,
            backgroundColor: const Color(0xFF616161),
            waitDuration: const Duration(milliseconds: 500),
            content: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.label,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            child: Container(
              width: 40,
              height: 40,
              decoration: isSelected
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isHovering
                          ? const Color(0xFFEEEEEE)
                          : const Color(0xFFE8F0FE),
                    )
                  : null,
              child: IconButton(
                onPressed: () {
                  if (widget.directPath != null) {
                    GoRouter.of(context).go(widget.directPath!);
                  } else if (widget.pathMenu != "/d") {
                    GoRouter.of(context).go(_rootLocation + widget.pathMenu);
                  }
                },
                splashRadius: 20,
                padding: EdgeInsets.zero,
                icon: Icon(widget.icon,
                    size: 25,
                    color: isSelected ? const Color(0xFF114693) : Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
