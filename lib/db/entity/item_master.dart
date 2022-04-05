import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

import 'label_master.dart';

@Entity(
  tableName: 'ItemMaster',
  foreignKeys: [
    ForeignKey(
      childColumns: ['ypClassIDs'],
      parentColumns: ['labelId'],
      entity: Label,
    )
  ],
)
class ItemMaster {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String itemText;

  final String itemDescription;

  final String createdDateTime;

  final String userLabel;

  final String userTopicID;

  final bool synced;

  final String dueDate;

  @ColumnInfo(name: 'ypClassIDs')
  final int? ypClassIDs;

  final String ypTo;

  ItemMaster(
      {this.id,
      required this.itemText, 
      required this.itemDescription,
      required this.createdDateTime,
      required this.userLabel,
      required this.userTopicID,
      required this.synced,
      required this.dueDate,
      required this.ypClassIDs,
      required this.ypTo});
}
