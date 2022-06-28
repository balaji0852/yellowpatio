
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/db/entity/unused/user_store.dart';
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
  UserStore userStore = UserStore(linkedEmail: 'e', userName: 
  'e');
  bool initialized = false;
  late List<UserStore> accounts;

  
  Future<bool> registerUser(UserStore UserStore) async {
    // if (!initialized) {
      database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      userStoreDao = database.userStoreDao;
      userStore = userStore;
      initialized = true;
    // }
    await checkIfUserExist();
    if(accounts.isNotEmpty){
      //register the user in db
      userStoreDao.insertUser(UserStore);
      return true;
    }else{
      //just take the user ahead
      return false;
    }
  }

  Future<void> checkIfUserExist() async {
   accounts =
        await userStoreDao.findUserByEmail("demo@planB.com");
    if (accounts.isNotEmpty) {
      StoreConnector<AppStore, VoidCallback>(
        converter: (store) {
          return () => store.dispatch(
              ChangeBottomNavigationView(accounts.first.userStoreID!));
        },
        builder: (context, callback) {
          callback();
          return Text("waste");
        },
      );
    }

    // return false;
  }

  createUserFromFirebaseObject(UserStore userStore){
    var user = FirebaseAuth.instance.currentUser;
  }
}
