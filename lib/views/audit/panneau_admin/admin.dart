import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter_toggle_tab/helper.dart';
import '../constant/constants.dart';
import 'widgets/list_auditeur_admin.dart';
import 'widgets/settings_admin.dart';



class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final ValueNotifier<int> _tabIndexBasicToggle = ValueNotifier(1);

  List<String> get _listTextTabToggle =>
      ["Listes des Auditeurs","Parametres de l'espace audit"];
  List<Widget> widgets=[
    SettingAdmin(),
    ListAuditeurAdmin()
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 8),
        child: Column(
          children: <Widget>[
            basicTabToggle(),
          ],
        )
    );
  }

  List<Widget> divider() =>
      [
        SizedBox(height: heightInPercent(3, context)),
        const Divider(thickness: 2),
        SizedBox(height: heightInPercent(3, context)),
      ];

  Widget basicTabToggle() =>
      Column(
        children: [
          Center(
            child: ValueListenableBuilder(
              valueListenable: _tabIndexBasicToggle,
              builder: (context, currentIndex, _) {
                return FlutterToggleTab(
                  // width in percent
                  width: 50,
                  borderRadius: 30,
                  height: 40,
                  selectedIndex: currentIndex,
                  selectedBackgroundColors: const [
                    activeColor,
                    activeColor,
                  ],
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  unSelectedTextStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  labels: _listTextTabToggle,
                  selectedLabelIndex: (index) {
                    _tabIndexBasicToggle.value = index;
                  },
                  isScroll: false,
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _tabIndexBasicToggle,
            builder: (context, currentIndex, _) {
              return widgets[currentIndex];
            },
          ),
        ],
      );
}