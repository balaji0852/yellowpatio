import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yellowpatioapp/login_page.dart';
// import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
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
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      String? foo = "puc u";
      try {
        if (msg!.contains('resumed')) {
          _getSharedData().then((d) async {
            if (d.isEmpty) {
              print(
                  "*****************************intent empty***************************************");
            } else {
              print(
                  "*****************************intent is not empty***************************************");
            }
            //     // Your logic here
            //     // E.g. at this place you might want to use Navigator to launch a new page and pass the shared data
          });
        } else {
          var data = await _getSharedData();

          print('l');
        }
        return Future.delayed(const Duration(seconds: 1), () => foo);
      } catch (Error) {
        print("throwing shit null");
        rethrow;
      }
    });

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

    sharedData = data;

    data.forEach((key, value) {
      state[key] = value;
    });

    if (data.isNotEmpty && await _googleSignIn.isSignedIn()) {
      print(
          "6969696969696969699666666666666666666666666666666666666666666666666666666666669696969696969696996666666666666666666666666666666666666666666666666666666666" +
              data.toString());

      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BottomSheetState(data)));
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
  var textStyle = TextStyle(color: Colors.red, fontSize: 15);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (parentState.isNotEmpty) {
      if (parentState['subject'] != null) {
        text.text = "[subject] : " + parentState['subject'].toString();
      }
      if (parentState['text'] != null) {
        text.text += " [text] : " + parentState['text'].toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: () => _showMyDialog(),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text("The changes you've made will not be saved."),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'cancel',
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'discard',
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            ),
          ],
        );
      },
    );
  }
}
