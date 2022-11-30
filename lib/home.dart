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
  //11/28/2022 : balaji , using local variable to set darkMode
  bool darkMode = false;
  var reduxState;

  void changePageIndex(int index, ClassMaster classMaster, bool editable) {
    //editable true, then set index to 1, and set the InsightsPage
    //editable false, then set index to 0, and set the
    print('changePageIndex(');
    // WidgetsBinding.instance.addPostFrameCallback((_) =>
    setState(() {
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
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      //sig50, balaji this issue was required to remove dirty class from widget list.
      if (index == 0) {
        _widgetOptions[1] = InsightsPage(
          editable: false,
        );
      }
      //sig50
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

  @override
  void didUpdateWidget(covariant Home oldWidget) {
    super.didUpdateWidget(oldWidget);

    print("oop");
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
    reduxState = StoreProvider.of<AppStore>(context);
    darkMode = reduxState.state.darkMode;
    return StoreConnector<AppStore, bool>(
      converter: (store) => store.state.darkMode,
      builder: (context, _darkMode) {

        return Scaffold(
          drawer: HomeDrawer(),
          appBar: AppBar(
            iconTheme:
                IconThemeData(color: _darkMode ? Colors.white : Colors.black),
            title: Text(appName,
                style:
                    TextStyle(color: _darkMode ? Colors.white : Colors.black)),
            backgroundColor: _darkMode ? Colors.black : Colors.white,
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
            backgroundColor: _darkMode ? Colors.black : Colors.white,
            unselectedLabelStyle:
                TextStyle(color: _darkMode ? Colors.white : Colors.black),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _darkMode ? Colors.white : Colors.black,
                ),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.insights,
                  color: _darkMode ? Colors.white : Colors.black,
                ),
                label: 'add',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: _darkMode ? Colors.white : Colors.black,
            onTap: (index) {
              _onItemTapped(index);
            },
          ),
        );
      },
    );
  }
}
