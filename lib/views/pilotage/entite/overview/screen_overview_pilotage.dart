import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/supabse_db.dart';
import '../../../../helper/helper_methods.dart';
import '../../../../widgets/privacy_widget.dart';
import '../../controllers/entite_pilotage_controler.dart';
import '../../controllers/overview_pilotage_controller.dart';
import 'overview_pilotage.dart';

class ScreenOverviewPilotage extends StatefulWidget {
  /// Constructs a [ScreenOverviewPilotage] widget.
  const ScreenOverviewPilotage({super.key});

  @override
  State<ScreenOverviewPilotage> createState() => _ScreenOverviewPilotageState();
}

class _ScreenOverviewPilotageState extends State<ScreenOverviewPilotage> {

  bool _isLoaded = false;
  late ScrollController _scrollController;
  final DataBaseController apiClient =  DataBaseController();
  final EntitePilotageController entitePilotageController = Get.find();

  final overviewPilotageController = Get.put(OverviewPilotageController());


  void loadScreen() async {
    final annee = DateTime.now().year;
    final entite = entitePilotageController.currentEntite.value;
    apiClient.updateSuiviDataEntite(entite,annee, null, null, null);
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    loadScreen();
    _scrollController = ScrollController();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    bool display = _isLoaded;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16,left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Accueil",style: TextStyle(fontSize: 24,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            display ? Expanded(child: Theme(
              data: Theme.of(context).copyWith(scrollbarTheme: ScrollbarThemeData(
                trackColor:  MaterialStateProperty.all(Colors.black12),
                trackBorderColor: MaterialStateProperty.all(Colors.black38),
                thumbColor: MaterialStateProperty.all(const Color(0xFF80868B)),
                interactive: true,
              )),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 8,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OverviewPilotage(),
                        Column(
                          children: [
                            SizedBox(height: 20,),
                            PrivacyWidget(),
                            SizedBox(height: 20,),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )) : Expanded(
              child: Column(
                children: [
                  Expanded(child: Center(
                    child: loadingPageWidget(),//const SpinKitRipple(color: Colors.blue,),
                  )),
                  const SizedBox(height: 20,),
                  const PrivacyWidget(),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}