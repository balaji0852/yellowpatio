import 'package:flutter/material.dart';

class DropDown extends StatelessWidget {
  final List<String> viewCategory = ["all","done","to-do","working"];
  final Function(String?)? callBack;
  final String dropdownTitle;
  List<DropdownMenuItem<String>> dropdownItems = [];

  DropDown(
      {Key? key,
      required this.callBack,
      required this.dropdownTitle,
      })
      : super(key: key) {
    for (String item in viewCategory) {
      var newItem = DropdownMenuItem(
        key: UniqueKey(),
        child: Text(item, style: const TextStyle(fontSize: 13)),
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
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: DropdownButton<String>(
        hint: Text(
          dropdownTitle,
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
        ),
        items: dropdownItems,
        borderRadius: BorderRadius.circular(25),
        onChanged: callBack,
      ),
    );
  }
}
