import 'package:yellowpatioapp/cloud/serverPath.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ClassMasterCloud {

  
  Future<int> postClassMasterMaster(ClassMaster classMaster) async {
    var request = http.Request('POST', Uri.parse('${serverPath()}classMaster'));
    request.body = classMaster.toJsonString();
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    return response.statusCode;
  }

  Future<List<ClassMaster>> findItemById(int projectStoreID) async {
    List<ClassMaster> listOfClassMasterList = List.empty(growable: true);
    var request = http.Request('GET',
        Uri.parse('${serverPath()}classMaster/projectStore/$projectStoreID'));
    http.StreamedResponse response = await request.send();

    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());
    if(response.statusCode==200 && jsonResponse.toString().length>5){
      var listOfClassMaster = jsonResponse;
      for(var item in listOfClassMaster){
        listOfClassMasterList.add(
         ClassMaster(
          itemMasterID: item["itemMasterID"],
          itemName: item["itemName"],
          categoryID: item["categoryID"],
          subCategoryID: item["subCategoryID"],
          itemClassColorID: item["itemClassColorID"], 
          itemPriority: item["itemPriority"], 
          isItemCommentable: item["isItemCommentable"], 
          description: item["description"], 
          carryForwardMyWork: item['carryForwardMyWork'],
          projectStoreID: item["projectStore"]["projectStoreID"]));
      }
    
    }
     return listOfClassMasterList;
  }

  Future<int> deleteItemById(int itemMasterID) async {
    var request = http.Request('DELETE',
        Uri.parse('${serverPath()}classMaster/$itemMasterID'));
    http.StreamedResponse response = await request.send();
    return response.statusCode;
  }

  Future<int> putClassMasterMaster(ClassMaster classMaster) async {
    var request = http.Request('PUT', Uri.parse('${serverPath()}classMaster'));
    request.body = classMaster.toJsonStringWithKey();
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    return response.statusCode;
  }


}
