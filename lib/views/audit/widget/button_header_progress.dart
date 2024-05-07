import 'package:flutter/material.dart';

class ButtonProgress extends StatefulWidget {
  final String? text;
  final Widget? icon;
  final Function()? onPressed;
  final Color backgroundColor;
  const ButtonProgress(
      {super.key,
      this.text,
       this.icon,
      required this.backgroundColor, this.onPressed});

  @override
  State<ButtonProgress> createState() => _ButtonProgressState();
}

class _ButtonProgressState extends State<ButtonProgress> {
  @override
  Widget build(BuildContext context) {
    return widget.icon==null?
    TextButton(
      style: TextButton.styleFrom(backgroundColor: widget.backgroundColor),
      onPressed:widget.onPressed,
      child: Text("${widget.text}",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
    ) :TextButton.icon(
      style: TextButton.styleFrom(backgroundColor: widget.backgroundColor),
      onPressed:widget.onPressed,
      icon: widget.icon!,
      label: Text("${widget.text}",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }
}
