import 'package:flutter/material.dart';
import 'package:perf_rse/widgets/custom_text.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import '../../constant/constants.dart';


class InfoGeneral extends StatefulWidget {
  const InfoGeneral({Key? key}) : super(key: key);

  @override
  State<InfoGeneral> createState() => _InfoGeneralState();
}

class _InfoGeneralState extends State<InfoGeneral> {
  ScrollController _scrollController = ScrollController();
  late TextEditingController respoTextEditingController;

  String? prenom = "";


  @override
  void initState() {
    respoTextEditingController=TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                    height: 250,
                    child: VsScrollbar(
                      controller: _scrollController,
                      showTrackOnHover: true,
                      isAlwaysShown: true,
                      scrollbarFadeDuration: const Duration(
                          milliseconds:
                          500),
                      scrollbarTimeToFade: const Duration(
                          milliseconds:
                          800),
                      style: const VsScrollbarStyle(
                        hoverThickness: 10.0,
                        radius:
                        Radius.circular(10),
                        thickness: 10.0,
                        color: Colors.black,
                      ),
                      child: ListView(
                        padding: const EdgeInsets.only(right: 12),
                        controller: _scrollController,
                        children: [
                          const Text("Entreprise ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              )),
                          Padding(
                              padding:
                              const EdgeInsets.only(bottom: 10.0, top: 2.0),
                              child: Container(
                                height: 80,
                                width: double.infinity,
                                child: Card(
                                  surfaceTintColor: Colors.white,
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          const CircleAvatar(
                                            backgroundColor: Color(0xFFFFFF00),
                                            child: Center(
                                              child: Text('Logo',
                                                  style: TextStyle(
                                                    color: Color(0xFFF4DA08),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  )),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          TextButton(
                                              onPressed: () {},
                                              child: const Text(
                                                "Entreprise ABC",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue),
                                              )),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          IconButton(onPressed:(){},
                                              icon: Icon(Icons.mode_edit_outlined,size:40,color:activeColor,))
                                        ]),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text("Auditeurs ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              )),
                          Padding(
                              padding:
                              const EdgeInsets.only(bottom: 0.0, top: 2.0),
                              child: Container(
                                height: 190,
                                width: double.infinity,
                                child: Card(
                                  surfaceTintColor: Colors.white,
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 12.0, top: 15, right: 20),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text: "Responsable d'audit",
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 300,
                                                    height: 35,
                                                    child: TextFormField(
                                                      controller:
                                                      respoTextEditingController,
                                                      decoration: InputDecoration(
                                                          border:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                          ),
                                                          hintText: "",
                                                          // contentPadding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20, bottom: 10),
                                                          contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0.0,
                                                              horizontal: 5.0),
                                                          // border: OutlineInputBorder(),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Color(0xFFF77300),
                                                                  width: 2))),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  CustomText(
                                                    text: "Autres auditeurs",
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 300,
                                                    height: 35,
                                                    child: TextFormField(
                                                      controller:
                                                      respoTextEditingController,
                                                      decoration: InputDecoration(
                                                          border:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                          ),
                                                          hintText: "",

                                                          // contentPadding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20, bottom: 10),
                                                          contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0.0,
                                                              horizontal: 5.0),
                                                          // border: OutlineInputBorder(),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Color(0xFFF77300),
                                                                  width: 2))),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    CustomText(
                                                      text: "Période",
                                                      size: 15,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                      respoTextEditingController,
                                                      decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                20.0),
                                                          ),
                                                          hintText: "",
                                                          // contentPadding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20, bottom: 10),
                                                          contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 40.0,
                                                              horizontal: 0.0),
                                                          // border: OutlineInputBorder(),
                                                          focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Color(0xFFF77300),
                                                                  width: 2))),
                                                    ),
                                                  ]))
                                        ]),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          const Text("Informations sur l'audit ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              )),
                          Padding(
                              padding:
                              const EdgeInsets.only(bottom: 0.0, top: 2.0),
                              child: Container(
                                height: 230,
                                width: double.infinity,
                                child: Card(
                                  surfaceTintColor: Colors.white,
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 12.0, top: 15, right: 20),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text: "Périmètre de l'audit",
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets.only(
                                                          bottom: 0.0, top: 2.0),
                                                      child: Container(
                                                        width: 300,
                                                        height: 60,
                                                        child: Card(
                                                          surfaceTintColor:
                                                          Color.fromARGB(
                                                              255, 138, 135, 135),
                                                          elevation: 6,
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 12.0,
                                                                top: 15,
                                                                right: 20,
                                                                bottom: 15),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 0),
                                                                    child: Center(
                                                                      child:
                                                                      Container(
                                                                          width:
                                                                          90,
                                                                          height:
                                                                          20,
                                                                          decoration:
                                                                          const BoxDecoration(
                                                                            color:
                                                                            Color(0xFF3FAE4A),
                                                                          ),
                                                                          child: Row(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                      _showMyDialog();
                                                                                    },
                                                                                    child: const Text(
                                                                                      "Périmètre 1",
                                                                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                    )),
                                                                              ])),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 0),
                                                                    child: Center(
                                                                      child:
                                                                      Container(
                                                                          width:
                                                                          90,
                                                                          height:
                                                                          20,
                                                                          decoration:
                                                                          const BoxDecoration(
                                                                            color:
                                                                            Color(0xFF3FAE4A),
                                                                          ),
                                                                          child: Row(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                      _showMyDialog();
                                                                                    },
                                                                                    child: const Text(
                                                                                      "Périmètre 1",
                                                                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                    )),
                                                                              ])),
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  CustomText(
                                                    text: "Processus à auditer",
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets.only(
                                                          bottom: 0.0, top: 2.0),
                                                      child: Container(
                                                        width: 300,
                                                        height: 60,
                                                        child: Card(
                                                          surfaceTintColor:
                                                          Color.fromARGB(
                                                              255, 138, 135, 135),
                                                          elevation: 6,
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 12.0,
                                                                top: 15,
                                                                right: 20,
                                                                bottom: 15),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 0),
                                                                    child: Center(
                                                                      child:
                                                                      Container(
                                                                          width:
                                                                          90,
                                                                          height:
                                                                          20,
                                                                          decoration:
                                                                          const BoxDecoration(
                                                                            color:
                                                                            Color(0xFF3FAE4A),
                                                                          ),
                                                                          child: Row(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                      _showMyDialog();
                                                                                    },
                                                                                    child: const Text(
                                                                                      "Processus",
                                                                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                    )),
                                                                              ]
                                                                          )
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                ],
                                              )),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    CustomText(
                                                      text: "Type d'audit",
                                                      size: 15,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: 300,
                                                      height: 35,
                                                      child: TextFormField(
                                                        controller:
                                                        respoTextEditingController,
                                                        decoration: InputDecoration(
                                                            border:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(20.0),
                                                            ),
                                                            hintText: "Global",
                                                            // contentPadding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20, bottom: 10),
                                                            contentPadding:
                                                            EdgeInsets.symmetric(
                                                                vertical: 0.0,
                                                                horizontal: 5.0),
                                                            // border: OutlineInputBorder(),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                        context)
                                                                        .primaryColor,
                                                                    width: 2))),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    CustomText(
                                                      text: "Référentiel",
                                                      size: 15,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: 300,
                                                      height: 35,
                                                      child: TextFormField(
                                                        controller:
                                                        respoTextEditingController,
                                                        decoration: InputDecoration(
                                                            border:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(20.0),
                                                            ),
                                                            hintText: "ISO 26000",
                                                            // contentPadding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20, bottom: 10),
                                                            contentPadding:
                                                            EdgeInsets.symmetric(
                                                                vertical: 0.0,
                                                                horizontal: 5.0),
                                                            // border: OutlineInputBorder(),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                        context)
                                                                        .primaryColor,
                                                                    width: 2))),
                                                      ),
                                                    )
                                                  ]))
                                        ]),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )),
              )),
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Center(
            child: Text(''),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
              ],
            ),
          ),
        );
      },
    );
  }
}
