import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';

import '../utils/utils.dart';

class PrivacyWidget extends StatefulWidget {
  const PrivacyWidget({super.key});

  @override
  State<PrivacyWidget> createState() => _PrivacyWidgetState();
}

class _PrivacyWidgetState extends State<PrivacyWidget> {
  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.round();
    String responsive = responsiveRule(width);
    return responsive == "cas-0"? Container() : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("© 2023 Vision & Stratégie Groupe",style: TextStyle(fontSize: responsive =="cas-1"? 12 : null),),
        const SizedBox(width: 15,),
        Text(tr. privacy,style: TextStyle(color: const Color(0xFF114693),fontSize: responsive =="cas-1"? 12 : null),),
        const SizedBox(width: 15,),
        Text(tr.termsConditions,style: TextStyle(color: const Color(0xFF114693),fontSize: responsive =="cas-1"? 12 : null),)
      ],
    );
  }
}
