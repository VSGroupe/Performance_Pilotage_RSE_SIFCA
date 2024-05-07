import 'package:flutter/material.dart';
import '../constant/constants.dart';

class MaterialGlobalButon extends StatefulWidget {
  final Function()? onPressed;
  final String? text;
  final double? width;
  final Color backgroundColor;
  const MaterialGlobalButon({super.key, required this.onPressed,this.width,required this.text, required this.backgroundColor});

  @override
  State<MaterialGlobalButon> createState() => _MaterialGlobalButonState();
}

class _MaterialGlobalButonState extends State<MaterialGlobalButon> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 3,
      minWidth:widget.width??280,
      height:46,
      onPressed:widget.onPressed,
      color:activeColor,
      child: Text("${widget.text}",
        style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 17),),);
  }
}
