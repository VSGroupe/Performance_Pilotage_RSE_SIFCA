import 'package:flutter/material.dart';

class AdminDataTableHeader extends StatefulWidget {
  const AdminDataTableHeader({Key? key}) : super(key: key);

  @override
  State<AdminDataTableHeader> createState() => _AdminDataTableHeaderState();
}

class _AdminDataTableHeaderState extends State<AdminDataTableHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 2.0,right: 15),
        child: Container(
          height: 50,
          width: double.maxFinite,

          decoration: BoxDecoration(
              color: Colors.brown,
          ),
          child: Row(
            children: [
              DataTableHeaderTitle(color: Colors.brown, size: 130,title: "Nom",),
              DataTableHeaderTitle(color: Colors.brown, size:150,title: "Prenom",),
              DataTableHeaderTitle(color: Colors.brown, size: 120,title: "Fonction",),
              DataTableHeaderTitle(color: Colors.brown, size: 120,title: "Type d'acces",),
              DataTableHeaderTitle(color: Colors.brown, size: 150,title: "Email",),
              DataTableHeaderTitle(color: Colors.brown, size: 100,title: "Est bloqué",),
              DataTableHeaderTitle(color: Colors.brown, size: 150,title: "Entreprise",),
            ],
          ),
        ));
  }
}


class DataTableHeaderTitle extends StatefulWidget {
  final double size;
  final Color color;
  final String title;
  const DataTableHeaderTitle({Key? key, required this.size, required this.color, required this.title}) : super(key: key);

  @override
  State<DataTableHeaderTitle> createState() => _DataTableHeaderTitleState();
}

class _DataTableHeaderTitleState extends State<DataTableHeaderTitle> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      onHover: (value){
        setState(() {
          isHovering = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 2.0),
        width: widget.size,
        color: isHovering ? Color(0xFF8B735C) :widget.color,
        alignment: Alignment.centerLeft,
        child: Text("${widget.title}",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
      ),
    );
  }
}

