

import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/unused/user_store.dart';

@Entity(
  foreignKeys: [
    ForeignKey(childColumns: ["userStoreID"], 
    parentColumns: ["userStoreID"],
    entity: UserStore)
  ]
)
class projectStore{
  @PrimaryKey(autoGenerate: true)
  final int? projectStoreID;

  final String projectName;

  final String projectDescription;

  final bool? deactivateProject;

  final int userStoreID;

  projectStore({
    this.projectStoreID,
    required this.projectName,
    required this.projectDescription,
    required this.userStoreID,
    this.deactivateProject
  });



}