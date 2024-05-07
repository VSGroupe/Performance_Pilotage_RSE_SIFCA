import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/views/audit/controller/controller_audit.dart';
//import 'package:perfqse/Views/audit/controller/controller_audit.dart';

class DrawerEvaluation extends StatefulWidget {
  const DrawerEvaluation({Key? key}) : super(key: key);

  @override
  State<DrawerEvaluation> createState() => _DrawerEvaluationState();
}

class _DrawerEvaluationState extends State<DrawerEvaluation> {
  final ControllerAudit controllerAudit =Get.put(ControllerAudit());
  @override
  void initState() {
    controllerAudit.reference.value="";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 0, bottom: 20),
        child: Card(
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Container(
            width: 250,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.white,
                border: Border.fromBorderSide(
                  BorderSide(width: 2, color: Colors.grey),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 11.3),
                        child: Container(
                          width: 200,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  context.go("/audit/gestion-audits"); //controllerAudit.reference.value==""? "":
                                });
                              },
                              child: const Text(
                                "Démarer un audit",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // const Text(
                      //   "Menu Principal",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.black),
                      // ),
                    ],
                  ),
                ),
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(8),
                  child: const Divider(
                    color: Colors.black,
                  ),
                ), const CustomMenuButton(
                    pathMenu: "/audit/accueil", // controllerAudit.reference.value==""? "":
                    image: "assets/images/home1.png",
                    isFullPath: false,
                    // icon: Icons.home,
                    label: "Accueil",
                ),
                 
                // const SizedBox(height: 5),
                // const CustomMenuButton(
                //     pathMenu:'/audit/profil', //controllerAudit.reference.value==""?"":
                //     image: "assets/images/profile-user.png",
                //     // icon: Icons.person,
                //     isFullPath: false,
                //     label: "Profil",
                // ),
                 
                // const SizedBox(height: 5),
                // const CustomMenuButton(
                //     pathMenu: '/audit/gestion-audits', //controllerAudit.reference.value==""?"":
                //     image: "assets/images/audit.png",
                //     // icon: Icons.table_chart_rounded,
                //     isFullPath: false,
                //     label: "Gestion Audits",
                // ),
                 
                // const SizedBox(height: 5),
                // const CustomMenuButton(
                //     pathMenu: '/audit/admin', //controllerAudit.reference.value==""?"":
                //     image: "assets/images/homme-daffaire.png",
                //     // icon: Icons.admin_panel_settings_outlined,
                //     isFullPath: false,
                //     label: "Administration",
                // ),
                const SizedBox(height: 5),
                // const CustomMenuButton(
                //   pathMenu: '',
                //   image: "assets/images/res.png",
                //   // icon: Icons.admin_panel_settings_outlined,
                //   isFullPath: false,
                //   label: "Réssources",
                // ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(8),
                  child: const Divider(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const CustomMenuButton(
                  pathMenu: '/',
                  image: "assets/images/return.png",
                  isFullPath: true,
                  // icon: Icons.arrow_circle_left_sharp,
                  label: "Accueil Général",
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class CustomMenuButton extends StatefulWidget {
  final String pathMenu;
  // final bool isExtended;
  final String image;
  final bool isFullPath;
  final String label;
  // final IconData icon;
  const CustomMenuButton(
      {Key? key,
      required this.label,
      // required this.icon,
      required this.pathMenu,
      required this.isFullPath,
      required this.image})
      : super(key: key);

  @override
  State<CustomMenuButton> createState() => _CustomMenuButtonState();
}

class _CustomMenuButtonState extends State<CustomMenuButton> {
  bool _isHovering = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {},
      onHover: (isHovering) {
        setState(() {
          _isHovering = isHovering;
        });
      },
      child: Container(
        width: 248,
        height: 40,
        decoration: BoxDecoration(
            color: isSelected
                ? _isHovering
                    ? const Color(0xFFEEEEEE)
                    : const Color(0xFFE8F0FE)
                : Colors.transparent,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: OutlinedButton(
          onPressed: () {
            context.go(widget.pathMenu);
          },
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
          child: Row(
            children: [
              /*  widget.image == ""
                  ? Icon(
                      widget.icon,
                      size: 25,
                      color:
                          isSelected ? const Color(0xFF114693) : Colors.black,
                    )
                  : */
              Image.asset(
                widget.image,
                width: 30,
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                widget.label,
                style: TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                    color: isSelected ? const Color(0xFF114693) : Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
