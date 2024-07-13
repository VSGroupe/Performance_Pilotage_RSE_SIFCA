import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/utils/i18n.dart';

class SideMenuController extends GetxController {
  var selectedMenu =tr.overview.obs;
  var cas4Extended = true.obs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }else {
      _scaffoldKey.currentState!.closeDrawer();
    }
  }

  void controlMenuEnd() {
    if (!_scaffoldKey.currentState!.isEndDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    }else {
      _scaffoldKey.currentState!.closeEndDrawer();
    }
  }

  bool checkIsDrawerOpen(){
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      return false;
    }else {
      return true;
    }
  }
  void controlMenuCas4(){
    cas4Extended.value = !cas4Extended.value;
  }
  void changeCurrentMenu(String titleMenu){
    selectedMenu.value = titleMenu;
  }
}