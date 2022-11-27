
import 'dart:convert';
import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/ServicePlanStore.dart';
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

  final int? userStoreID;

  final ServicePlanStore servicePlanStore;

  projectStore({
    this.projectStoreID,
    required this.projectName,
    required this.projectDescription,
    this.userStoreID,
    this.deactivateProject,
    required this.servicePlanStore
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
    "projectDescription":projectDescription,
    "servicePlanStore":servicePlanStore.toMapObjectWithKey()
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