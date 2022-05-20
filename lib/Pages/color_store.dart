import 'package:flutter/material.dart';

class ColorStore{

  final List<ColorPicker> _colorsList = [ColorPicker(color:Colors.red, colorName: 'red'),
  ColorPicker(color:Colors.purple, colorName: 'purple'),
  ColorPicker(color:Colors.yellow, colorName: 'yellow'),
  ColorPicker(color:Colors.blue, colorName: 'blue'),
  ColorPicker(color:Colors.green, colorName: 'green'),
  ColorPicker(color:Colors.lime, colorName: 'lime'),
  ColorPicker(color:Colors.blueAccent, colorName: 'blueAccent'),
  ColorPicker(color:Colors.yellowAccent, colorName: 'yellowAccent'),
  ColorPicker(color:Colors.pink, colorName: 'pink'),
  ColorPicker(color:Colors.deepPurple, colorName: 'deepPurple')];

  String _selectedColor = 'red';

  set setColorStore(String color) => _selectedColor = color;

  get getColorStore => _selectedColor;

  get getColor => _colorsList.where((element) => element.colorName==_selectedColor);

  get getColorStoreList => _colorsList;

  Color getColorByID(int colorID) {
     return _colorsList.elementAt(colorID).color;
  }

}



class ColorPicker{
  final String colorName;

  final Color color;

  ColorPicker({
    required this.colorName,
    required this.color
  });

}

