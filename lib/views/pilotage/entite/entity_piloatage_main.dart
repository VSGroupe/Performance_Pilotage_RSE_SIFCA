import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../helper/helper_methods.dart';
import '../../../models/common/user_model.dart';
import '../../../models/pilotage/acces_pilotage_model.dart';
import '../../../utils/pilotage_utils.dart';
import '../controllers/entite_pilotage_controler.dart';
import '../controllers/profil_pilotage_controller.dart';
import '/views/pilotage/entite/widgets/app_bar_pilotage.dart';
import '../../../utils/utils.dart';
import '../controllers/side_menu_controller.dart';
import 'widgets/drawer_menu_pilotage.dart';
import 'widgets/menu_nav_pilotage.dart';

class EntityPilotageMain extends StatefulWidget {
  final Widget child;
  final String? entiteId;
  const EntityPilotageMain(
      {super.key, required this.child, required this.entiteId});

  @override
  State<EntityPilotageMain> createState() => _EntityPilotageMainState();
}

class _EntityPilotageMainState extends State<EntityPilotageMain> {
  final SideMenuController sideMenuController = Get.put(SideMenuController());
  final ProfilPilotageController profilController =
      Get.put(ProfilPilotageController());
  final EntitePilotageController entitePilotageController =
      Get.put(EntitePilotageController());

  final storage = const FlutterSecureStorage();
  final supabase = Supabase.instance.client;

  bool isLoaded = false;

  List listEntites = [
    "comex", "groupe-sifca", "caoutchouc-naturel", "sifca-holding",
    "oleagineux", "sucre", //6
    "sucrivoire", "sucrivoire-siege", "sucrivoire-borotou-koro",
    "sucrivoire-zuenoula", //4
    "palmci",
    "palmci-siege",
    "palmci-blidouba",
    "palmci-boubo",
    "palmci-ehania",
    "palmci-gbapet",
    "palmci-iboke",
    "palmci-irobo",
    "palmci-neka",
    "palmci-toumanguie", //9
    "sania", "mopp", "golden-sifca", "thsp", //3
    "saph", "saph-siege", "saph-bettie", "saph-bongo", "saph-loeth",
    "saph-ph-cc", "saph-rapides-grah", "saph-toupah", "saph-yacoli", //9
    "grel", "grel-tsibu", "grel-apimenim", //3,
    "siph", "crc", "renl" // 3
  ];

  Future<bool> creatingDataEntite() async {
    return true;
  }

  Future<List>getSousEntitesName(List sousEntites) async {
    if (sousEntites.isNotEmpty) {
      List<String> result = [];
      for (String? entity in sousEntites) {
        List<Map<String, dynamic>> response = await supabase
            .from('Entites')
            .select('nom_entite')
            .eq('id_entite', entity!);
        String entityName = response[0]['nom_entite'];
        result.add(entityName);
      }
      return result;
    } else {
      return [];
    }
  }

  Future<Map> chekUserAccesPilotage() async {
    var data = {};

    if (widget.entiteId == null) {
      context.go("/");
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar("Cet espace n'existe pas.", "", Colors.red));
      return data;
    }

    if (listEntites.contains(widget.entiteId) != true) {
      context.go("/pilotage");
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar("Cet espace n'existe pas.", "", Colors.red));
      return data;
    }

    final entiteResponse = await supabase
        .from('Entites')
        .select()
        .eq('id_entite', widget.entiteId!);
    final entite = entiteResponse[0];
    //print(entite);

    if (entite["id_entite"] == null || entite["id_entite"] == "") {
      context.go("/pilotage");
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar("Cet espace n'existe pas.", "", Colors.red));
      return data;
    }

    if (entite["is_creating_data"] == false) {
      final resultCreatingData = await creatingDataEntite();
      context.go("/pilotage");
      if (resultCreatingData) {
        ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
            "Les données ont été crées. Retournez à l'espace précédent.",
            "",
            Colors.green));
        return data;
      }
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
          "Les données n'ont pas pu être créer dans cet espace.",
          "",
          Colors.red));
      return data;
    }

    String? email = await storage.read(key: 'email');
    final user = await supabase.from('Users').select().eq('email', email!);
    final accesPilotage =
        await supabase.from('AccesPilotage').select().eq('email', email);
    final checkEntite = await entitePilotageController.initialisation();
    //print(checkEntite);
    data["user"] = user[0];
    data["accesPilotage"] = accesPilotage[0];
    final currentEntite = GoRouter.of(context)!.location.split("/")[3];
    final responseAppartenance = await supabase
        .from('Entites')
        .select('groupe')
        .eq('id_entite', currentEntite);
    final responseLanguage = await supabase
        .from('Entites')
        .select('langue')
        .eq('id_entite', currentEntite);
    PostgrestList responseSousEntite = await supabase
        .from('Entites')
        .select('sous_entites')
        .eq('id_entite', currentEntite);
    entitePilotageController.entityAppartenance.value =
        responseAppartenance.first["groupe"];
    final responseFiliereAndFialiale = await supabase
        .from('Entites')
        .select('filiale, filiere')
        .eq('id_entite', currentEntite);
    entitePilotageController.filialeCurrentEntity.value =
        responseFiliereAndFialiale.first["filiale"];
    entitePilotageController.filiereCurrentEntity.value =
        responseFiliereAndFialiale.first["filiere"];
    entitePilotageController.langue = responseLanguage.first["langue"];
    try {
      entitePilotageController.sousEntite.value = responseSousEntite[0]["sous_entites"];
      entitePilotageController.sousEntiteName.value =
          await getSousEntitesName(responseSousEntite[0]["sous_entites"]);
    } catch (e) {
      print(e);
    }

    // Pour l'admin
    if (accesPilotage[0]["est_admin"] == true && checkEntite == true) {
      entitePilotageController.currentEntite.value = currentEntite;
      profilController.userModel.value = UserModel.fromJson(data["user"]);
      profilController.accesPilotageModel.value =
          AccesPilotageModel.fromJson(data["accesPilotage"]);
      setState(() {
        isLoaded = true;
      });
      return data;
    }

    if (chekcAccesPilotage(accesPilotage[0]) == false &&
        data["accesPilotage"]["entite"] != currentEntite &&
        checkEntite == false) {
      context.go("/pilotage");
      return data;
    }
    entitePilotageController.currentEntite.value = currentEntite;
    profilController.userModel.value = UserModel.fromJson(data["user"]);
    profilController.accesPilotageModel.value =
        AccesPilotageModel.fromJson(data["accesPilotage"]);
    setState(() {
      isLoaded = true;
    });
    return data;
  }

  @override
  void initState() {
    chekUserAccesPilotage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.round();
    String responsive = responsiveRule(width);

    return isLoaded == false
        ? Scaffold(body: Center(child: loadingPageWidget()))
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Obx(() {
                final shortName =
                    "${profilController.userModel.value.prenom![0]}${profilController.userModel.value.nom![0]}";
                return AppBarPilotage(
                  shortName: shortName,
                );
              }),
            ),
            body: Scaffold(
              key: sideMenuController.scaffoldKey,
              drawer: const DrawerMenuPilotage(),
              endDrawer: const SizedBox(
                width: 250,
                child: Drawer(),
              ),
              body: Row(
                children: [
                  MenuNavPilotage(responsive: responsive),
                  Expanded(child: widget.child)
                ],
              ),
            ),
          );
  }
}
