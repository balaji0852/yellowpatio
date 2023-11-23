import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planb/Pages/projectPage.dart';
import 'package:planb/SupportSystem/user_management.dart';
import 'package:planb/cloud/UserStoreCloud.dart';
import 'package:planb/cloud/cloudConnectAgent.dart';
import 'package:planb/cloud/serverPath.dart';
import 'package:planb/db/entity/user_store.dart';
import 'package:planb/redux_state_store/action/actions.dart';
import 'package:planb/redux_state_store/appStore.dart';
import 'package:planb/redux_state_store/reducer/userStoreReducer.dart';
import 'home.dart';

//balaji : 1/17/2021 , bug 5 - modifying putUserStore usage, validating userStoreID - 0
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
      print(account);
      //account!=null take user into the app
      //Now the state is 1, app has a user;
      // if (await _googleSignIn.isSignedIn()) {
      //   var userManagement = UserManagement();
      //   userManagement.userRegisterationShim(context);
      // }
      // Navigator.pop(context);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Home()),
      // );
      Future.delayed(const Duration(milliseconds: 2000), () {
        checkUser();
      });

      print(
          "!@#~%^&*(------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    });
    //_googleSignIn.signInSilently();
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('state chnage');
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
            Column(
              children: [
                
                Image.asset("assets/planb-icon.JPG",
                height: 100,
                width: 100,
                ),
                const Text(
                  'planB',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: signInWithGoogle, child: const Text("sign-in")),
          ],
        ),
      ),
    );
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

      UserStore userStore = UserStore(
          linkedEmail: googleSignInAccount.email,
          userName: "empty",
          linkedPhone: "empty",
          themeID: -1,
          dateViewPreference: -1,
          photoURL: googleSignInAccount.photoUrl!);

      await UserStoreCloud().postUserStore(userStore);
    } catch (Exception) {
      //set the state to 0;
      setState(() {
        state = 0;
      });
    }
  }

  Future<void> checkUser() async {
    //write logic to check presence of user;
    if (await _googleSignIn.isSignedIn() && await serverAddress.initialiseServerAddress()!=-1) {
      //cloud migration
      // var userManagement = UserManagement();
      // int _userStoreID = await userManagement.userRegisterationShim(context);
      // while (_userStoreID==-1){
      //   _userStoreID = await userManagement.userRegisterationShim(context);
      // }
      UserStore userStore = UserStore(
          linkedEmail: FirebaseAuth.instance.currentUser!.email!,
          userName: FirebaseAuth.instance.currentUser!.displayName!,
          linkedPhone: FirebaseAuth.instance.currentUser!.phoneNumber == null
              ? "empty"
              : FirebaseAuth.instance.currentUser!.phoneNumber!,
          photoURL: FirebaseAuth.instance.currentUser!.photoURL!,
          themeID: -1,
          timeViewPreference: -1,
          dateViewPreference: -1);

      userStore = await UserStoreCloud().putUserStore(userStore);

      if (userStore.userStoreID != 0) {
        var state = StoreProvider.of<AppStore>(context);
        state.dispatch(ChangeUserStoreID(userStore.userStoreID!));
        state.dispatch(ChangeDateViewPreference(userStore.dateViewPreference!));
        state.dispatch(ChangeDarkMode(userStore.themeID == 1 ? true : false));
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProjectPage()),
        );
      }
      print("!@#~%^&*(");
    }
  }

  // userRegisterationShim() async {
  //   var userManagement = UserManagement();
  //   var _currentUser = FirebaseAuth.instance.currentUser;
  //   UserStore userStore = UserStore(
  //       linkedEmail: _currentUser!.email!,
  //       userName: _currentUser.displayName!,
  //       dateViewPreference: 1,
  //       timeViewPreference: 1,
  //       themeID: 1,
  //       linkedPhone: _currentUser.phoneNumber,
  //       projectStoreID: 999);
  //   int _userStoreID = await userManagement.registerUser(userStore);
  //   var state = StoreProvider.of<AppStore>(context);
  //   if (_userStoreID == -1) {
  //   } else {
  //     state.dispatch(ChangeBottomNavigationView(_userStoreID));
  //   }
  // }
}
