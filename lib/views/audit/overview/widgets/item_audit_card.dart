import 'package:flutter/material.dart';

class ItemAudit extends StatefulWidget {
  final String dateCreation;
  final String dateDebut;
  final String dateFin;
  final String statut;
  final String dateValidation;
  final double? perfGlobale;
  const ItemAudit(
      {super.key,
      required this.statut,
      required this.dateCreation,
      required this.dateDebut,
      required this.dateFin,
      this.perfGlobale,
      required this.dateValidation});

  @override
  State<ItemAudit> createState() => _ItemAuditState();
}

class _ItemAuditState extends State<ItemAudit> {
  @override
  Widget build(BuildContext context) {
    bool visible = true;
    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 2.0, right: 10),
        child: Container(
          height: 130,
          width: 600,
          child: Card(
            surfaceTintColor: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Référence: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              children: [
                            TextSpan(
                                text: "N-${widget.dateCreation}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15)),
                          ])),
                      SizedBox(
                        width: 30,
                      ),
                      widget.statut == "Audit validé"
                          ? RichText(
                              text: TextSpan(
                                  text: "Performance Globale: ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  children: [
                                  TextSpan(
                                      text: "${widget.perfGlobale}%",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                ]))
                          : SizedBox(),
                      Expanded(child: Container()),
                      PopupMenuButton(
                          padding: const EdgeInsets.all(4.0),
                          surfaceTintColor: Color.fromRGBO(238, 239, 243, 1),
                          icon: RotatedBox(
                              quarterTurns: 2,
                              child: Icon(
                                Icons.more_vert_outlined,
                                size: 25,
                              )),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  onTap: () {},
                                  child: TextButton.icon(
                                    onPressed: null,
                                    label: Text(
                                      "Archiver",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    icon: Icon(Icons.inbox_outlined),
                                  )),
                              PopupMenuItem(
                                onTap: () {
                                  showDialog(context: context,
                                    builder: (BuildContext context) {
                                    return AlertDialog(
                                        elevation:5,
                                      backgroundColor: Colors.white,
                                      content: Container(
                                        height:180,
                                        width: 350,
                                        child:Column(
                                          children: [
                                            Center(
                                                child:Icon(Icons.warning_amber,size:60,color:Colors.red,)
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Cette action est irréversible,voulez-vous vraiment supprimer ?",textAlign: TextAlign.center,style:TextStyle(
                                              fontSize: 25,color: Colors.black
                                            )),
                                          ],
                                        )
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              OutlinedButton(onPressed:(){},
                                                  child: Text("Supprimer")),
                                              OutlinedButton(onPressed:(){},
                                                  child: Text("Annuler")),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                    },

                                  );
                                },
                                child: TextButton.icon(
                                  onPressed: null,
                                  label: Text(
                                    "Supprimer",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ];
                          }),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Periode:  ",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                          children: [
                        TextSpan(
                            text: "${widget.dateDebut} au ${widget.dateDebut}",
                            style: const TextStyle(
                              color: Colors.black,
                            )),
                        const TextSpan(
                            text: "     Statut:    ",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                        TextSpan(
                            text: widget.statut,
                            style: TextStyle(
                                color: widget.statut == "Audit terminé"
                                    ? Colors.green
                                    : widget.statut == "Audit validé"
                                        ? Color.fromRGBO(52, 109, 182, 1)
                                        : widget.statut == "En cours"
                                            ? Colors.amber
                                            : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const TextSpan(
                            text: "     Date de clôture:    ",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                        TextSpan(
                            text: widget.dateValidation,
                            style: const TextStyle(
                              color: Colors.black,
                            )),
                      ])),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.statut == "En cours"
                          ? TextButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                "assets/images/continuer.png",
                                width: 30,
                                height: 30,
                              ),
                              label: Text("Continuer",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber)),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: Image.asset(
                                      "assets/images/resultats.png",
                                      width: 30,
                                      height: 30),
                                  label: Text("Résultats",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: widget.statut ==
                                                  "Audit terminé"
                                              ? Colors.green
                                              : widget.statut ==
                                                      "Audit validé"
                                                  ? Color.fromRGBO(52, 109, 182, 1)
                                                  : Colors.black)),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: Image.asset("assets/images/rapport.png",
                                      width: 30, height: 30),
                                  label: Text("Rapport",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: widget.statut ==
                                                  "Audit terminé"
                                              ? Colors.green
                                              : widget.statut ==
                                                      "Audit validé"
                                                  ? Color.fromRGBO(52, 109, 182, 1)
                                                  : Colors.black)),
                                )
                              ],
                            ),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: Image.asset("assets/images/shield.png",
                                width: 30, height: 30),
                            label: Text("Les droits d'accès",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Text("visibilité",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17)),
                          SizedBox(
                            width: 20,
                          ),
                          Switch(
                              value: visible,
                              activeColor: Colors.green,
                              onChanged: (value) {
                                setState(() {
                                  visible = value;
                                });
                              })
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
