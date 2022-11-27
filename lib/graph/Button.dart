import 'package:flutter/material.dart';

class Button extends StatelessWidget{

  final Function onPressed;
  final String text;
  final Color color;

  Button({Key? key, required this.onPressed,required this.text,required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
    );
  }
}