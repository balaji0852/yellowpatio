import 'package:floor/floor.dart';

@Entity(tableName: "UserStore")
class UserStore {
  @PrimaryKey(autoGenerate: true)
  final int? userStoreID;

  final String linkedEmail;

  final int dateViewPreference;

  final int timeViewPreference;

  final int themeID;

  final String userName;

  UserStore(
      {this.userStoreID,
      required this.linkedEmail,
      required this.dateViewPreference,
      required this.timeViewPreference,
      required this.themeID,
      required this.userName});
}
