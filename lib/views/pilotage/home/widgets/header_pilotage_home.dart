import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';

import '../../../../constants/constant_colors.dart';
import '../../../../widgets/custom_text.dart';

class HeaderPilotageHome extends StatefulWidget {
  const HeaderPilotageHome({Key? key}) : super(key: key);

  @override
  State<HeaderPilotageHome> createState() => _HeaderPilotageHomeState();
}

class _HeaderPilotageHomeState extends State<HeaderPilotageHome> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: tr.pilotageHearder,
                weight: FontWeight.bold,
                size: 30,
              ),
              const SizedBox(width: 20,),
              Container(
                child: Image.asset("assets/logos/perf_rse.png",height: 50,fit: BoxFit.fill,),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
              ),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 6),
                              color: lightGrey.withOpacity(.1),
                              blurRadius: 12)
                        ],
                        border: Border.all(color: lightGrey, width: .5),),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          'assets/images/bannieresifca.png',
                          fit: BoxFit.fill,
                        )),
                  )),
              Container(
                width: 80,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

