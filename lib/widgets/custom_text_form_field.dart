import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final double? width;
  final InputDecoration? decoration;
  final Function(String value)? onChanged;
  const CustomTextFormField({Key? key, required this.controller,  this.validator,this.obscureText, this.decoration, this.width, this.onChanged}) : super(key: key);
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width??300,
      child: TextFormField(
        obscureText:widget.obscureText??false,
        controller: widget.controller,
        onChanged: widget.onChanged,
        validator:widget.validator,
        decoration: widget.decoration??InputDecoration(
            hintText: "",
            contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2
                )
            )
        ),
      ),
    );
  }
}
