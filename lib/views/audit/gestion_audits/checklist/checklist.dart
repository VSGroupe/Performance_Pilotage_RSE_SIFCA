import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';


class CheckList extends StatefulWidget {
  const CheckList({super.key});

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  late TextEditingController controller ;
  late TextEditingController daysController ;
  String daysChoosed="";
  @override
  void initState() {
    controller=TextEditingController();
    daysController=TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 13),
            child: Row(
              children: [
                TextButton.icon(onPressed:(){}, icon:const Icon(Icons.filter_alt_outlined,size: 20,), label: const Text(
                  "Filtrer",style: TextStyle(
                    fontSize: 18,color: Colors.green,fontWeight: FontWeight.bold
                ),
                )),
                const SizedBox(width: 5,),
                TextButton.icon(onPressed:(){}, icon:const Icon(Icons.sort_outlined,size: 20,), label: const Text(
                  "Trier",style: TextStyle(
                    fontSize: 18,color: Colors.green,fontWeight: FontWeight.bold
                ),
                )),
                const SizedBox(width: 6,),
                Container(
                  height: 46,
                  width: 450,
                  padding: const EdgeInsets.only(top:2,left: 8,right: 8,bottom: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                            spreadRadius: 0,
                            color: const Color(0xFF00000040).withOpacity(0.5))
                      ]),
                  child:TextField(
                    controller:controller,
                    decoration: const InputDecoration(
                        fillColor:Colors.white,
                        hintText:"Recherche",
                        border:InputBorder.none,
                        prefixIcon: Icon(Icons.search_outlined,size: 23,)
                    ),
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: CustomDropdown(
                    //decoration: ,
                    hintText:"Selectionner Jour",
                    items:  ["Mercredi 26-09-2023","Jeudi 27-09-2023","Vendredi 28-09-2023"],
                    //controller: daysController,
                    onChanged: (value){
                      setState(() {
                        daysChoosed=value;
                      });
                    },
                  ),
                ),
                Padding(padding: const EdgeInsets.only(left: 8,right: 12),
                child:OutlinedButton.icon(
                  style:OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  icon:const Icon(Icons.print,color: Colors.black,),
                  onPressed: () {},
                  label:const Text("Imprimer",style: TextStyle(fontSize: 15,color: Colors.black),),
                ) ,
                )
              ],
            ),
          ),
          const SizedBox(height: 12,),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(right:12.0,bottom: 13),
            child: Container(
              color: Colors.grey,
            ),
          ))
        ],
      ),
    ));
  }
}
