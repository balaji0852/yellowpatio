import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  //app has no user state - 0
  var state = 0;

  @override
  void initState() {
    super.initState();
    checkUser();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      //account!=null take user into the app
      //Now the state is 1, app has a user;

      // Navigator.pop(context);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Home()),
      // );
      print(
          "!@#~%^&*(------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    });
    //_googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Speechry',
          ),
          ElevatedButton(onPressed: signInWithGoogle, child: Text("sign-in")),
        ],
      ),
    ));
  }

  Future signInWithGoogle() async {
    try {
      //now the state is 2, A user is trying to sign in
      setState(() {
        state = 2;
      });

      final googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount == null) return;

      final googleAuth = await googleSignInAccount.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (Exception) {
      //set the state to 0;
      setState(() {
        state = 0;
      });

      print(Exception);
    }
  }

  Future<void> checkUser() async {
    //write logic to check presence of user;
    if (await _googleSignIn.isSignedIn()) {
      // Navigator.pop(context);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Home()),
      // );
      print("!@#~%^&*(");
    }
  }
}
