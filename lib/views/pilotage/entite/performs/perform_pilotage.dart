import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:perf_rse/views/pilotage/controllers/performs_data_controller.dart';
import 'package:perf_rse/views/pilotage/entite/performs/content_view.dart';
import 'package:perf_rse/views/pilotage/entite/performs/custom_tab.dart';
import 'package:perf_rse/views/pilotage/entite/performs/custom_tab_bar.dart';
import '/modules/styled_scrollview.dart';
import '../../../../constants/constant_double.dart';
import 'widgets/perform_enjeu/perform_enjeu.dart';
import 'widgets/perform_global/performance_global.dart';
import 'widgets/perform_pilier/performance_piliers.dart';

class PerformPilotage extends StatefulWidget {
  const PerformPilotage({Key? key}) : super(key: key);

  @override
  State<PerformPilotage> createState() => _PerformPilotageState();
}

class _PerformPilotageState extends State<PerformPilotage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final PerformsDataController performsDataController = Get.find();

  void initPerformsDatas() async {
    performsDataController.initialisation(context);
  }

  List<ContentView> contentViews = [
    ContentView(
        tab: const CustomTab(title: "Vue Globale"),
        content: Container(
          padding: const EdgeInsets.only(
              right: defaultPadding, bottom: defaultPadding, top: 5),
          child: StyledScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 405,
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const PerformanceGlobale()),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                              height: double.infinity,
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const PerformancePiliers()))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 500,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const PerformanceEnjeux(),
                )
              ],
            ),
          ),
        )),
    // ContentView(
    //     tab: const CustomTab(title: 'Vue detaillée'),
    //     content: ListView(
    //       padding: const EdgeInsets.symmetric(horizontal: 40),
    //       children: const <Widget>[
    //         Wrap(
    //           spacing: 22,
    //           runSpacing: 22,
    //           children: <Widget>[
    //             // SizedBox(
    //             //   height: 310,
    //             //   width: 550,
    //             //   child: Column(
    //             //     children: [
    //             //       Expanded(child: KeywordsGrid()),
    //             //     ],
    //             //   )),
    //             SizedBox(
    //               height: 300,
    //               width: 600,
    //               child: ProcessGrid()),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               NonEditableTable(),
    //           ],
    //         )
    //       ],
    //     )
    //     ),
  ];
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: contentViews.length, vsync: this);
    initPerformsDatas();
  }

  @override
  Widget build(BuildContext context) {
    return globalView();
  }

  Widget globalView() {
    return Expanded(
      child: Column(
        children: [
          CustomTabBar(
            controller: tabController,
            tabs: contentViews.map((e) => e.tab).toList(),
          ),
          Expanded(
            child: SizedBox(
              height: 500,
              child: TabBarView(
                controller: tabController,
                children: contentViews.map((e) => e.content).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
