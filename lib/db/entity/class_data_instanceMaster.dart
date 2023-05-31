import 'dart:convert';

import 'package:yellowpatioapp/db/entity/user_store.dart';




class ClassDataInstanceMaterDuplicate{

  final int? dataInstanceID;

  final int itemMasterID;

  final String dataInstances;

  final int instancesTime;

  final int itemClassColorID;
  
  final int instancesStatus;

  //balaji : 10/15/2022-adding extra class master fields(title,description), to satisfy the 
  //          graph dialog(sig-54),
  //balaji : this is a test feature may be we might making , classmaste field required
  //          for this constr
  String? itemName = 'itemName';

  String? description = 'description';

  final UserStore userStore;
  
  //sig-50

  



  ClassDataInstanceMaterDuplicate(
      {this.dataInstanceID,
      required this.itemMasterID, 
      required this.dataInstances,
      required this.instancesTime,
      required this.itemClassColorID,
      required this.instancesStatus,
      required this.userStore,
      //sig-50
      this.itemName,
      this.description,

      //sig-50
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
    var classDataInstanceMaterDuplicateStore = toMapObject();
    classDataInstanceMaterDuplicateStore["dataInstanceID"] = dataInstanceID;
    return jsonEncode(classDataInstanceMaterDuplicateStore);
  }


}