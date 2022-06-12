import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/item_master.dart';
import 'package:yellowpatioapp/db/entity/label_master.dart';

class AddPage extends StatefulWidget {
  Add createState() => Add();
}

class Add extends State<AddPage> {
  static const text = "add new tasks";
  static const micText =
      'Tap Microphone to record prompt. Say "ding" when done.';
  static const SayMessageText = 'Say "ding" when done.';
  // final SpeechToText speech = SpeechToText();
  bool isListening = false;
  String InputMessage = "";
  static const TextFieldPrompt = "You con type in your prompt";
  TextEditingController tec = TextEditingController();
  List<Label>? label;
  int setLabel = 1;
  var database;
  var labelMasterDao;
  @override
  void initState() {
    super.initState();
    //databaseSetup();
    // getLabel();
  }

  databaseSetup() async {}

  TextStyle ts = const TextStyle(
      fontSize: 17,
      color: Colors.black,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold);
  OutlineInputBorder op = const OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.white10,
      ));
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // const SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   micText,
              //   style: ts,
              // ),
              Expanded(
                  child: MaterialButton(
                onPressed: () {  },
                child: Image.asset("assets/singlDayImage1.png"),
                // onPressed: () {
                //   // listen
                // },
              )),
              Expanded(
                  child:MaterialButton(
                onPressed: () {  },
                child: Image.asset("assets/twoDayImage.png"),
                // onPressed: () {
                //   // listen
                // },
              )),
              Expanded(
                  child:MaterialButton(
                onPressed: () {  },
                child: Image.asset("assets/threeDayImage.png"),
                // onPressed: () {
                //   // listen
                // },
              )),
              Expanded(
                  child: MaterialButton(
                onPressed: () {  },
                child: Image.asset("assets/fiveDayImage.png"),
                // onPressed: () {
                //   // listen
                // },
              ))

              // const SizedBox(
              //   height: 10,
              // ),
              // //Text(isListening ? "listening..." : "stopped..."),
              // const SizedBox(
              //   height: 40,
              // ),
              // Container(
              //     child: Text(
              //   InputMessage,
              //   style: ts,
              // )
              //     //  TagHighlighting(
              //     //   text: '<strong>fuck</string>' + InputMessage,
              //     //   defaultTextStyle: ts,
              //     //   tags: [
              //     //     TagHighlight(
              //     //       tagName: "strong", // the name of the tag above.
              //     //       textStyle: const TextStyle(
              //     //         // the style of "World"
              //     //         fontWeight: FontWeight.bold,
              //     //         backgroundColor: Colors.yellow,
              //     //         color: Colors.black,
              //     //         fontSize: 16,
              //     //       ),
              //     //     ),
              //     //   ],
              //     // ),

              //     ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     const SizedBox(
              //       height: 30,
              //     ),
              //     Text((InputMessage.split(" ").length - 1).toString() + "/30")
              //   ],
              // ),
              // SizedBox(
              //   height: 2,
              //   child: Container(
              //     color: Colors.black,
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // TextField(
              //   controller: tec,
              //   maxLines: 5,
              //   decoration: InputDecoration(
              //       focusedBorder: op,
              //       enabledBorder: op,
              //       hintText: "type here..."),
              //   onChanged: (value) {
              //     if (InputMessage.split(" ").length < 30) {
              //       setState(() {
              //         InputMessage = value;
              //       });
              //     }
              //   },
              // ),
              // // Row(
              // //   children: [
              // //     Text('label'),
              // Container(
              //   height: 50,
              //   child: label != null
              //       ? ListView(
              //           scrollDirection: Axis.horizontal,
              //           children: label!
              //               .map(
              //                 (e) => GestureDetector(
              //                   child: Chip(
              //                     backgroundColor: setLabel != e.labelId!
              //                         ? Colors.yellow
              //                         : Colors.black,
              //                     label: Text(e.labelName),
              //                     labelStyle: TextStyle(
              //                         fontSize: 15,
              //                         fontWeight: FontWeight.bold,
              //                         color: setLabel == e.labelId!
              //                             ? Colors.yellow
              //                             : Colors.black),
              //                   ),
              //                   onTap: () {
              //                     //case for removing the selected label
              //                     //case for default label
              //                     setState(() {
              //                       if (setLabel == e.labelId!) {
              //                         setLabel = 1;
              //                       } else {
              //                         setLabel = e.labelId!;
              //                       }
              //                     });
              //                   },
              //                 ),
              //               )
              //               .toList(),
              //         )
              //       : Text(" "),
              // ),
              // //   ],
              // // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // ElevatedButton(
              //     onPressed: () {
              //       if (tec.text.isNotEmpty) {
              //         saveNotes();
              //       }
              //     },
              //     child: const Text("add"))
            ],
          ),
        ),
      ),
    );
  }

  // void listen() async {
  //   if (!isListening) {
  //     bool available = await speech.initialize(
  //       onStatus: (val) => print('onStatus: $val'),
  //       onError: (val) => print('onError: $val'),
  //     );
  //     if (available) {
  //       setState(() => isListening = true);
  //       speech.listen(
  //         onResult: (val) => setState(() {
  //           if (InputMessage.split(" ").length < 30 &&
  //               !InputMessage.split(" ").contains("ding")) {
  //             InputMessage = val.recognizedWords;
  //             tec.text = InputMessage;
  //           } else {
  //             speech.stop();
  //             isListening = false;
  //           }
  //         }),
  //       );
  //     }
  //   } else {
  //     setState(() => isListening = false);
  //     speech.stop();
  //   }
  // }

  Future saveNotes() async {
  //   final database =
  //       await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //   final itemMasterDao = database.itemMasterDao;

  //   ItemMaster itemMaster = ItemMaster(
  //       itemText: tec.text,
  //       itemDescription: ' test text ',
  //       createdDateTime: DateTime.now().toString(),
  //       userLabel: ' non - labeled ',
  //       userTopicID: ' 01 ',
  //       synced: false,
  //       dueDate: DateTime.now().toString(),
  //       ypClassIDs: setLabel,
  //       ypTo: ' test to ');

  //   await itemMasterDao.insertItem(itemMaster).then((value) {
  //     print("inserted successfully");
  //     tec.clear();
  //   }).onError((error, stackTrace) {
  //     print(error);
  //   });
  // }

  // getLabel() async {
  //   database =
  //       await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  //   labelMasterDao = database.labelMasterDao;

  //   // print(database.personDao.findAllPersons());

  //   print(
  //       "***************************************************************************");

  //   List<Label> data = await database.labelMasterDao.findAllLabel();

  //   setState(() {
  //     label = data;
  //   });
  }
}
