import 'dart:convert';

class ProjectSetting{

  final int projectSettingID;

  final int projectStoreID;

  final bool carryForwardMyWork;

  ProjectSetting({required this.projectSettingID,required this.projectStoreID,required this.carryForwardMyWork});

   Map<String, dynamic> toMapObject() => {
    "projectStore": {
        // "deactivateProject": false,
        // "servicePlanStore": {
        //     "regionStore": {
        //         "regionID": 1,
        //         "regionName": "central india",
        //         "regionDescription": "test region ",
        //         "server": "https://sighcloud2.azurewebsites.net/"
        //     },
        //     "serviceID": 1,
        //     "serviceName": "b1 free",
        //     "serviceDescription": "b1"
        // },
        // "projectName": "planB",
        // "projectDescription": "",
        "projectStoreID": projectStoreID
    },
    "carryForwardMyWork": carryForwardMyWork
};

  String toJsonString() {
    return jsonEncode(toMapObject());
  }

  String toJsonStringWithKey() {
    Map<String, dynamic> projectSetting = toMapObject();
    projectSetting["projectSettingID"] = projectSettingID;
    return jsonEncode(projectSetting);
  }

}