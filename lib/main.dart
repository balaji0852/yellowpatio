import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yellowpatioapp/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(
            textTheme: const TextTheme(
                bodyText1: TextStyle(color: Colors.black, fontSize: 16))),
        home: RootWidget());
  }
}

class RootWidget extends StatefulWidget {
  @override
  _RootWidgetState createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  static const platform = const MethodChannel('app.channel.shared.data');
  Map<dynamic, dynamic> sharedData = Map();
  var state = {};
  TextEditingController text = TextEditingController();

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
    SystemChannels.lifecycle.setMessageHandler((msg) {
      Future<String?> foo = "puc" as Future<String?>;
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
        }
        return foo;
      } catch (Error) {
        print("throwing shit null");
        rethrow;
      }
    });

    // Case 2: App is started by the intent:
    // Call Java MethodHandler on application start up to check for shared data
    var data = await _getSharedData();
    print("******************************decision*************************");
    print(data);

    //******************************************************* */
    //*****************&&&&**************&&&&***************** */
    //******************************************************* */
    //*********take to application-----the real one;)*********/
    //*********************&&&&*****&&&&&********************* */
    //***********************&&&&&&&&&&********************** */

    setState(() {
      sharedData = data;

      data.forEach((key, value) {
        state[key] = value;
      });

      if (state.isNotEmpty) {
        text.text =
            "[subject] " + state['subject'] + " [text] " + state['text'];
      } else {
        print("************************route***********************");
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });

    // You can use sharedData in your build() method now
  }

  Future<Map> _getSharedData() async =>
      await platform.invokeMethod('getSharedData');

  @override
  Widget build(BuildContext context) {
    print(
        "**************************************************************************************" +
            state.toString());

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
                          height: 5,
                          child: Container(
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              minWidth: 10,
                              onPressed: () {
                                SystemChannels.platform
                                    .invokeMethod('SystemNavigator.pop');
                              },
                              color: Colors.red,
                              child: const Text('close'),
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                        TextField(
                          style: const TextStyle(color: Colors.black),
                          minLines: 2,
                          maxLines: 5,
                          controller: text,
                        )
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
