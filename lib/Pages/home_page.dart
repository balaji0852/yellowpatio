import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  HomePageActivity createState() => HomePageActivity();
}

class HomePageActivity extends State<homePage> {
  static const text = "your tasks";
  // final database = $FloorAppDatabase.databaseBuilder('app_database.db').build();
  // List<Person> notes = [];

  List<List<String>> data = [
    ["1", "random data", DateTime(2021).toString(), "task"],
    ["2", "random data", DateTime(2021).toString(), "feedback"],
    ["3", "random data", DateTime(2021).toString(), "feedback"],
    ["4", "random data", DateTime(2021).toString(), "task"],
    ["5", "random data", DateTime(2021).toString(), "task"],
    ["6", "random data", DateTime(2021).toString(), "task"],
  ];

  @override
  void initState() {
    super.initState();
    // getNotes();
  }

  Future getNotes() async {
    // final database =
    //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    // print(database.personDao.findAllPersons());

    // print(
    //     "***************************************************************************");

    // List<Person> data = await database.personDao.findAllPersons();

    // setState(() {
    //   notes = data;
    // });
    // print(notes);
  }

  @override
  Widget build(BuildContext context) {
    // return notes.length != 0
    //     ? ListView(
    //         children: notes.map((event) {
    //         return Padding(
    //           padding: EdgeInsets.all(10),
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Icon(Icons.collections_bookmark),
    //               SizedBox(
    //                 width: 35,
    //               ),
    //               Expanded(
    //                   child: Text(
    //                 event.name,
    //                 style: TextStyle(
    //                     fontSize: 17,
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.black),
    //               ))
    //             ],
    //           ),
    //         );
    //       }).toList())
    return Text("home");
  }
}
