import 'dart:convert';




class ClassDataInstanceMaterDuplicate{

  final int? dataInstanceID;

  final int itemMasterID;

  final String dataInstances;

  final int instancesTime;

  final int itemClassColorID;
  
  final int instancesStatus;

  



  ClassDataInstanceMaterDuplicate(
      {this.dataInstanceID,
      required this.itemMasterID, 
      required this.dataInstances,
      required this.instancesTime,
      required this.itemClassColorID,
      required this.instancesStatus,
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
      "instancesStatus": instancesStatus
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