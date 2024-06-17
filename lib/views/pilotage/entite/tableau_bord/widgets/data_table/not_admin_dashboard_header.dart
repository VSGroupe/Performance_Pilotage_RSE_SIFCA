import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/utils/i18n.dart';

import '../../../../controllers/tableau_controller.dart';

class NotAdminDashBoardHeader extends StatefulWidget {
  const NotAdminDashBoardHeader({Key? key}) : super(key: key);

  @override
  State<NotAdminDashBoardHeader> createState() => _NotAdminDashBoardHeaderState();
}

class _NotAdminDashBoardHeaderState extends State<NotAdminDashBoardHeader> {
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
                   NotAdminDashBoardHeaderTitle(
                    color: Colors.brown,
                    size: 110,
                    title: tr.reference,
                  ),
                   IndicateurTitle(
                    color: Colors.brown,
                    size: 100,
                    title:tr.title,
                  ),
                   NotAdminDashBoardHeaderTitle(
                    color: Colors.brown,
                    size: 120,
                    title: tr.process,
                  ),
                  NotAdminDashBoardHeaderTitle(
                    color: Colors.brown,
                    size: 150,
                    title: "${tr.completed} ${annee - 1}",
                  ),
                  NotAdminDashBoardHeaderTitle(
                    color: Colors.brown,
                    size: 150,
                    title: "${tr.completed} $annee",
                  ),
                  MonthHeader(
                    color: Colors.brown,
                    size: 170,
                    title: mois,
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

class NotAdminDashBoardHeaderTitle extends StatefulWidget {
  final double size;
  final Color color;
  final String title;
  const NotAdminDashBoardHeaderTitle(
      {Key? key, required this.size, required this.color, required this.title})
      : super(key: key);

  @override
  State<NotAdminDashBoardHeaderTitle> createState() => _NotAdminDashBoardHeaderTitleState();
}

class _NotAdminDashBoardHeaderTitleState extends State<NotAdminDashBoardHeaderTitle> {
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