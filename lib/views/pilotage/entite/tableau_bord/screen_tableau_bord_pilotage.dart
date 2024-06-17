import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../helper/helper_methods.dart';
import '../../../../utils/pilotage_utils.dart';
import '../../../../widgets/privacy_widget.dart';
import '../../controllers/drop_down_controller.dart';
import 'strategy_card.dart';

class ScreenTableauBordPilotage extends StatefulWidget {
  /// Constructs a [ScreenTableauBordPilotage] widget.
  const ScreenTableauBordPilotage({super.key});

  @override
  State<ScreenTableauBordPilotage> createState() => _ScreenTableauBordPilotageState();
}

class _ScreenTableauBordPilotageState extends State<ScreenTableauBordPilotage> {

  final dropDownController = Get.put(DropDownController());

  final storage = const FlutterSecureStorage();
  final supabase = Supabase.instance.client;
  bool isLoaded = false;

  Future chekUserAccesPilotage() async{
    var data = {};
    String? email = await storage.read(key: 'email');
    final user = await supabase.from('Users').select().eq('email', email!);
    final accesPilotage = await supabase.from('AccesPilotage').select().eq('email', email);
    data["user"] = user[0] ;
    data["accesPilotage"] = accesPilotage[0] ;
    if(chekcAccesPilotage(accesPilotage[0]) ==false) {
      context.go("/");
    }
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    chekUserAccesPilotage();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded == false ? Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Padding(
        padding: const EdgeInsets.only(top: 16,left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(tr.dashboard,style: const TextStyle(fontSize: 24,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
            Expanded(child: Center(child: loadingPageWidget())),
          ],
        ),
      ),) : Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 16,left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(tr.dashboard,style: const TextStyle(fontSize: 24,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                Center(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      width: 450,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child:  Center(child: Text(tr.governanceSustainableDevelopmentStrategy,
                        style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                const Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          StrategieContainer(),
                          SizedBox(height: 10,),
                          PrivacyWidget(),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
  }
}