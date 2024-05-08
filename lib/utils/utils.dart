import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

import '../models/pilotage/acces_pilotage_model.dart';

const storage = FlutterSecureStorage();

bool verifyEmail(String email){
  // On accepte que les mail de type visionstrategie.com ou sifca.com example.com
  if (GetUtils.isEmail(email)){
    return true;
  }
  return false;
}


String getAccesTypeUtils(AccesPilotageModel accesPilotageModel) {
  if (accesPilotageModel.estAdmin ?? false) {
    return "Admin";
  }
  if (accesPilotageModel.estValidateur ?? false) {
    return "Validateur";
  }
  if (accesPilotageModel.estEditeur ?? false) {
    return "Editeur";
  }
  if (accesPilotageModel.estSpectateur ?? false) {
    return "Spectateur";
  }
  return "";
}

String responsiveRule(int width){
  if (width <= 480) {
    return "cas-0";
  }else if (width <= 570) {
    return "cas-1";
  }else if( width <= 1025){
    return "cas-2";
  }else if( width <= 1285){
    return "cas-3";
  }else {
    return "cas-4";
  }
}

String valueToDisplayValue(double value){
  double num = value;
  int magnitude = 0 ;
  while( num.abs() >= 1000){
    magnitude += 1;
    num /= 1000.0;
  }
  double result = math.pow(1000, magnitude) as double;
  return '${result.toStringAsFixed(2)}${['', 'K', 'M', 'B', 'T'][magnitude]}';
}

Future<String> getCountryCityFromIP(String ipAddress) async {
  try {
    final response = await http.get(Uri.parse('http://ip-api.com/json/$ipAddress'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['status'] == 'success') {
        String country = responseData['country'] ?? '';
        String city = responseData['city'] ?? '';

        if (country.isNotEmpty && city.isNotEmpty) {
          return '$country, $city';
        }
      }
    }
  } catch (e) {
    return '---';
  }

  return '---';
}

void showDebugMessage(BuildContext context,String message){
  var snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

bool verifyCode(String code){
  try {
    if (code.length != 6) {
      return false;
    }
    int.parse(code);
    return true;
  } catch (e) {
    return true;
  }
}

bool validatePassword(String value) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

String hashPassword(String password){
  var bytes = utf8.encode(password);
  String hashPassword = sha256.convert(bytes).toString();
  return hashPassword;
}
