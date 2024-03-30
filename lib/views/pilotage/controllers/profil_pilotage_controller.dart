import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/common/user_model.dart';
import '../../../models/pilotage/acces_pilotage_model.dart';

class ProfilPilotageController extends GetxController{

  var userModel= UserModel(email:"").obs;
  var accesPilotageModel= AccesPilotageModel(email:"", entite: []).obs;
  final storage = const FlutterSecureStorage();
  final supabase = Supabase.instance.client;

  Future updateProfil() async {
    var data = {};
    String? email = await storage.read(key: 'email');
    final user = await supabase.from('Users').select().eq('email', email);
    final accesPilotage = await supabase.from('AccesPilotage').select().eq('email', email);
    data["user"] = user[0] ;
    data["accesPilotage"] = accesPilotage[0] ;
    userModel.value= UserModel.fromJson(data["user"]);
    accesPilotageModel.value= AccesPilotageModel.fromJson(data["accesPilotage"]);
  }
}