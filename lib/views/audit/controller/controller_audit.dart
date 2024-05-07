import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerAudit extends GetxController{
  var reference="".obs;
  var currentGestAudit=0.obs;

  @override
  void onInit() {
   reference.value="";
   currentGestAudit.value=0;
    super.onInit();
  }

}