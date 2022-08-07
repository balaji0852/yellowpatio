
import 'dart:convert';
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

    //cloud
    // {
    //     "deactivateProject": false,
    //     "servicePlanID": 1,
    //     "projectName": "demo project cloud 4",
    //     "projectDescription": "demo project",
    //     "projectStoreID": 2528
    // }

  Map<String,dynamic> toMapObject()=>
  {
    "deactivateProject":deactivateProject,
    "servicePlanID":1,
    "projectName":projectName,
    "projectDescription":projectDescription
  };

  String toJsonString() {
    return jsonEncode(toMapObject());
  }


  String toJsonStringWithKey() {
    var projectStore = toMapObject();
    projectStore["projectStoreID"] = projectStoreID;
    return jsonEncode(projectStore);
  }

}