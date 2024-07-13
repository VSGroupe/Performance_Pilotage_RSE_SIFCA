import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../constants/constant_double.dart';
import '../../../../widgets/custom_text.dart';
import 'widgets/export_widget_profile.dart';

class ProfilPilotage extends StatefulWidget {
  const ProfilPilotage({Key? key}) : super(key: key);

  @override
  State<ProfilPilotage> createState() => _ProfilPilotageState();
}

class _ProfilPilotageState extends State<ProfilPilotage> with SingleTickerProviderStateMixin {
  static  List<Tab> myTabs = <Tab>[
    Tab(text:tr.personalInformations),
    Tab(text:tr.accountInformation),
    Tab(text:tr.editPassword),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: defaultPadding,bottom: defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: ContainedTabBarView(
                tabBarViewProperties: const TabBarViewProperties(
                  physics: BouncingScrollPhysics(),
                  dragStartBehavior: DragStartBehavior.start,
                ),
                tabBarProperties: TabBarProperties(
                    alignment: TabBarAlignment.start,
                    isScrollable: true,
                    labelColor: Colors.black,
                    labelPadding:
                        const EdgeInsets.only(left: 0, right: 30),
                    unselectedLabelColor: Colors.amber,
                    indicator: MaterialIndicator(
                      color: Colors.amber,
                      paintingStyle: PaintingStyle.fill,
                    )),
                tabs:   [
                  CustomText(
                    text:tr.personalInformations,
                    size: 15,
                  ),
                  CustomText(
                    text: tr.accountInformation,
                    size: 15,
                  ),
                  CustomText(
                    text:tr.editPassword,
                    size: 15,
                  ),
                ],
                views: [
                  Container(child: const InfosPilote(),
                  ),
                  Container(child: const InfosCompte(),
                  ),
                  Container(child: const PasswordPilote(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Map<String,dynamic> getUserEntityInfos(){
    return {
      "entite_id":"sucrivoire"
    };
  }
}
