
import 'package:yellowpatioapp/cloud/serverPath.dart';
import 'package:yellowpatioapp/db/entity/class_data_instanceMaster.dart';
import '../db/entity/data_instances_master.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class DataInstanceMasterCloud{

  Future<int> postDataInstanceMaster(DataInstancesMaster dataInstancesMaster) async {
          
    var request = http.Request('POST',
        Uri.parse('${serverPath()}dataInstanceMaster'));
    request.body = dataInstancesMaster.toJsonString();
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    return response.statusCode;
  }

  Future<DataInstancesMaster?> findDataInstanceByLastComment(int itemMasterID) async{
    var request = http.Request('GET',
        Uri.parse('${serverPath()}dataInstanceMaster/lastComment?itemMasterID=$itemMasterID'));
    http.StreamedResponse response = await request.send();
    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());
    
    if(response.statusCode==200 && jsonResponse.toString().length>5){
      return DataInstancesMaster(
        itemMasterID: jsonResponse["classMaster"]["itemMasterID"], 
        dataInstances: jsonResponse["dataInstances"], 
        instancesTime: jsonResponse["instanceTime"], 
        instancesStatus: jsonResponse["instancesStatus"]);
    }

    return null;
  }

 Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByOneInterval(
    int dateTimeEpoch,
    int zeroDateTimeEpoch,
    int itemMasterID,
    int projectStoreID) async{
    var request = http.Request('GET',
        Uri.parse('${serverPath()}dataInstanceMaster/query1?dateTimeEpoch=$dateTimeEpoch&zeroDateTimeEpoch=$zeroDateTimeEpoch&itemMasterID=$itemMasterID'));
    http.StreamedResponse response = await request.send();
    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());
    
    if(response.statusCode==200 && jsonResponse.toString().length>5){
      List<ClassDataInstanceMaterDuplicate> listOfDataInstancesMaster = List.empty(growable: true);
      var listOfDataInstanceMaster = jsonResponse;
      for(var item in listOfDataInstanceMaster){
        listOfDataInstanceMaster.add(
          ClassDataInstanceMaterDuplicate(
            dataInstanceID: item["dataInstanceID"],
            itemMasterID: item["classMaster"]["itemMasterID"],
            dataInstances: jsonResponse["dataInstances"],
            instancesTime: jsonResponse["instanceTime"],
            itemClassColorID: item["classMaster"]["itemClassColorID"],
            instancesStatus: jsonResponse["instancesStatus"])
        );
      }
      return listOfDataInstancesMaster;
    }

    return null;
  }


   Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByIntervalWithClassMaster(
    int dateTimeEpoch,
    int zeroDateTimeEpoch,
    int projectStoreID)async{
    var request = http.Request('GET',
        Uri.parse('${serverPath()}dataInstanceMaster/query2?dateTimeEpoch=$dateTimeEpoch&zeroDateTimeEpoch=$zeroDateTimeEpoch&projectStoreID=$projectStoreID'));
    http.StreamedResponse response = await request.send();
    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());
    
    if(response.statusCode==200 && jsonResponse.toString().length>5){
      List<ClassDataInstanceMaterDuplicate> listOfDataInstancesMaster = List.empty(growable: true);
      var listOfDataInstanceMaster = jsonResponse;
      for(var item in listOfDataInstanceMaster){
        listOfDataInstanceMaster.add(
          ClassDataInstanceMaterDuplicate(
            dataInstanceID: item["dataInstanceID"],
            itemMasterID: item["classMaster"]["itemMasterID"],
            dataInstances: jsonResponse["dataInstances"],
            instancesTime: jsonResponse["instanceTime"],
            itemClassColorID: item["classMaster"]["itemClassColorID"],
            instancesStatus: jsonResponse["instancesStatus"])
        );
      }
      return listOfDataInstancesMaster;
    }

    return null;
  }

  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByOneIntervalV1(
    int dateTimeEpoch,
    int zeroDateTimeEpoch,
    int itemMasterID,
    int statusType,
    int projectStoreID)async{
    var request = http.Request('GET',
        Uri.parse('${serverPath()}dataInstanceMaster/status/query1?dateTimeEpoch=$dateTimeEpoch&zeroDateTimeEpoch=$zeroDateTimeEpoch&itemMasterID=$itemMasterID&instanceStatus=$statusType'));
    http.StreamedResponse response = await request.send();
    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());
    
    if(response.statusCode==200 && jsonResponse.toString().length>5){
      List<ClassDataInstanceMaterDuplicate> listOfDataInstancesMaster = List.empty(growable: true);
      var listOfDataInstanceMaster = jsonResponse;
      for(var item in listOfDataInstanceMaster){
        listOfDataInstanceMaster.add(
          ClassDataInstanceMaterDuplicate(
            dataInstanceID: item["dataInstanceID"],
            itemMasterID: item["classMaster"]["itemMasterID"],
            dataInstances: jsonResponse["dataInstances"],
            instancesTime: jsonResponse["instanceTime"],
            itemClassColorID: item["classMaster"]["itemClassColorID"],
            instancesStatus: jsonResponse["instancesStatus"])
        );
      }
      return listOfDataInstancesMaster;
    }

    return null;
  }

  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByIntervalWithClassMasterV1(
    int dateTimeEpoch,
    int zeroDateTimeEpoch,
    int statusType,
    int projectStoreID)async{
    var request = http.Request('GET',
        Uri.parse('${serverPath()}dataInstanceMaster/status/query2?dateTimeEpoch=$dateTimeEpoch&zeroDateTimeEpoch=$zeroDateTimeEpoch&projectStoreID=$projectStoreID&instanceStatus=$statusType'));
    http.StreamedResponse response = await request.send();
    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());
    
    if(response.statusCode==200 && jsonResponse.toString().length>5){
      List<ClassDataInstanceMaterDuplicate> listOfDataInstancesMaster = List.empty(growable: true);
      var listOfDataInstanceMaster = jsonResponse;
      for(var item in listOfDataInstanceMaster){
        listOfDataInstanceMaster.add(
          ClassDataInstanceMaterDuplicate(
            dataInstanceID: item["dataInstanceID"],
            itemMasterID: item["classMaster"]["itemMasterID"],
            dataInstances: jsonResponse["dataInstances"],
            instancesTime: jsonResponse["instanceTime"],
            itemClassColorID: item["classMaster"]["itemClassColorID"],
            instancesStatus: jsonResponse["instancesStatus"])
        );
      }
      return listOfDataInstancesMaster;
    }

    return null;
  }


}