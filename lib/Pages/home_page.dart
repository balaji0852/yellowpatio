import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/item_master.dart';

class homePage extends StatefulWidget {
  HomePageActivity createState() => HomePageActivity();
}

class HomePageActivity extends State<homePage> {
  static const text = "your tasks";
  // final database = $FloorAppDatabase.databaseBuilder('app_database.db').build();
  List<ItemMaster> notes = [];

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  Future getNotes() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // final itemMasterDao = database.itemMasterDao;

    // print(database.personDao.findAllPersons());

    print(
        "***************************************************************************");

    List<ItemMaster> data = await database.itemMasterDao.findAllItems();

    data.forEach((item) {
      print(item.id.toString() +
          ' ' +
          item.itemText +
          ' ' +
          item.itemDescription +
          ' ' +
          item.createdDateTime +
          ' ' +
          item.ypClassIDs.toString());
    });

    setState(() {
      notes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return notes.isNotEmpty
        ? ListView(
            children: notes.map((event) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.userLabel,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    " created on - " +
                        event.createdDateTime +
                        "   Due on - " +
                        event.dueDate,
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    event.itemText,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  )
                ],
              ),
            );
          }).toList())
        : const Text("home");
  }
}
