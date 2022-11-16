// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yellowpatioapp/config.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/home_drawer.dart';
import 'package:yellowpatioapp/login_page.dart';
import 'package:yellowpatioapp/redux_state_store/appStore.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/selected_index_reducer.dart';
import 'Pages/home_page.dart';
import 'Pages/insights_page.dart';
// import 'db/Person.dart';
// import 'db/database.dart';
// import 'db/Note.dart';
// import 'package:floor/floor.dart';

//In Flutter eager initialization makes the object declaration final, thats the concept,
//20/05/2022 - moving _selectedIndex to central redux store...
class Home extends StatefulWidget {
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> {
  HomePage() {
    print('constructor');

    homePageInstance = homePage(changePage: changePageIndex);
    _widgetOptions = <Widget>[
      homePageInstance,
      InsightsPage(
        editable: false,
      ),
    ];
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  int _selectedIndex = 0;
  static const String appName = "planB";
  ClassMaster? classMaster;
  var state = {'photoURL': 'nan'};
  // Stream<Note>? result;
  late Widget homePageInstance;
  late List<Widget> _widgetOptions;

  void changePageIndex(int index, ClassMaster classMaster, bool editable) {
    //editable true, then set index to 1, and set the InsightsPage
    //editable false, then set index to 0, and set the
    print('changePageIndex(');
    // WidgetsBinding.instance.addPostFrameCallback((_) => 
    setState(() {
          print('changePageIndex(2');

          _selectedIndex = index;
          this.classMaster = classMaster;
          if (_selectedIndex == 1) {
            _widgetOptions[_selectedIndex] = editable
                ? InsightsPage(
                    editable: editable,
                    classMaster: this.classMaster,
                    changePage: changePageIndex,
                  )
                : InsightsPage(
                    editable: false,
                  );
          }

          print(_widgetOptions.toList());
        });
  }

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
    print('initState');
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
    return StoreConnector<AppStore, int>(
      converter: (store) => store.state.selectedIndex,
      builder: (context, bottomNavigationCurrentIndex) {
        //checking index for bottomNavigation
        print(bottomNavigationCurrentIndex);

        return Scaffold(
          drawer: HomeDrawer(),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(appName, style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            actions: <Widget>[
              MaterialButton(
                onPressed: signOut,
                child: state['nan'] != 'nan'
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(state['photoURL']!),
                        backgroundColor: Colors.yellow,
                        radius: 16)
                    : const CircleAvatar(
                        backgroundColor: Colors.lightBlue, radius: 16),
              )
            ],
          ),
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.insights),
                label: 'add',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            onTap: (index) {
              _onItemTapped(index);
            },
          ),
        );
      },
    );
  }
}
