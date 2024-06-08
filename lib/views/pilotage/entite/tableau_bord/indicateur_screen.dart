import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/modules/styled_scrollview.dart';
import 'package:perf_rse/views/pilotage/controllers/profil_pilotage_controller.dart';
import 'package:perf_rse/views/pilotage/entite/tableau_bord/widgets/consolidation_entity_view.dart';
import 'package:perf_rse/views/pilotage/entite/tableau_bord/widgets/data_table/not_admin_dashboard_header.dart';
import 'package:perf_rse/views/pilotage/entite/tableau_bord/widgets/data_table/row_indicateur.dart';
import '../../../../widgets/privacy_widget.dart';
import '../../controllers/drop_down_controller.dart';
import '../../controllers/side_menu_controller.dart';
import '../../controllers/tableau_controller.dart';
import 'widgets/collecte_status.dart';
import 'widgets/data_table/dashboard_header.dart';
import 'widgets/dashboard_list_view.dart';
import 'widgets/filtre_widget.dart';

class IndicateurScreen extends StatefulWidget {
  final Map? filtre;
  const IndicateurScreen({super.key, this.filtre});

  @override
  State<IndicateurScreen> createState() => _IndicateurScreenState();
}

class _IndicateurScreenState extends State<IndicateurScreen> {
  final tableauBordController = Get.put(TableauBordController());
  final DropDownController dropDownController = Get.find();
  final ProfilPilotageController profilPilotageController = Get.find();
  final PageController _controller = PageController(initialPage: 0);

  final SideMenuController sideMenuController = Get.find();

  bool showAdminHeader = true;

  void initIndicateurScreen() async {
    tableauBordController.initialisation(context);
  }

  @override
  void initState() {
    super.initState();
    initIndicateurScreen();
    _controller.addListener(() {
      setState(() {
        showAdminHeader = _controller.page?.round() == 0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool userAdminStatus = checkAccesProfil();
    bool reportedIndicatorChecked = tableauBordController.indicatorCheck.value;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 16, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        final location = GoRouter.of(context)
                            .location; //GoRouter.of(context).location
                        final path = location.split("/indicateurs").join("");
                        context.go(path);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Tableau de bord",
                    style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF3C3D3F),
                        fontWeight: FontWeight.bold),
                  ),
                  const Expanded(child: FiltreTableauBord()),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
            //const SizedBox(height: 5),
            Expanded(
                child: Column(
              children: [
                const CollecteStatus(),
                userAdminStatus
                    ? IndicateurTabs(pageController: _controller)
                    : const SizedBox(),
                if (showAdminHeader && userAdminStatus)
                  const AdminDashBoardHeader()
                else if (!showAdminHeader && userAdminStatus)
                  const SizedBox(), // Ajout de SizedBox pour l'espacement
                if (!userAdminStatus) const NotAdminDashBoardHeader(),
                Expanded(
                    child: Column(
                  children: [
                    Obx(() {
                      final isLoading = tableauBordController.isLoading.value;
                      final status =
                          tableauBordController.statusIntialisation.value;
                      if (profilPilotageController
                          .accesPilotageModel.value.estAdmin!) {
                        if (tableauBordController.indicatorCheck.value) {
                          tableauBordController.filtreIndicateursWithValues(tableauBordController.currentMonth.value);
                        } else {
                          tableauBordController.filtreListApparente();
                        }
                      } else {
                        if (tableauBordController.indicatorCheck.value) {
                          tableauBordController.filtreIndicateursWithValues(tableauBordController.currentMonth.value);
                        } else {
                          tableauBordController.filtreListApparenteOtherUser();
                        }
                      }
                      return Expanded(
                          child: Container(
  child: isLoading
      ? loadingWidget() // Affichez un widget de chargement si isLoading est vrai
      : status
          ? userAdminStatus
                  ? dropDownController.filtreProcessus.isNotEmpty
                      || reportedIndicatorChecked
                          ? PageView(
                              controller: _controller, // Ajoutez le contrôleur de page
                              children: <Widget>[
                                StyledScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: tableauBordController
                                        .indicateursListApparente
                                        .map((indicateur) {
                                      return RowIndicateur(indicateur: indicateur);
                                    }).toList(),
                                  ),
                                ),
                                const ConsolidationEntityTable(), // AllMonthsTable()
                              ],
                            )
                  :  PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _controller,
                          children: <Widget>[
                            DashBoardListViewAdmin(
                                indicateurs: tableauBordController
                                    .indicateursListApparente),
                            const ConsolidationEntityTable(),
                          ],
                        )
              : StyledScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tableauBordController
                        .indicateursListApparente
                        .map((indicateur) {
                      return RowIndicateur(indicateur: indicateur);
                    }).toList(),
                  ),
                ) // Affichez une colonne d'indicateurs si l'utilisateur n'a pas accès
          : const Center(
              child: Text("Aucune Donnée"), // Affichez un message "Aucunes données" si le statut est faux
            ),
)
);
                    }),
                    const SizedBox(height: 10),
                    const PrivacyWidget(),
                    const SizedBox(height: 10)
                  ],
                ))
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return const Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: Colors.grey,
                strokeWidth: 4,
              )),
          SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                  color: Colors.amber, strokeWidth: 4)),
        ],
      ),
    );
  }

  bool checkAccesProfil() {
    final access = profilPilotageController.accesPilotageModel.value;
    if (access.estAdmin == true) {
      return true;
    }
    return false;
  }
}

class IndicateurTabs extends StatefulWidget {
  const IndicateurTabs({required this.pageController, super.key});

  final PageController pageController;

  @override
  State<IndicateurTabs> createState() => _IndicateurTabsState();
}

class _IndicateurTabsState extends State<IndicateurTabs>
    with TickerProviderStateMixin {
  late final TabController _controller;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      vsync: this,
      initialIndex: selectedIndex,
    );
    _controller.addListener(() {
      widget.pageController.jumpToPage(_controller.index);
      setState(() {
        selectedIndex = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      padding: const EdgeInsets.only(left: 20),
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      controller: _controller,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor:const Color.fromARGB(255, 27, 193, 187), 
      tabs: [
        IndicateurTab(text: "Edition", isSelected: selectedIndex == 0),
        IndicateurTab(text: "Vue d'ensemble", isSelected: selectedIndex == 1),
      ],
    );
  }
}

class IndicateurTab extends StatelessWidget {
  const IndicateurTab(
      {required this.text, required this.isSelected, super.key});
  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Text(
        text,
        style: isSelected
            ? const TextStyle(
                fontFamily: 'MyriadPro',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color.fromARGB(255, 27, 193, 187),
              )
            : const TextStyle(
                fontFamily: 'MyriadPro',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color:Color.fromARGB(255, 27, 193, 187),
              ),
      ),
    );
  }
}
