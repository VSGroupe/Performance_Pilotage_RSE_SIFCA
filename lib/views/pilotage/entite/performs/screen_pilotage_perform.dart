import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/helper_methods.dart';
import '../../../../widgets/privacy_widget.dart';
import 'perform_pilotage.dart';
import '../../controllers/performs_data_controller.dart';
import 'widgets/entete_performance.dart';

class ScreenPilotagePerform extends StatefulWidget {
  /// Constructs a [ScreenPilotagePerform] widget.
  const ScreenPilotagePerform({super.key});

  @override
  State<ScreenPilotagePerform> createState() => _ScreenPilotagePerformState();
}

class _ScreenPilotagePerformState extends State<ScreenPilotagePerform> {
  //bool _isLoaded = false;
  final PerformsDataController performsDataController =
      Get.put(PerformsDataController());

  void loadScreen() async {
    performsDataController.isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    performsDataController.isLoading.value = false;
  }

  @override
  void initState() {
    super.initState();
    loadScreen();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(() {
        bool isLoading = performsDataController.isLoading.value;
        return Padding(
          padding: const EdgeInsets.only(top: 16, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Performances",
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF3C3D3F),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              const EntetePerformance(),
              const SizedBox(
                height: 5,
              ),
              isLoading
                  ? Expanded(
                      child: Column(
                        children: [
                          Expanded(
                              child: Center(
                            child: loadingPageWidget(),
                          )),
                          const SizedBox(
                            height: 10,
                          ),
                          const PrivacyWidget(),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  : const Expanded(
                      child: Column(
                        children: [
                          Expanded(child: PerformPilotage()),
                          SizedBox(
                            height: 10,
                          ),
                          PrivacyWidget(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
            ],
          ),
        );
      }),
    );
  }
}
