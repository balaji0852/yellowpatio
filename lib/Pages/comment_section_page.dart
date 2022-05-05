import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/graph/planner_graph.dart';

import '../home.dart';

//textfield can't be placed inside a row, need to use flexible,sizedbox or contianer
//stack or column inside stack doesn't stretch
//even singlechildscrollview can be wrapped below the stack()-cool
class CommentSectionPage extends StatefulWidget {
  const CommentSectionPage({this.classMaster});

  final ClassMaster? classMaster;

  @override
  CommentSection createState() => CommentSection();
}

class CommentSection extends State<CommentSectionPage> {
  double heightManagement = 100;
  int maxLinesManagement = 1;
  String? comment;
  TextEditingController commentEditController = TextEditingController();
  final GlobalKey<PlannerGraphPage> _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - heightManagement,
                  color: Colors.white,
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.classMaster!.itemName,
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          widget.classMaster!.description,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      PlannerGraph(
                        key: _key,
                        classMaster: widget.classMaster!,
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      const Text(
                        "          Comment",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      // Column(children: )
                    ],
                  ),
                ),
                Container(
                  height: heightManagement,
                  color: Colors.grey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: TextField(
                          controller: commentEditController,
                          maxLines: maxLinesManagement,
                          onChanged: textFieldheighManager,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            postComment();
                          },
                          child: const Text('post')),
                      const Spacer(
                        flex: 2,
                      ),
                      // TextField()
                    ],
                  ),
                ),
              ],
            ),
            // ]),
          ),
          Positioned(
            height: 125,
            left: 25,
            child: BackButton(
              onPressed: backButton,
            ),
          ),
        ],
      ),
    );
  }

  backButton() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  textFieldheighManager(String value) {
    setState(() {
      if (value.length % 40 == 1 && value.length / 40 < 10) {
        heightManagement = heightManagement + 10;
        maxLinesManagement++;
      }
    });
  }

  postComment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (commentEditController.text.isNotEmpty) {
      final database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      final dataInstanceMasterDao = database.dataInstanceMasterDao;

      DataInstancesMaster dataInstancesMaster = DataInstancesMaster(
          itemMasterID: widget.classMaster!.itemMasterID!,
          dataInstances: commentEditController.text,
          instancesTime: DateTime.now().millisecondsSinceEpoch);

      await dataInstanceMasterDao
          .insertDataInstance(dataInstancesMaster)
          .then((value) {
        heightManagement = 100;
        maxLinesManagement = 1;
        commentEditController.clear();
        _key.currentState!.calls();
      }).onError((error, stackTrace) {
        print(error);
      });
    }
  }
}
