import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/cloud/dataInstanceMasterCloud.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/db/entity/user_store.dart';
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
  double heightManagement = 65;
  int maxLinesManagement = 2;
  String? comment;
  TextEditingController commentEditController = TextEditingController();
  ScrollController mainWidgetScrollController = ScrollController();
  final GlobalKey<PlannerGraphPage> _key = GlobalKey();
  int commentsLengthManager = 0;
  late int userStoreID;
  int nextLine = 0;
  //sig -30, sep 22
  bool callingServer = false;
  var focusNode = FocusNode();
  //11/28/2022 : balaji , using local variable to set darkMode
  bool darkMode = false;
  bool showDescription = false;
  var state;
  int lineCounter = 1;
  int reKey = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    state = StoreProvider.of<AppStore>(context);
    darkMode = state.state.darkMode;

   

    return StoreConnector<AppStore, bool>(
        converter: (store) => store.state.showDialog,
        builder: (context, _showDialog) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: !darkMode ? Colors.white : Colors.black,
              centerTitle: true,
              leading: BackButton(
                color: darkMode ? Colors.white : Colors.black,
                onPressed: backButton,
              ),
              title: Text(
                widget.classMaster!.itemName,
                style: TextStyle(
                    fontSize: 30,
                    color: darkMode ? Colors.white : Colors.black),
              ),
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  controller: mainWidgetScrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: (MediaQuery.of(context).size.height) -
                            heightManagement,
                        color: darkMode ? Colors.black : Colors.white,
                        child: ListView(
                          controller: mainWidgetScrollController,
                          children: [
                            // Container(
                            //   alignment: Alignment.center,
                            //   child: Text(
                            //     widget.classMaster!.itemName,
                            //     style:  TextStyle(
                            //       fontSize: 30,
                            //       color: darkMode?Colors.white:Colors.black
                            //     ),
                            //   ),
                            // ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child:
                                       GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showDescription =
                                                  !showDescription;
                                            });
                                          },
                                          child: Text(
                                            showDescription && !_showDialog
                                                ? widget
                                                    .classMaster!.description
                                                : widget
                                                                        .classMaster!
                                                                        .description
                                                                        .length >
                                                                    21?widget.classMaster!
                                                        .description
                                                        .substring(
                                                            0,
                                                           21) +
                                                    "...[more]": widget.classMaster!
                                                        .description
                                                        .substring(
                                                            0,
                                                           widget
                                                                        .classMaster!
                                                                        .description
                                                                        .length),
                                            maxLines: 5,
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: darkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                ),
                                          )),
                                    ),

                                    // const SizedBox(
                                    //   width: 15,
                                    // ),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     setState(() {
                                    //       showDescription = !showDescription;
                                    //     });
                                    //   },
                                    //   child: SizedBox(
                                    //     width: 20,
                                    //     height: 20,
                                    //     child: Text(
                                    //       !showDescription || _showDialog ? "<" : "v",
                                    //       style: TextStyle(
                                    //           fontSize: 22,
                                    //           color: darkMode
                                    //               ? Colors.white
                                    //               : Colors.black,
                                    //           fontWeight: FontWeight.bold),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                )),
                            PlannerGraph(
                              MainWidgetScrollView: mainWidgetScrollController,
                              key: _key,
                              classMaster: widget.classMaster!,
                              graphType: 1,
                              reKey: reKey,
                            ),
                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              " created by " +
                                  widget.classMaster!.userStore.userName,
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      darkMode ? Colors.white : Colors.black),
                            ),
                            Text(
                              " created on " +
                                  DateTime.fromMillisecondsSinceEpoch(
                                          widget.classMaster!.createdDate)
                                      .toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      darkMode ? Colors.white : Colors.black),
                            ),
                            const SizedBox(
                              height: 60,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  // ]),
                ),
                //Balaji - 20/4/2023-moving the textfield from column to stack, small screen issues.
                Positioned(
                  bottom: -10,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: heightManagement,
                    color: darkMode ? Colors.grey[900] : Colors.grey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: TextField(
                            decoration: InputDecoration(
                              counterText: ' ',
                              hintText: "comment",
                              hintStyle: TextStyle(
                                  color:
                                      darkMode ? Colors.white : Colors.black),
                            ),
                            controller: commentEditController,
                            maxLines: maxLinesManagement,
                            onChanged: textFieldheighManager,
                            style: TextStyle(
                                color: darkMode ? Colors.white : Colors.black),
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
                ),
                // Positioned(
                //     height: 125,
                //     left: 25,
                //     child: CircleAvatar(
                //       backgroundColor:  darkMode?Colors.black:Colors.white,
                //       child: BackButton(
                //         color:  darkMode?Colors.white:Colors.black,
                //         onPressed: backButton,
                //       ),
                //     )),
              ],
            ),
          );
        });
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
      if (value.length >= 240) {
        maxLinesManagement = 7;
        heightManagement = 160;
      }
      if (value.isEmpty) {
        maxLinesManagement = 2;
        heightManagement = 65;
      } else if (value.length > 40 && value.length < 80) {
        maxLinesManagement = 2;
        heightManagement = 85;
      } else if (value.length > 80 && value.length < 120) {
        maxLinesManagement = 3;
        heightManagement = 100;
      } else if (value.length > 120 && value.length < 160) {
        maxLinesManagement = 4;
        heightManagement = 115;
      } else if (value.length > 160 && value.length < 200) {
        maxLinesManagement = 5;
        heightManagement = 130;
      } else if (value.length > 200 && value.length < 240) {
        maxLinesManagement = 6;
        heightManagement = 145;
      }
    });
    commentsLengthManager = value.length;
  }

  //1/28/2023 : Balaji- adding specific reKey(reKey = n*1000;) for sale - 20
  postComment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (commentEditController.text.isNotEmpty) {
      // final database =
      //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      // final dataInstanceMasterDao = database.dataInstanceMasterDao;
      var state = StoreProvider.of<AppStore>(context);
      userStoreID = state.state.userStoreID;
      DataInstancesMaster dataInstancesMaster = DataInstancesMaster(
          itemMasterID: widget.classMaster!.itemMasterID!,
          dataInstances: commentEditController.text,
          instancesStatus: 2,
          userStore: UserStore(
              userStoreID: userStoreID,
              userName: "",
              linkedEmail: "",
              linkedPhone: "",
              themeID: 1,
              timeViewPreference: 1,
              dateViewPreference: 1,
              photoURL: ""),
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
            heightManagement = 60;
            maxLinesManagement = 1;
            reKey = reKey * 1000;
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
