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

  Future<List<ClassMaster>?> findItemById(int projectStoreID) async {
    List<ClassMaster> classMasterItems = List.empty(growable: true);
    var request = http.Request('GET',
        Uri.parse('${serverPath()}classMaster/projectStore/$projectStoreID'));
    http.StreamedResponse response = await request.send();

    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());
    classMasterItems = jsonResponse;
    // if (response.statusCode==200) {
    //   classMasterItems = jsonResponse;
    //   return classMasterItems;
    // }
    return classMasterItems;
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
