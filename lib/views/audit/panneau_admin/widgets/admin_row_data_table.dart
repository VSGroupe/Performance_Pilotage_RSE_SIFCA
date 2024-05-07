import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import '../../constant/constants.dart';
import '../../widget/material_global_button.dart';

class RowAdminDataTable extends StatefulWidget {
  final String nom;
  final String prenom;
  final String fonction;
  final String typeAcces;
  final String email;
  final bool estBloque;
  final String entreprise;
  const RowAdminDataTable({Key? key, required this.nom, required this.prenom, required this.fonction, required this.typeAcces, required this.email, required this.estBloque, required this.entreprise,})
      : super(key: key);

  @override
  State<RowAdminDataTable> createState() => _RowAdminDataTableState();
}

class _RowAdminDataTableState extends State<RowAdminDataTable> {
  bool isHovering = false;
  late TextEditingController accesControlleur;
  String levelAccess="Validateur";

  @override
  void initState() {
    accesControlleur=TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return InkWell(
      mouseCursor: SystemMouseCursors.basic,
      onTap: () {},
      onHover: (value) {
        setState(() {
          isHovering = value;
        });
      },
      child: Material(
        elevation: isHovering ? 10 : 0,
        child: Container(
          padding: const EdgeInsets.only(left: 2.0,right: 20),
          decoration: BoxDecoration(
            border:isHovering ?Border.all(color: Colors.black, width: 1.0):Border.all(width: 0) ,
            color: Colors.transparent,
          ),
          height: 40,
          child: Row(
            children: [
              // Réf
              Container(
                height: 40,
                width: 120,
                alignment: Alignment.centerLeft,
                color: Colors.transparent,
                child: Row(
                  children: [
                    if (isHovering)
                      const Icon(
                        Icons.mouse,
                        size: 12,
                      ),
                    if (isHovering)
                      const SizedBox(
                        width: 2,
                      ),
                    Text(
                      "${widget.nom} ",
                      style: const TextStyle(fontSize:14,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Intitule
              Container(
                height: 40,
                width: 150,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.prenom}",
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              //definition
              Container(
                height: 40,
                width: 120,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.fonction}",
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              //def
              //type
              Container(
                height: 40,
                width: 120,
                color: Colors.transparent,
                child: buildRealiseMoisColumn(context,widget.typeAcces),
              ),
              //unite
              Container(
                height: 40,
                width: 150,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.email}",
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              // Processus
              // Réalise Annuel
              Container(
                height: 40,
                width: 50,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  "${widget.estBloque}",
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              Container(
                height: 40,
                width: 150,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  "${widget.entreprise}",
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRealiseMoisColumn(BuildContext context,String? Acces) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("${levelAccess==Acces? Acces:levelAccess}", style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
        IconButton(splashRadius: 20,splashColor: Colors.amber,
            onPressed: () {
              renseignerLaDonnee(context:context);
            },icon: const Icon(Icons.edit, size: 12,)),
      ],
    );
  }



  Future<void> renseignerLaDonnee({@required context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            elevation:4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Container(
              height: 200,
              width: 200,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text("Attribuer Niveau D'accès",textAlign: TextAlign.center,style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 17
                  ),),
                  SizedBox(height: 9,),
                  CustomDropdown.search(
                      hintText:"Selectionner le niveau d'accès",
                      items:  ["Editeur","Spectateur","Validateur"],
                      //controller: accesControlleur,
                    onChanged: (value){
                        setState(() {
                          levelAccess=value;
                        });
                    },
                  ),
                  SizedBox(height: 20,),
                  MaterialGlobalButon(onPressed:(){
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  }, text:"Valider", backgroundColor: activeColor,width: 150,)

                ],
              ),
            ),
        );
      },
    );
  }
}
