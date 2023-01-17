import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/db/entity/user_store.dart';
import 'package:yellowpatioapp/db/repository/unused/user_store_dao.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';

import '../db/database.dart';
import '../redux_state_store/appStore.dart';

class UserManagement {
  //register a user,
  //add the user to table and update the store
  //adding user, check if user account exist and add
  late var database;
  late var userStoreDao;
  late UserStore userStore;
  bool initialized = false;
  late List<UserStore> accounts;

  Future<int> registerUser(UserStore _userStore) async {
    // if (!initialized) {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    userStoreDao = database.userStoreDao;
    userStore = _userStore;
    initialized = true;
    // }
    if (await checkIfUserExist()) {
      //register the user in db
      userStoreDao.insertUser(_userStore).then((value) async {
        if (!await checkIfUserExist()) {
          return accounts.first.userStoreID;
        } else {
          return -1;
        }
      });
    } else {
      //just take the user ahead
      return accounts.first.userStoreID!;
    }
    return -1;
  }

  Future<bool> checkIfUserExist() async {
    accounts = await userStoreDao.findUserByEmail(userStore.linkedEmail);
    List<UserStore> allUser = await userStoreDao.findAllUser();
    

    // if (accounts.isNotEmpty) {
    //   StoreConnector<AppStore, VoidCallback>(
    //     converter: (store) {
    //       return () => store.dispatch(
    //           ChangeBottomNavigationView(accounts.first.userStoreID!));
    //     },
    //     builder: (context, callback) {
    //       callback();
    //       return Text("waste");
    //     },
    //   );
    // }

    return accounts.isEmpty;
  }

  Future<int> userRegisterationShim(BuildContext context) async {
    var _currentUser =  FirebaseAuth.instance.currentUser;
    UserStore userStore = UserStore(
        linkedEmail: _currentUser!.email!,
        userName: _currentUser.displayName!,
        dateViewPreference: 1,
        timeViewPreference: 1,
        themeID: 1,
        linkedPhone: _currentUser.phoneNumber,
        photoURL: "");
    int _userStoreID = await registerUser(userStore);

    return _userStoreID;
    // var state = StoreProvider.of<AppStore>(context);
    // state.dispatch(ChangeBottomNavigationView(_userStoreID));
  }

  // createUserFromFirebaseObject(var userStore) {
  //   var user = FirebaseAuth.instance.currentUser;
  // }
}
