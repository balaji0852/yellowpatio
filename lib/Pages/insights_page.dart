import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/label_master.dart';
import 'package:yellowpatioapp/db/repository/labelmaster_dao.dart';

class InsightsPage extends StatefulWidget {
  Insights createState() => Insights();
}

class Insights extends State<InsightsPage> {
  static const text = "insight";
  List<Label>? label;
  TextEditingController labelName = TextEditingController();
  var database;
  var labelMasterDao;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLabel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        Container(
          height: 150,
          color: Colors.yellow,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  onChanged: (value) {},
                  controller: labelName,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (labelName.text.isNotEmpty) {
                        //add label func
                        addLabel();
                      }
                    },
                    child: const Text('add label'))
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: SizedBox(
            height: 150,
            child: null != label
                ? ListView(
                    children: label!
                        .map((e) => Row(
                              children: [
                                Flexible(
                                    child: Column(
                                  children: [
                                    Text(
                                      e.labelId.toString() +
                                          ' - ' +
                                          e.labelName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          backgroundColor: Colors.yellow),
                                    ),
                                  ],
                                )),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.yellow,
                                    ))
                              ],
                            ))
                        .toList())
                : const Text(" "),
          ),
        )
      ]),
    );
  }

  getLabel() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    labelMasterDao = database.labelMasterDao;

    // print(database.personDao.findAllPersons());

    print(
        "***************************************************************************");

    List<Label> data = await database.labelMasterDao.findAllLabel();

    setState(() {
      label = data;
    });
  }

  addLabel() async {
    var labelEntity = Label(labelName: labelName.text);
    await labelMasterDao.insertLabel(labelEntity).then((value) {
      print("inserted successfully");
      labelName.clear();
    });
    List<Label> data = await database.labelMasterDao.findAllLabel();
    setState(() {
      label = data;
    });
  }
}
