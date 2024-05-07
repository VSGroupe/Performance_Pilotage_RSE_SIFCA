import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/pilotage_utils.dart';
import '../../../widgets/copyright.dart';
import '../../../widgets/loading_widget.dart';
import 'widgets/appbar_pilotage_home.dart';
import 'widgets/content_pilotage_home.dart';
import 'widgets/header_pilotage_home.dart';

class PilotageHome extends StatefulWidget {
  const PilotageHome({Key? key}) : super(key: key);

  @override
  State<PilotageHome> createState() => _PilotageHomeState();
}

class _PilotageHomeState extends State<PilotageHome> {

  final storage = const FlutterSecureStorage();
  final supabase = Supabase.instance.client;
  late Future<Map> pilotageHomeData;


  Future<Map> loadDataPilotageHome() async{
    var data = {};
    String? email = await storage.read(key: 'email');
    final user = await supabase.from('Users').select().eq('email', email!);
    final accesPilotage = await supabase.from('AccesPilotage').select().eq('email', email);
    data["user"] = user[0] ;
    data["accesPilotage"] = accesPilotage[0] ;
    if(chekcAccesPilotage(accesPilotage[0]) == false) {
      await Future.delayed(const Duration(milliseconds: 15));
      context.go("/");
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    pilotageHomeData = loadDataPilotageHome();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map?>(
      future: pilotageHomeData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: LoadingWidget(),
            ),
          );
        }
        final data = snapshot.data!;
        return Scaffold(
          body: Column(
            children: [
              AppBarPilotageHome(title: "Pilotage", pilotageHomeData: data,),
              Expanded(child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background_image.jpg"), fit: BoxFit.fitWidth)),
                child: Stack(
                  children: [
                    const Column(
                      children: [
                        HeaderPilotageHome(),
                        Expanded(child: ContentPilotageHome())
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: InkWell(
                        onTap: () {
                          context.go("/");
                        },
                        child: Image.asset("assets/icons/page-daccueil.png",width: 75,),
                      ),
                    )
                  ],
                ),
              )),
              const CopyRight()
            ],
          ),
        );
      },
    );
  }
}
