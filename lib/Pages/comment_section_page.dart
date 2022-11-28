import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/cloud/dataInstanceMasterCloud.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/graph/planner_graph.dart';
import 'package:yellowpatioapp/migation/migrations.dart';

import '../home.dart';
import '../redux_state_store/appStore.dart';

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
  ScrollController mainWidgetScrollController = ScrollController();
  final GlobalKey<PlannerGraphPage> _key = GlobalKey();
  int commentsLengthManager = 0;
  late int userStoreID;
  //sig -30, sep 22
  bool callingServer = false;
  //11/28/2022 : balaji , using local variable to set darkMode
  bool darkMode = false;
  var state;
  int lineCounter = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        state = StoreProvider.of<AppStore>(context);
    darkMode = state.state.darkMode;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - heightManagement,
                  color: darkMode?Colors.black:Colors.white,
                  child: ListView(
                    controller: mainWidgetScrollController,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.classMaster!.itemName,
                          style:  TextStyle(
                            fontSize: 30,
                            color: darkMode?Colors.white:Colors.black
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          widget.classMaster!.description,
                          style: TextStyle(
                              fontSize: 14, color: darkMode?Colors.white:Colors.black ,fontWeight: FontWeight.bold),
                        ),
                      ),
                      PlannerGraph(
                        MainWidgetScrollView: mainWidgetScrollController,
                        key: _key,
                        classMaster: widget.classMaster!,
                        graphType: 1,
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
                  color: darkMode?Colors.grey[900]:Colors.grey,
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
                            if (!callingServer) {
                              callingServer = true;
                              postComment();
                            }
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
              child: CircleAvatar(
                backgroundColor:  darkMode?Colors.black:Colors.white,
                child: BackButton(
                  color:  darkMode?Colors.white:Colors.black,
                  onPressed: backButton,
                ),
              )),
        ],
      ),
    );
  }

  backButton() {
    // Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  textFieldheighManager(String value) {
    setState(() {
      print(value.length);
      if (commentsLengthManager < value.length) {
        print('inc');
        if (value.length > lineCounter * 45 && lineCounter < 5) {
          print('incr');

          lineCounter++;
          heightManagement = heightManagement + 10;
          maxLinesManagement++;
        }
      } else {
        print('dec');

        if ((value.length <= 45 || value.length < (lineCounter - 1) * 45) &&
            heightManagement > 100) {
          lineCounter--;
          heightManagement = heightManagement - 10;
          if (maxLinesManagement != 1) {
            maxLinesManagement--;
          }
        }
      }
    });
    commentsLengthManager = value.length;
  }

  postComment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (commentEditController.text.isNotEmpty) {
      // final database =
      //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      // final dataInstanceMasterDao = database.dataInstanceMasterDao;
      var state = StoreProvider.of<AppStore>(context);
      userStoreID = state.state.selectedIndex;
      DataInstancesMaster dataInstancesMaster = DataInstancesMaster(
          itemMasterID: widget.classMaster!.itemMasterID!,
          dataInstances: commentEditController.text,
          instancesStatus: 2,
          instancesTime: DateTime.now().millisecondsSinceEpoch);
      //postDataInstanceMaster(dataInstancesMaster);

      //cloud migration
      await DataInstanceMasterCloud()
          .postDataInstanceMaster(dataInstancesMaster)
          .then((value) {
        if (value == 200) {
          print("inser");
          callingServer = false;
          setState(() {
            heightManagement = 100;
            maxLinesManagement = 1;
          });

          commentEditController.clear();
          _key.currentState!.calls();
        }
      }).onError((error, stackTrace) {
        print(error);
      });
    }
  }
}
