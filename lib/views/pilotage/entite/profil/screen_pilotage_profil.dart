import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/profil_pilotage_controller.dart';
import 'profil_pilotage.dart';


class ScreenPilotageProfil extends StatefulWidget {
  /// Constructs a [ScreenPilotageProfil] widget.
  const ScreenPilotageProfil({super.key});

  @override
  State<ScreenPilotageProfil> createState() => _ScreenPilotageProfilState();
}

class _ScreenPilotageProfilState extends State<ScreenPilotageProfil> {

  final storage = const FlutterSecureStorage();
  final ProfilPilotageController profilController = Get.find();

  final supabase = Supabase.instance.client;

  @override
  void initState(){
    profilController.updateProfil();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 16,left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr.profile,style: const TextStyle(fontSize: 24,color: Color(0xFF3C3D3F),fontWeight: FontWeight.bold),),
                const SizedBox(height: 5,),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: Container(
                          child:  const ProfilPilotage()
                       ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
  }

}