import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yellowpatioapp/login_page.dart';
// import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
          textTheme: const TextTheme(
              bodyText1: TextStyle(color: Colors.black, fontSize: 16))),
      home: RootWidget(),
    );
  }
}

class RootWidget extends StatefulWidget {
  @override
  _RootWidgetState createState() =>
      //home page routing logic goes here
      // routeCheck();
      _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  static const platform = const MethodChannel('app.channel.shared.data');
  Map<dynamic, dynamic> sharedData = Map();
  var state = {};

  @override
  void initState() {
    super.initState();
    _init();
    print("init--------------------------------------------------");
  }

  _init() async {
    //****************************************** */
    //****************************************** */
    //****************************************** */
    //**********for future purpose;)************ */
    //****************************************** */
    //****************************************** */
    //****************************************** */
    //****************************************** */
    // Case 1: App is already running in background:
    // Listen to lifecycle changes to subsequently call Java MethodHandler to check for shared data
    // SystemChannels.lifecycle.setMessageHandler((msg) {
    //   Future<String?> foo = "puc" as Future<String?>;
    //   try {
    //     if (msg!.contains('resumed')) {
    //       _getSharedData().then((d) async {
    //         if (d.isEmpty) {
    //           print(
    //               "*****************************intent empty***************************************");
    //         } else {
    //           print(
    //               "*****************************intent is not empty***************************************");
    //         }
    //         //     // Your logic here
    //         //     // E.g. at this place you might want to use Navigator to launch a new page and pass the shared data
    //       });
    //     }
    //     return foo;
    //   } catch (Error) {
    //     print("throwing shit null");
    //     rethrow;
    //   }
    // });

    // // Case 2: App is started by the intent:
    // // Call Java MethodHandler on application start up to check for shared data
    var data = await _getSharedData();
    print("******************************decision*************************");
    print(data);

    //******************************************************* */
    //*****************&&&&**************&&&&***************** */
    //******************************************************* */
    //*********take to application-----the real one;)*********/
    //*********************&&&&*****&&&&&********************* */
    //***********************&&&&&&&&&&********************** */

    // setState(() {
    sharedData = data;

    data.forEach((key, value) {
      state[key] = value;
    });

    if (data.isNotEmpty) {
      print(
          "6969696969696969699666666666666666666666666666666666666666666666666666666666669696969696969696996666666666666666666666666666666666666666666666666666666666" +
              data.toString());

      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BottomSheetState(data)));
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print("************************route***********************");
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
    // });

    // You can use sharedData in your build() method now
  }

  Future<Map> _getSharedData() async =>
      await platform.invokeMethod('getSharedData');

  @override
  Widget build(BuildContext context) {
    print(
        "**************************************************************************************" +
            state.toString());

    return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Text(
          'hell',
          style: TextStyle(color: Colors.transparent),
        ));
  }
}

class entity {
  String? subject;
  String? text;
  var fuc;

  entity({var fuc});

  // entity(this.subject, this.text);
}

class BottomSheetState extends StatefulWidget {
  var parentState;

  BottomSheetState(this.parentState);

  @override
  // ignore: no_logic_in_create_state
  BottomSheet createState() => BottomSheet(parentState);
}

class BottomSheet extends State<BottomSheetState> {
  var parentState;
  TextEditingController text = TextEditingController();

  BottomSheet(this.parentState);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("---");
    if (parentState.isNotEmpty) {
      text.text = "[subject] " +
          parentState['subject'] +
          " [text] " +
          parentState['text'];
    }
  }

  @override
  Widget build(BuildContext context) {
    print("/\/\/\/\/\/\/\/\/\/\/\/\/\/");
    print("------" + parentState.toString());

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 20,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              key: UniqueKey(),
                              onTap: () => SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop'),
                              child: const Text(
                                'close',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          style: const TextStyle(color: Colors.black),
                          minLines: 2,
                          maxLines: 5,
                          controller: text,
                        ),
                        const Expanded(
                          child: SizedBox(
                            width: 100,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            MaterialButton(
                              minWidth: 10,
                              onPressed: () {},
                              color: Colors.white,
                              child: const Text('date'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            MaterialButton(
                              minWidth: 10,
                              onPressed: () {},
                              color: Colors.white,
                              child: const Text('label'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            MaterialButton(
                              minWidth: 10,
                              onPressed: () {},
                              color: Colors.white,
                              child: const Text('topic'),
                            ),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.send,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
