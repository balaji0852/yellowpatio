import 'package:yellowpatioapp/Pages/project_setting.dart';
import 'package:yellowpatioapp/cloud/serverPath.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:yellowpatioapp/db/entity/project_setting.dart';


class projectSettingCloud{



  Future<int> putProjectSetting(ProjectSetting projectSetting) async{
     var request = http.Request('PUT', Uri.parse('${serverPath()}projectSetting'));
    request.body = projectSetting.toJsonStringWithKey();
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    return response.statusCode;
  }

  Future<ProjectSetting> getProjectSetting(int projectStoreID) async{
    var request = http.Request('GET',
        Uri.parse('${serverPath()}projectSetting/$projectStoreID'));
    http.StreamedResponse response = await request.send();
    var projectSetting = ProjectSetting(projectSettingID: 1, projectStoreID: 1, carryForwardMyWork: false);
    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());
    if(response.statusCode==200 && jsonResponse.toString().length>5){
      projectSetting = ProjectSetting(
        projectSettingID: jsonResponse["projectSettingID"], 
        projectStoreID: jsonResponse["projectStore"]["projectStoreID"], 
        carryForwardMyWork: jsonResponse["carryForwardMyWork"]);
    }

    return projectSetting;
  }
}