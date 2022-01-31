import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:yellowpatioapp/login_page.dart';
import 'package:yellowpatioapp/main.dart';
import 'Pages/input_page.dart';
import 'Pages/home_page.dart';
import 'Pages/insights_page.dart';
// import 'db/Person.dart';
// import 'db/database.dart';
// import 'db/Note.dart';
// import 'package:floor/floor.dart';

class Home extends StatefulWidget {
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  int _selectedIndex = 0;
  static const String appName = "Speechry";
  var state = {'photoURL': 'nan'};
  // Stream<Note>? result;
  static final List<Widget> _widgetOptions = <Widget>[
    homePage(),
    InsightsPage(),
    AddPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //getting user profile picture url;
    //******************************************************* */
    //speechry method
    //getNotes();
    ////////////////////////////////////////////////////////////5
    ///
    ///
    getUser();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  // Future getNotes() async {
  //   final database =
  //       await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  //   List<Person> notes = await database.personDao.findAllPersons();
  //   print(
  //       "***************************************************************************");
  // }

  getUser() {
    setState(() {
      try {
        state['photoURL'] =
            FirebaseAuth.instance.currentUser!.photoURL.toString();
      } catch (e) {
        print('************************************' +
            e.toString() +
            '**********************************');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        actions: <Widget>[
          // if (state['nan'] != 'nan')
          MaterialButton(
            onPressed: signOut,
            child: CircleAvatar(
              backgroundImage: NetworkImage(state['photoURL'].toString()),
              backgroundColor: Colors.yellow,
              radius: 16,
            ),
          )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'new',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}