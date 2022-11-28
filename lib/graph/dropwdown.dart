import 'package:flutter/material.dart';

class DropDown extends StatelessWidget {
  final List<String> viewCategory ;
  final Function(String?)? callBack;
  final String dropdownTitle;
  final bool darkMode;
  List<DropdownMenuItem<String>> dropdownItems = [];

  DropDown(
      {Key? key,
      required this.callBack,
      required this.dropdownTitle,
      required this.viewCategory,
      required this.darkMode
      })
      : super(key: key) {
    for (String item in viewCategory) {
      var newItem = DropdownMenuItem(
        key: UniqueKey(),
        child: Text(item, style:  TextStyle(fontSize: 13,color: darkMode?Colors.white:Colors.black)),
        value: item,
      );
      dropdownItems.add(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: darkMode?Colors.black:Colors.white
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: DropdownButton<String>(
        dropdownColor:darkMode?Colors.grey[900]:Colors.white ,
        hint: Text(
          dropdownTitle,
          style: TextStyle(
              color: darkMode?Colors.white:Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
        ),
        items: dropdownItems,
        borderRadius: BorderRadius.circular(25),
        onChanged: callBack,
      ),
    );
  }
}
