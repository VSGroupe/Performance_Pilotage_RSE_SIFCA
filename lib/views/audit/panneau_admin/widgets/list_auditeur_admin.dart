import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import '../../constant/constants.dart';
import '../../widget/material_global_button.dart';
import 'admin_data_table_header.dart';
import 'admin_row_data_table.dart';

class ListAuditeurAdmin extends StatefulWidget {
  const ListAuditeurAdmin({super.key});

  @override
  State<ListAuditeurAdmin> createState() => _ListAuditeurAdminState();
}

class _ListAuditeurAdminState extends State<ListAuditeurAdmin> {
  late TextEditingController controller;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    controller=TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 13),
            child: Row(
              children: [
                TextButton.icon(onPressed:(){}, icon:Icon(Icons.filter_alt_outlined,size: 20,), label: Text(
                  "Filtrer",style: TextStyle(
                  fontSize: 18,color: Colors.green,fontWeight: FontWeight.bold
                ),
                )),
                SizedBox(width: 5,),
                TextButton.icon(onPressed:(){}, icon:Icon(Icons.sort_outlined,size: 20,), label: Text(
                  "Trier",style: TextStyle(
                    fontSize: 18,color: Colors.green,fontWeight: FontWeight.bold
                ),
                )),
                Expanded(child: Container()),
                Container(
                  height: 46,
                  width: 450,
                  padding: EdgeInsets.only(top:2,left: 8,right: 8,bottom: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            spreadRadius: 0,
                            color: Color(0xFF00000040).withOpacity(0.5))
                      ]),
                  child:TextField(
                    controller:controller,
                    decoration: InputDecoration(
                        fillColor:Colors.white,
                        hintText:"Recherche",
                        border:InputBorder.none,
                      prefixIcon: Icon(Icons.search_outlined,size: 23,)
                    ),
                  ),
                ),
                SizedBox(width: 9,),
                MaterialGlobalButon(onPressed:(){}, text:"Ajouter", backgroundColor:activeColor,width: 240,)
              ],
            ),
          ),
          SizedBox(height: 20,),
          Center(
            child: AdminDataTableHeader(),
          ),
          Container(
              height: 250,
              child: VsScrollbar(
                  controller: _scrollController,
                  showTrackOnHover: true, // default false
                  isAlwaysShown: true, // default false
                  scrollbarFadeDuration: Duration(
                      milliseconds:
                      500), // default : Duration(milliseconds: 300)
                  scrollbarTimeToFade: Duration(
                      milliseconds:
                      800), // default : Duration(milliseconds: 600)
                  style: VsScrollbarStyle(
                    hoverThickness: 10.0, // default 12.0
                    radius:
                    Radius.circular(10), // default Radius.circular(8.0)
                    thickness: 10.0, // [ default 8.0 ]
                    color: Colors.black, // default ColorScheme Theme
                  ),
                child: ListView(
            children: [
              RowAdminDataTable(
                nom: 'Amani',
                prenom: 'Maximin Emmanuel',
                fonction: 'Manager',
                typeAcces: 'Validateur',
                email: 'eamani@gmail.com',
                estBloque: false,
                entreprise: 'Solibra',

              ),
              RowAdminDataTable(
                nom: 'Amani',
                prenom: 'Maximin Emmanuel',
                fonction: 'Manager',
                typeAcces: 'Validateur',
                email: 'eamani@gmail.com',
                estBloque: false,
                entreprise: 'Solibra',

              ),
              RowAdminDataTable(
                nom: 'Amani',
                prenom: 'Maximin Emmanuel',
                fonction: 'Manager',
                typeAcces: 'Validateur',
                email: 'eamani@gmail.com',
                estBloque: false,
                entreprise: 'Solibra',

              ),
              RowAdminDataTable(
                nom: 'Amani',
                prenom: 'Maximin Emmanuel',
                fonction: 'Manager',
                typeAcces: 'Validateur',
                email: 'eamani@gmail.com',
                estBloque: false,
                entreprise: 'Solibra',

              ),
              RowAdminDataTable(
                nom: 'Amani',
                prenom: 'Maximin Emmanuel',
                fonction: 'Manager',
                typeAcces: 'Validateur',
                email: 'eamani@gmail.com',
                estBloque: false,
                entreprise: 'Solibra',

              ),
              RowAdminDataTable(
                nom: 'Amani',
                prenom: 'Maximin Emmanuel',
                fonction: 'Manager',
                typeAcces: 'Validateur',
                email: 'eamani@gmail.com',
                estBloque: false,
                entreprise: 'Solibra',

              ),
            ],
          )))
        ],
      ),
    );
  }
}
