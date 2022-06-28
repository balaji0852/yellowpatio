import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

@Entity(tableName: "UserStore")
class UserStore {
  @PrimaryKey(autoGenerate: true)
  final int? userStoreID;

  final String linkedEmail;

  final String? linkedPhone;

  final int? projectStoreID;

  final int? dateViewPreference;

  final int? timeViewPreference;

  final int? themeID;

  final String userName;

  UserStore({
        required this.linkedEmail,
        required this.userName,
        this.userStoreID,
        this.linkedPhone,
        this.projectStoreID,
        this.dateViewPreference,
        this.timeViewPreference,
        this.themeID});
}
