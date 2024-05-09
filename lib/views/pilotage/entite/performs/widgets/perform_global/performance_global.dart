import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../controllers/performs_data_controller.dart';
import 'package:get/get.dart';
import '../../../../controllers/entite_pilotage_controler.dart';

class PerformanceGlobale extends StatefulWidget {
  const PerformanceGlobale({Key? key}) : super(key: key);

  @override
  State<PerformanceGlobale> createState() => _PerformanceGlobaleState();
}

class _PerformanceGlobaleState extends State<PerformanceGlobale> {
  bool isCardView = true;
  bool isWebFullView = true;
  bool _isLoaded = false;
  String entiteName = "";
  late double dataPerformGlobal = 0.0;

  final supabase = Supabase.instance.client;
  final PerformsDataController performsDataController = Get.find();
  final EntitePilotageController entitePilotageController = Get.find();

  void initialisationPerformsGlobal() async {
    final entiteID = entitePilotageController.currentEntite.value;
    final idPerformGlobal = "${entiteID}_${performsDataController.annee.value}";
    final List responsePerforms =
        await supabase.from('Performance').select().eq('id', idPerformGlobal);
    final List<dynamic> entite = await supabase
        .from('Entites')
        .select('nom_entite')
        .eq('id_entite', entiteID);
    var entiteval = entite.first["nom_entite"];
    entiteName = entiteval;

    dataPerformGlobal = responsePerforms.first["performs_global"];
    print(dataPerformGlobal);

    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      _isLoaded = true;
    });
  }

  // Widget noDataWidget(String message) {
  //   return Center(
  //     child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       IconButton(
  //         iconSize: 40,
  //         icon: const Icon(
  //           Icons.refresh,
  //           color: Colors.green,
  //         ),
  //         onPressed: () {},
  //         tooltip: "Réchager les données",
  //       ).scale(all: 1),
  //       const SizedBox(
  //         width: 50,
  //       ),
  //       Center(
  //           child: Text(
  //         message,
  //         style: const TextStyle(fontSize: 20),
  //       ))
  //     ]),
  //   );
  // }

  // Widget loadingWidget() {
  //   return const Center(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         SpinKitPouringHourGlassRefined(
  //           color: Colors.amber,
  //           size: 50.0,
  //         ),
  //         SizedBox(
  //           width: 50,
  //         ),
  //         Text(
  //           "Veillez patienter SVP",
  //           style: TextStyle(fontSize: 20),
  //         )
  //       ],
  //     ),
  //   );
  // }
  @override
  void initState() {
    initialisationPerformsGlobal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double data = dataPerformGlobal;

    return _isLoaded
        ? Column(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Performance Gloable ${performsDataController.annee.value}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(entiteName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
              _buildPerformanceGlobale(data),
            ],
          )
        : const Stack(
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
          );
  }

  SfRadialGauge _buildPerformanceGlobale(double performGloabal) {
    return SfRadialGauge(
      animationDuration: 3500,
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
            minimum: 0,
            maximum: 100,
            interval: 20,
            minorTicksPerInterval: 9,
            showAxisLine: false,
            radiusFactor: isWebFullView ? 0.8 : 0.9,
            labelOffset: 8,
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 80,
                  endValue: 100,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  color: const Color.fromRGBO(34, 144, 199, 0.75)),
              GaugeRange(
                  startValue: 80,
                  endValue: 60,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  color: const Color.fromRGBO(34, 195, 199, 0.75)),
              GaugeRange(
                  startValue: 50,
                  endValue: 60,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  color: const Color.fromRGBO(123, 199, 34, 0.75)),
              GaugeRange(
                  startValue: 30,
                  endValue: 50,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  color: const Color.fromRGBO(238, 193, 34, 0.75)),
              GaugeRange(
                  startValue: 0,
                  endValue: 30,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  color: const Color.fromRGBO(238, 79, 34, 0.65)),
            ],
            annotations: <GaugeAnnotation>[
              const GaugeAnnotation(
                  angle: 90,
                  positionFactor: 0.35,
                  widget: Text('Performance',
                      style:
                          TextStyle(color: Color(0xFFF8B195), fontSize: 15))),
              GaugeAnnotation(
                angle: 90,
                positionFactor: 0.8,
                widget: Text(
                  "${performGloabal.toStringAsFixed(2)} % ",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: performGloabal,
                needleStartWidth: isCardView ? 0 : 1,
                needleEndWidth: isCardView ? 5 : 8,
                animationType: AnimationType.easeOutBack,
                enableAnimation: true,
                animationDuration: 1200,
                knobStyle: KnobStyle(
                    knobRadius: isCardView ? 0.06 : 0.09,
                    borderColor: const Color(0xFFF8B195),
                    color: Colors.white,
                    borderWidth: isCardView ? 0.035 : 0.05),
                tailStyle: TailStyle(
                    color: const Color(0xFFF8B195),
                    width: isCardView ? 4 : 8,
                    length: isCardView ? 0.15 : 0.2),
                needleColor: const Color(0xFFF8B195),
              )
            ],
            axisLabelStyle: GaugeTextStyle(fontSize: isCardView ? 10 : 12),
            majorTickStyle: const MajorTickStyle(
                length: 0.25, lengthUnit: GaugeSizeUnit.factor),
            minorTickStyle: const MinorTickStyle(
                length: 0.13, lengthUnit: GaugeSizeUnit.factor, thickness: 1))
      ],
    );
  }

  // @override
  // void dispose() {
  //   super.dispose;
  // }
}
