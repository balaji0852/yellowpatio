import 'dart:convert';
import 'RegionStore.dart';

class ServicePlanStore{
  final int? serviceID;

  final String serviceName;

  final String? serviceDescription;

  final RegionStore regionStore;

  ServicePlanStore({
    this.serviceID,
    required this.serviceName,
    this.serviceDescription,
    required this.regionStore
  });

  Map<String,dynamic> toMapObject()=>
  {
    "regionStore":regionStore.toMapObjectWithKey(),
    "serviceDescription":serviceDescription,
    "serviceName":serviceName
  };


  Map<String,dynamic> toMapObjectWithKey()=>
  {
    "regionStore":regionStore.toMapObjectWithKey(),
    "serviceDescription":serviceDescription,
    "serviceName":serviceName,
    "serviceID":serviceID
  };

  

  String toJsonString() {
    return jsonEncode(toMapObject());
  }


  String toJsonStringWithKey() {
    var servicePlanStore = toMapObject();
    servicePlanStore["serviceID"] = serviceID;
    return jsonEncode(servicePlanStore);
  }


  


}