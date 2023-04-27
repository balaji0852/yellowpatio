import 'dart:ffi';
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
  double heightManagement = 70;
  int maxLinesManagement = 2;
  String? comment;
  TextEditingController commentEditController = TextEditingController();
  ScrollController mainWidgetScrollController = ScrollController();
  final GlobalKey<PlannerGraphPage> _key = GlobalKey();
  int commentsLengthManager = 0;
  late int userStoreID;
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
    
    focusNode.removeListener((){
      print("removed");
    });

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
              fontSize: 30, color: darkMode ? Colors.white : Colors.black),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height:
                      (MediaQuery.of(context).size.height) - heightManagement,
                  color: darkMode ? Colors.black : Colors.white,
                  child: ListView(
                    controller: mainWidgetScrollController,
                    children: [
                      // const SizedBox(
                      //   height: 20,
                      // ),
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
                              horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (showDescription)
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.classMaster!.description,
                                        maxLines: 5,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              const SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showDescription = !showDescription;
                                  });
                                },
                                child: SizedBox(
                                  width: 40,
                                  height: 20,
                                  child: Text(
                                    !showDescription ? "<" : "v",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: darkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
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
                        " created by " + widget.classMaster!.userStore.userName,
                        style: TextStyle(
                            fontSize: 12,
                            color: darkMode ? Colors.white : Colors.black),
                      ),
                      Text(
                        " created on " +
                            DateTime.fromMillisecondsSinceEpoch(
                                    widget.classMaster!.createdDate)
                                .toString(),
                        style: TextStyle(
                            fontSize: 12,
                            color: darkMode ? Colors.white : Colors.black),
                      ),
                      // Column(children: )
                    ],
                  ),
                ),
                // Container(
                //   height: heightManagement,
                //   color: darkMode ? Colors.grey[900] : Colors.grey,
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       SizedBox(
                //         width: MediaQuery.of(context).size.width - 100,
                //         child: TextField(
                //           decoration: InputDecoration(
                //             counterText: ' ',
                //             hintText: "comment",
                //             hintStyle: TextStyle(
                //                 color: darkMode ? Colors.white : Colors.black),
                //           ),
                //           controller: commentEditController,
                //           maxLines: maxLinesManagement,
                //           onChanged: textFieldheighManager,
                //           style: TextStyle(
                //               color: darkMode ? Colors.white : Colors.black),
                //         ),
                //       ),
                //       const Spacer(
                //         flex: 1,
                //       ),
                //       ElevatedButton(
                //           onPressed: () {
                //             if (!callingServer) {
                //               callingServer = true;
                //               postComment();
                //             }
                //           },
                //           child: const Text('post')),
                //       const Spacer(
                //         flex: 2,
                //       ),
                //       // TextField()
                //     ],
                //   ),
                // ),
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
                      // expands: true,
                      // maxLines: null,
                      // minLines: null,
                      // focusNode: focusNode,
                      decoration: InputDecoration(
                        counterText: ' ',
                        hintText: "comment",
                        hintStyle: TextStyle(
                            color: darkMode ? Colors.white : Colors.black),
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
  }

  backButton() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  textFieldheighManager(String value) {
    //next line - \n : handle nextLine, get by last char
    //need 5 lines text field
    //height should be adaptive

    FocusScope.of(context).addListener(() => {
      print("add ")
    });

    FocusScope.of(context).removeListener(() => {
      print("remove")
    });

    setState(() {
      if (value.length >= 0 && value.length < 30) {
        maxLinesManagement = 2;
        heightManagement = 70;
      }
      else if (value.length > 30 && value.length < 40 && maxLinesManagement != 3) {
        maxLinesManagement = 3;
        heightManagement = 80;
      }
      else if (value.length > 70 && value.length < 80 && maxLinesManagement != 4) {
        maxLinesManagement = 4;
        heightManagement = 95;
      }
      else if (value.length > 110  && value.length < 120 && maxLinesManagement != 5) {
        print("stage3");
        maxLinesManagement = 5;
        heightManagement = 110;
      }
      else if (value.length > 150 && value.length < 160 && maxLinesManagement != 6) {
        print("stage4");
        maxLinesManagement = 6;
        heightManagement = 125;
      }
      else if (value.length > 180 && value.length < 200 && maxLinesManagement != 7) {
        print("stage5");
        maxLinesManagement = 7;
        heightManagement = 140;
      }
      // if ((value.length >= 40 && value.length < 80)) {
      //    if(value.length<commentsLengthManager && value.length>=40 && value.length<=50 && maxLinesManagement==3){
      //     maxLinesManagement = 2;
      //     heightManagement -= 13;
      //   }
      //   if (maxLinesManagement != 3) {
      //     maxLinesManagement = 3;
      //     heightManagement += 13;
      //   }

      // }
      //if ((value.length >= 80 && value.length < 120)) {
      //   if (maxLinesManagement != 4) {
      //     maxLinesManagement = 4;
      //     heightManagement += 13;
      //   }
      // }if ((value.length >=120  && value.length < 160)) {
      //   if (maxLinesManagement != 5) {
      //     maxLinesManagement = 5;
      //     heightManagement += 13;
      //   }
      // }
      // if ((value.length >=160  && value.length < 200)) {
      //   if (maxLinesManagement != 6) {
      //     maxLinesManagement = 6;
      //     heightManagement += 13;
      //   }
      // }
      // else if (commentEditController.text.length>90 && maxLinesManagement==3) {
      //   maxLinesManagement = 4;
      //   heightManagement += 10;
      // } else if (commentEditController.text.length>135 && maxLinesManagement==4) {
      //   maxLinesManagement = 5;
      //   heightManagement += 10;
      // } else if (commentEditController.text.length<140 && maxLinesManagement==5) {
      //   heightManagement += 15;
      // }
      print("000000000000000000000000"+value.length.toString());
      // if (commentsLengthManager < value.length) {
      //   print('inc');
      //   if (value.length > lineCounter * 45 && lineCounter < 5) {
      //     print('incr');

      //     lineCounter++;
      //     heightManagement = heightManagement + 10;
      //     maxLinesManagement++;
      //   }
      // } else {
      //   print("--=${value.length % 45}");

      //   if (( value.length % 45 >= 0 && value.length % 45 < 10) &&
      //       heightManagement > 60) {
      //     print('dec1');
      //     lineCounter--;
      //     heightManagement = heightManagement - 10;
      //     if (value.isEmpty) {
      //       heightManagement = 60;
      //     }
      //     if (maxLinesManagement != 1) {
      //       maxLinesManagement--;
      //     }
      //   }
      // }
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
