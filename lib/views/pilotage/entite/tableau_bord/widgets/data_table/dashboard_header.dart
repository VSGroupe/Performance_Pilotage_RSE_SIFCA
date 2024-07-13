import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/utils/i18n.dart';

import '../../../../controllers/tableau_controller.dart';

class AdminDashBoardHeader extends StatefulWidget {
  const AdminDashBoardHeader({Key? key}) : super(key: key);

  @override
  State<AdminDashBoardHeader> createState() => _AdminDashBoardHeaderState();
}

class _AdminDashBoardHeaderState extends State<AdminDashBoardHeader> {
  final TableauBordController tableauBordController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.brown,
      child: Container(
          padding: const EdgeInsets.only(left: 2.0, right: 15),
          child: Container(
            height: 30,
            width: double.maxFinite,
            color: Colors.brown,
            child: Obx(() {
              var annee = tableauBordController.currentYear.value;
              var mois = tableauBordController
                  .listMonth[tableauBordController.currentMonth.value - 1];
              return Row(
                children: [
                   AdminDashBoardHeaderTitle(
                    color: Colors.brown,
                    size: 110,
                    title: tr.reference,
                  ),
                   IndicateurTitle(
                    color: Colors.brown,
                    size: 100,
                    title:tr.title,
                  ),
                   AdminDashBoardHeaderTitle(
                    color: Colors.brown,
                    size: 120,
                    title: tr.process,
                  ),
                  AdminDashBoardHeaderTitle(
                    color: Colors.brown,
                    size: 150,
                    title: "${tr.completed} ${annee - 1}",
                  ),
                  AdminDashBoardHeaderTitle(
                    color: Colors.brown,
                    size: 150,
                    title: "${tr.completed} $annee",
                  ),
                  MonthHeader(
                    color: Colors.brown,
                    size: 170,
                    title: tr.monthLong(mois),
                  ),
                  // const AdminDashBoardHeaderTitle(
                  //   color: Colors.brown,
                  //   size: 100,
                  //   title: "Cible",
                  // ),
                   AdminDashBoardHeaderTitle(
                    color: Colors.brown,
                    size: 80,
                    title: tr.deviation,
                  ),

                   AdminDashBoardHeaderTitle(
                    color: Colors.brown,
                    size: 121,
                    title:tr.onOff,
                  ),
                ],
              );
            }),
          )),
    );
  }
}

class MonthHeader extends StatefulWidget {
  final double size;
  final Color color;
  final String title;
  const MonthHeader(
      {super.key,
      required this.size,
      required this.color,
      required this.title});

  @override
  State<MonthHeader> createState() => _MonthHeaderState();
}

class _MonthHeaderState extends State<MonthHeader> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        setState(() {
          isHovering = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 2.0),
        width: widget.size,
        color: isHovering ? const Color(0xFF8B735C) : widget.color,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminDashBoardHeaderTitle extends StatefulWidget {
  final double size;
  final Color color;
  final String title;
  const AdminDashBoardHeaderTitle(
      {Key? key, required this.size, required this.color, required this.title})
      : super(key: key);

  @override
  State<AdminDashBoardHeaderTitle> createState() => _AdminDashBoardHeaderTitleState();
}

class _AdminDashBoardHeaderTitleState extends State<AdminDashBoardHeaderTitle> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        setState(() {
          isHovering = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 2.0),
        width: widget.size,
        color: isHovering ? const Color(0xFF8B735C) : widget.color,
        alignment: Alignment.centerLeft,
        child: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class IndicateurTitle extends StatefulWidget {
  final double size;
  final Color color;
  final String title;
  const IndicateurTitle(
      {Key? key, required this.size, required this.color, required this.title})
      : super(key: key);

  @override
  State<IndicateurTitle> createState() => _IndicateurTitleState();
}

class _IndicateurTitleState extends State<IndicateurTitle> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        onHover: (value) {
          setState(() {
            isHovering = value;
          });
        },
        child: Container(
          width: widget.size, //double.infinity
          padding: const EdgeInsets.only(left: 2.0),
          color: isHovering ? const Color(0xFF8B735C) : widget.color,
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
