import 'package:floor/floor.dart';
import 'dart:convert';

import 'package:yellowpatioapp/db/entity/project_store.dart';

@Entity(tableName: "ClassMaster",
foreignKeys: [
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

  String toJsonString() {
    return jsonEncode(<String, dynamic>{
      "itemName": itemName,
      "categoryID": categoryID,
      "subCategoryID": subCategoryID,
      "itemClassColorID": itemClassColorID,
      "itemPriority": itemPriority,
      "isItemCommentable": isItemCommentable,
      "description":description
    });
  }
}
