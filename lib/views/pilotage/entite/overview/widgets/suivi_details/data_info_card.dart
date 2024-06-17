import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';

import '../../../../../../constants/constant_double.dart';

class DataSuiviCard extends StatelessWidget {
  const DataSuiviCard({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.nombre,
    required this.total, required this.color,
  }) : super(key: key);

  final String title, svgSrc, nombre;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: color),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Image.asset(svgSrc),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    "$total ${tr.indicators}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Text(nombre)
        ],
      ),
    );
  }
}
