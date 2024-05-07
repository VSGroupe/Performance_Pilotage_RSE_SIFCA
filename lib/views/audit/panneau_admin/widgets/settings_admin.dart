import 'package:flutter/material.dart';

class SettingAdmin extends StatefulWidget {
  const SettingAdmin({super.key});

  @override
  State<SettingAdmin> createState() => _SettingAdminState();
}

class _SettingAdminState extends State<SettingAdmin> {
  bool visible = true;
  bool visible1 = true;
  bool visible2 = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Expanded(
          child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 140,
              padding: EdgeInsets.all(6),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        spreadRadius: 0,
                        color: Color(0xFF00000040).withOpacity(0.5))
                  ]),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Notifications",style:TextStyle(
                        fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold
                      )),
                      Expanded(child: Container()),
                      Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Switch(
                            value: visible,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setState(() {
                                visible = value;
                              });
                            }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text("Restreindre l'application aux responsables d'audit",style:TextStyle(
                          fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold
                      )),
                      Expanded(child: Container()),
                      Padding(
                        padding:  EdgeInsets.only(right: 6),
                        child: Switch(
                            value: visible1,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setState(() {
                                visible1 = value;
                              });
                            }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Text("Restreindre l'application aux responsables d'audit",style:TextStyle(
                          fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold
                      )),
                      Expanded(child: Container()),
                      Padding(
                        padding:  EdgeInsets.only(right: 6),
                        child: Switch(
                            value: visible2,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setState(() {
                                visible2 = value;
                              });
                            }),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
