import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../models/pilotage/data_indicateur_model.dart';
import '../../../../../models/pilotage/indicateur_model.dart';
import '/views/pilotage/controllers/tableau_controller.dart';
import 'data_table/row_axe.dart';

class DashBoardListViewAdmin extends StatefulWidget {
  final List<IndicateurModel> indicateurs;
  const DashBoardListViewAdmin({Key? key, required this.indicateurs})
      : super(key: key);

  @override
  State<DashBoardListViewAdmin> createState() => _DashBoardListViewAdminState();
}

class _DashBoardListViewAdminState extends State<DashBoardListViewAdmin> {
  late ScrollController _scrollController;
  final TableauBordController tableauBordController = Get.find();
  DataIndicateurModel? dataRowIndicateur;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildIndicateurWidget(widget.indicateurs);
  }

  Widget buildIndicateurWidget(List<IndicateurModel> indicateurs) {
    return Theme(
      data: Theme.of(context).copyWith(
          scrollbarTheme: ScrollbarThemeData(
        trackColor: MaterialStateProperty.all(Colors.black12),
        trackBorderColor: MaterialStateProperty.all(Colors.black38),
        thumbColor: MaterialStateProperty.all(Colors.black),
        interactive: true,
      )),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 8,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              padding: const EdgeInsets.only(right: 15),
              child: buildAllPilierRow(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAllPilierRow() {
    List<IndicateurModel> listIndicateurs = widget.indicateurs;
    return Column(
      children: [
        RowAxeGeneral(
          title: "GÉNÉRAL",
          color: Colors.brown,
          idAxe: "axe_0",
          indicateurs: listIndicateurs,
        ),
        RowAxe(
          title: "Gouvernance et éthique",
          color: const Color(0xFF3F93D0),
          idAxe: "axe_1",
          imagePath: "assets/icons/gouvernance.png",
          indicateurs: listIndicateurs,
        ),
        RowAxe(
          title: "Emploi et conditions de travail",
          color: const Color(0xFFEABF64),
          idAxe: "axe_2",
          imagePath: "assets/icons/economie.png",
          indicateurs: listIndicateurs,
        ),
        RowAxe(
          title: "Communauté et innovation sociétale",
          color: const Color(0xFFFAAF7B),
          idAxe: "axe_3",
          imagePath: "assets/icons/social.png",
          indicateurs: listIndicateurs,
        ),
        RowAxe(
          title: "Préservation de l’Environnement",
          color: const Color(0xFF97C3A8),
          idAxe: "axe_4",
          imagePath: "assets/icons/environnement.png",
          indicateurs: listIndicateurs,
        ),
      ],
    );
  }
}
