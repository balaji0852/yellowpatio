import 'package:yellowpatioapp/cloud/serverPath.dart';
import 'package:yellowpatioapp/db/entity/VO/DataInstanceMasterVO.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:yellowpatioapp/db/entity/user_store.dart';

import '../db/entity/class_data_instanceMaster.dart';

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
          createdDate: item['createdDate'],
          userStore:UserStore(linkedEmail:item["userStore"]["linkedEmail"],
            userName:item["userStore"]["userName"],
            userStoreID: item["userStore"]["userStoreID"],
            linkedPhone: item["userStore"]["linkedPhone"],
            dateViewPreference:item["userStore"]["dateViewPreference"],
            timeViewPreference: item["userStore"]["timeViewPreference"],
            themeID: item["userStore"]["themeID"]
            ,photoURL:item["userStore"]["photoURL"]),
          projectStoreID: item["projectStore"]["projectStoreID"]));
      }
    
    }
     return listOfClassMasterList;
  }



   Future<List<DataInstanceMasterVO>> getAllByProjectStoreID(int projectStoreID,int userStoreID) async {
    List<DataInstanceMasterVO> listOfDataInstanceMasterList = List.empty(growable: true);
    var request = http.Request('GET',
        Uri.parse('${serverPath()}classMaster/directory/projectStore?projectStoreID=$projectStoreID&userStoreID=$userStoreID'));
    http.StreamedResponse response = await request.send();

    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());
    if(response.statusCode==200 && jsonResponse.toString().length>5){
      var listOfDataInstanceMasterVO = jsonResponse;
      for(var item in listOfDataInstanceMasterVO){
        listOfDataInstanceMasterList.add(
          DataInstanceMasterVO(classMaster: ClassMaster(
          itemMasterID: item["classMaster"]["itemMasterID"],
          itemName: item["classMaster"]["itemName"],
          categoryID: item["classMaster"]["categoryID"],
          subCategoryID: item["classMaster"]["subCategoryID"],
          itemClassColorID: item["classMaster"]["itemClassColorID"], 
          itemPriority: item["classMaster"]["itemPriority"], 
          isItemCommentable: item["classMaster"]["isItemCommentable"], 
          description: item["classMaster"]["description"], 
          carryForwardMyWork: item["classMaster"]['carryForwardMyWork'],
          createdDate: item["classMaster"]['createdDate'],
          userStore:UserStore(linkedEmail:item["classMaster"]["userStore"]["linkedEmail"],
            userName:item["classMaster"]["userStore"]["userName"],
            userStoreID: item["classMaster"]["userStore"]["userStoreID"],
            linkedPhone: item["classMaster"]["userStore"]["linkedPhone"],
            dateViewPreference:item["classMaster"]["userStore"]["dateViewPreference"],
            timeViewPreference: item["classMaster"]["userStore"]["timeViewPreference"],
            themeID: item["classMaster"]["userStore"]["themeID"]
            ,photoURL:item["classMaster"]["userStore"]["photoURL"]),
          projectStoreID: item["classMaster"]["projectStore"]["projectStoreID"]), 
          classDataInstanceMaterDuplicate: ClassDataInstanceMaterDuplicate(
            dataInstanceID: item["dataInstanceID"],
            itemMasterID: item["classMaster"]["itemMasterID"],
            dataInstances: item["dataInstances"],
            instancesTime: item["instanceTime"],
            itemClassColorID: item["classMaster"]["itemClassColorID"],
            //sig:54
            itemName: item["classMaster"]["itemName"],
            description: item["classMaster"]["description"],
            //sig:54
            
            userStore: UserStore(linkedEmail: item["userStore"]["linkedEmail"],
            userName: item["userStore"]["userName"],
            userStoreID: item["userStore"]["userStoreID"],
            linkedPhone: item["userStore"]["linkedPhone"],
            dateViewPreference: item["userStore"]["dateViewPreference"],
            timeViewPreference: item["userStore"]["timeViewPreference"],
            themeID: item["userStore"]["themeID"]
            ,photoURL: item["userStore"]["photoURL"]),
            instancesStatus: item["instancesStatus"]),
          pinnedForCurrentUser: item["pinnedForCurrentUser"]) 
         );
      }
    
    }
     return listOfDataInstanceMasterList;
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
