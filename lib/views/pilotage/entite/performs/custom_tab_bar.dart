import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key, required this.controller, required this.tabs});

  final TabController controller;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(controller: controller, tabs: tabs,),
    );
  }
}
