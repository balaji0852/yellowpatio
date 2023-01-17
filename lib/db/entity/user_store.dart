import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';


@Entity(tableName: "UserStore")
class UserStore {
  @PrimaryKey(autoGenerate: true)
  final int? userStoreID;

  final String linkedEmail;

  final String? linkedPhone;


  final int? dateViewPreference;

  final int? timeViewPreference;

  final int? themeID;

  final String userName;

  final String photoURL;

  UserStore({
        required this.linkedEmail,
        required this.userName,
        this.userStoreID,
        required this.linkedPhone,
        this.dateViewPreference,
        this.timeViewPreference,
        this.themeID,
        required this.photoURL});

  // cloud
  //   {
  //     "userStoreID": 2519,
  //      "dateViewPreference": 1,
  //     "timeViewPreference": 1,
  //     "linkedEmail": "balajikumar189@gmail.com",
  //     "linkedPhone": "8151033423",
  //     "themeID": 1,
  //     "userName": "balaji r"
  //   }


  Map<String,dynamic> toMapObject()=>
  {
    "dateViewPreference": dateViewPreference,
    "timeViewPreference": timeViewPreference,
    "linkedEmail": linkedEmail,
    "linkedPhone": linkedPhone,
    "themeID": themeID,
    "userName": userName,
    "photoURL":photoURL
  };

  String toJsonString() {
    return jsonEncode(toMapObject());
  }


  String toJsonStringWithKey() {
    var userStore = toMapObject();
    userStore["userStoreID"] = userStoreID;
    return jsonEncode(userStore);
  }


}
