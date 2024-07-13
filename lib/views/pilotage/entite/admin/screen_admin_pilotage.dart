import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';
import '../../../../helper/helper_methods.dart';
import '../../../../widgets/privacy_widget.dart';
import 'admin_pilotage.dart';

class ScreenPilotageAdmin extends StatefulWidget {

  const ScreenPilotageAdmin({super.key});

  @override
  State<ScreenPilotageAdmin> createState() => _ScreenPilotageAdminState();
}

class _ScreenPilotageAdminState extends State<ScreenPilotageAdmin> {
  bool _isLoaded = false;

  void loadScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadScreen();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16,left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(tr.adminPanelText,style: const TextStyle(fontSize: 24,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
            const SizedBox(height: 5,),
            _isLoaded ? Expanded(
              child: Column(
                children: [
                  Expanded(child: Container(
                    child: const AdministrationPilotage(),
                  )),
                  const SizedBox(height: 10,),
                  const PrivacyWidget(),
                  const SizedBox(height: 20,),
                ],
              ),
            ) : Expanded(
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