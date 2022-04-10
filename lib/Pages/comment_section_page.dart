import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';

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
  List<Widget> comments = [Text("ji")];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                      Container(
                        height: 425,
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(
                            flex: 3,
                          ),
                          const Text('View',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          androidDropdown(
                              ['day', 'month', 'year'], (p0) => {}, 'month'),
                          const Spacer(
                            flex: 1,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_left,
                              size: 35,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_right,
                              size: 35,
                            ),
                            onPressed: () {},
                          ),
                          const Spacer(
                            flex: 3,
                          ),
                        ],
                      ),
                      const Text(
                        "          Comment",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Column(
                        children:
                      comments
                      )
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
                          }, child: const Text('post')),
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

  // @override
  // Widget build1(BuildContext context) {
  //   return Scaffold(
  //     body: Stack(
  //       children: [
  //         CustomScrollView(
  //           slivers: [
  //             const SliverToBoxAdapter(
  //               child: SizedBox(
  //                 height: 40,
  //               ),
  //             ),
  //             SliverToBoxAdapter(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   // const Spacer(
  //                   //   flex: 1,
  //                   // ),
  //                   // BackButton(onPressed: () => backButton()),
  //                   // const Spacer(
  //                   //   flex: 3,
  //                   // ),
  //                   Text(
  //                     widget.classMaster!.itemName,
  //                     style: const TextStyle(
  //                       fontSize: 30,
  //                     ),
  //                   ),
  //                   // const Spacer(
  //                   //   flex: 7,
  //                   // ),
  //                 ],
  //               ),
  //             ),
  //             SliverPadding(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
  //               sliver: SliverToBoxAdapter(
  //                 child: Text(
  //                   widget.classMaster!.description,
  //                   style: const TextStyle(
  //                       fontSize: 14, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ),
  //             SliverPadding(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
  //               sliver: SliverToBoxAdapter(
  //                 child: Container(
  //                   height: 425,
  //                   color: Colors.yellow,
  //                 ),
  //               ),
  //             ),
  //             SliverToBoxAdapter(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const Spacer(
  //                     flex: 3,
  //                   ),
  //                   const Text('View',
  //                       style: TextStyle(
  //                           fontSize: 14, fontWeight: FontWeight.bold)),
  //                   androidDropdown(
  //                       ['day', 'month', 'year'], (p0) => {}, 'month'),
  //                   const Spacer(
  //                     flex: 1,
  //                   ),
  //                   IconButton(
  //                     icon: const Icon(
  //                       Icons.arrow_left,
  //                       size: 35,
  //                     ),
  //                     onPressed: () {},
  //                   ),
  //                   IconButton(
  //                     icon: const Icon(
  //                       Icons.arrow_right,
  //                       size: 35,
  //                     ),
  //                     onPressed: () {},
  //                   ),
  //                   const Spacer(
  //                     flex: 3,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SliverToBoxAdapter(
  //               child: Text("       comments", style: TextStyle(fontSize: 16)),
  //             ),
  //             SliverList(
  //               delegate: SliverChildListDelegate([]),
  //             )
  //           ],
  //         ),
  //         // Positioned(
  //         //   top: 0,
  //         //   bottom: MediaQuery.of(context).size.height - 80,
  //         //   left: 0,
  //         //   right: 0,
  //         //   child: Padding(padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
  //         //   child:  Container(
  //         //     color: Colors.red,
  //         //     child: Row(
  //         //       children: [
  //         //         const Spacer(
  //         //           flex: 1,
  //         //         ),
  //         //         BackButton(onPressed: () => backButton()),
  //         //         const Spacer(
  //         //           flex: 3,
  //         //         ),
  //         //         Text(
  //         //           widget.classMaster!.itemName,
  //         //           style: const TextStyle(
  //         //             fontSize: 30,
  //         //           ),
  //         //         ),
  //         //         const Spacer(
  //         //           flex: 7,
  //         //         ),
  //         //       ],
  //         //     ),
  //         //   ),)
  //         // ),
  //         Positioned(
  //             top: 0,
  //             bottom: MediaQuery.of(context).size.height - 120,
  //             left: 0,
  //             right: MediaQuery.of(context).size.width - 90,
  //             child: BackButton(
  //               onPressed: backButton,
  //             )),
  //         Positioned(
  //           top: MediaQuery.of(context).size.height - 100,
  //           bottom: 0,
  //           left: 0,
  //           right: 0,
  //           child: Container(
  //             color: Colors.amber,
  //             child: TextField(),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  backButton() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  Container androidDropdown(
      List<String> items, Function(String?)? callBack, String dropdownTitle) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String item in items) {
      var newItem = DropdownMenuItem(
        key: UniqueKey(),
        child: Text(item, style: const TextStyle(fontSize: 13)),
        value: item,
      );
      dropdownItems.add(newItem);
    }

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

  textFieldheighManager(String value) {
    setState(() {
      if (value.length % 40 == 1 && value.length / 40 < 10) {
        print("pass");
        heightManagement = heightManagement + 10;
        maxLinesManagement++;
      }

      print(value.length);
    });
  }

  postComment(){
    if(commentEditController.text.isNotEmpty){
      setState(() {
              comments.add(Text(commentEditController.text));
              heightManagement = 100;
              maxLinesManagement = 1;
      });
      commentEditController.clear();
    

    }
  }
}
