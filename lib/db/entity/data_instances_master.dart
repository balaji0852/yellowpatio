import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'dart:convert';

import 'package:yellowpatioapp/db/entity/user_store.dart';

@Entity(
  tableName: 'DataInstancesMaster',
  foreignKeys: [
    ForeignKey(
      childColumns: ['itemMasterID'],
      parentColumns: ['itemMasterID'],
      entity: ClassMaster,
    )
  ],
)
class DataInstancesMaster {
  @PrimaryKey(autoGenerate: true)
  final int? dataInstanceID;

  final int itemMasterID;

  final String dataInstances;

  final int instancesTime;

  final int instancesStatus;

  final UserStore userStore;

  DataInstancesMaster(
      {this.dataInstanceID,
      required this.itemMasterID,
      required this.dataInstances,
      required this.instancesTime,
      required this.instancesStatus,
      required this.userStore
  });


  //cloud
  // {
  //   "classMaster": {
  //       "itemMasterID": 2542
  //   },
  //   "dataInstances": "4",
  //   "instanceTime":   1656181019013,
  //   "instancesStatus": 2
  // }

  Map<String,dynamic> toMapObject()=>
  {
      "classMaster": {
          "itemMasterID": itemMasterID
      },
      "dataInstances": dataInstances,
      "instanceTime": instancesTime,
      "instancesStatus": instancesStatus,
      "userStore":{
        "userStoreID":userStore.userStoreID
      }
  };

  String toJsonString() {
    return jsonEncode(toMapObject());
  }


  String toJsonStringWithKey() {
    Map<String, dynamic> dataInstancesMaster = toMapObject();
    dataInstancesMaster["dataInstanceID"] = dataInstanceID;
    return jsonEncode(dataInstancesMaster);
  }

}
