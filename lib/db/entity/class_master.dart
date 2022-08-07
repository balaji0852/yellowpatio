import 'package:floor/floor.dart';
import 'dart:convert';

import 'package:yellowpatioapp/db/entity/project_store.dart';

@Entity(tableName: "ClassMaster", foreignKeys: [
  ForeignKey(
    childColumns: ['projectStoreID'],
    parentColumns: ['projectStoreID'],
    entity: projectStore,
  )
])
class ClassMaster {
  @PrimaryKey(autoGenerate: true)
  final int? itemMasterID;

  final String itemName;

  final int categoryID;

  final int subCategoryID;

  final int itemClassColorID;

  final int itemPriority;

  final int isItemCommentable;

  final String description;

  final int projectStoreID;

  ClassMaster(
      {this.itemMasterID,
      required this.itemName,
      required this.categoryID,
      required this.subCategoryID,
      required this.itemClassColorID,
      required this.itemPriority,
      required this.isItemCommentable,
      required this.description,
      required this.projectStoreID});

  //cloud
  // {
  //      "itemMasterID": 2530,
  //       "itemName": "sight test",
  //       "categoryID": 1,
  //       "subCategoryID": 1,
  //       "itemClassColorID": 5,
  //       "itemPriority": 1,
  //       "isItemCommentable": 1,
  //       "description": "added this class from postman, smoke test. testing update api, class need to be used only gor update \n",
  //       "projectStore":{
  //           "projectStoreID": 2520
  //       }
  // }

  Map<String, dynamic> toMapObject() => {
        "itemName": itemName,
        "categoryID": categoryID,
        "subCategoryID": subCategoryID,
        "itemClassColorID": itemClassColorID,
        "itemPriority": itemPriority,
        "isItemCommentable": isItemCommentable,
        "description": description,
        "projectStore": {
          "projectStoreID": projectStoreID
        }
  };

  String toJsonString() {
    return jsonEncode(toMapObject());
  }

  String toJsonStringWithKey() {
    var classMaster = toMapObject();
    classMaster["itemMasterID"] = projectStoreID;
    return jsonEncode(classMaster);
  }

  
}
