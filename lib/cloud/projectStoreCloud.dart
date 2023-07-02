import 'package:http/http.dart' as http;
import 'package:planb/cloud/serverPath.dart';
import 'package:planb/db/entity/RegionStore.dart';
import 'package:planb/db/entity/ServicePlanStore.dart';
import 'dart:convert' as convert;
import 'package:planb/db/entity/project_store.dart';

class projectStoreCloud {
  Future<int> postProjectStore(
      projectStore projectStore, int userStoreID) async {
    var request = http.Request('POST',
        Uri.parse('${serverPath()}projectStore?userStoreID=$userStoreID'));
    request.body = projectStore.toJsonString();
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    String jsonResponse = await response.stream.bytesToString();
    return response.statusCode==200?int.parse(jsonResponse):-1;
  }

  Future<List<projectStore>> findAllProjectByUserStoreID(
      int userStoreID) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            '${serverPath()}projectStore/projects?userStoreID=$userStoreID'));
    http.StreamedResponse response = await request.send();
    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());

    List<projectStore> listOfProjectStoreList = List.empty(growable: true);

    if (response.statusCode == 200 && jsonResponse.toString().length > 5) {
      var listOfProjectStore = jsonResponse;
      for (var item in listOfProjectStore) {
        listOfProjectStoreList.add(projectStore(
            projectStoreID: item["projectStoreID"],
            projectName: item["projectName"],
            projectDescription: item["projectDescription"],
            userStoreID: userStoreID,
            deactivateProject: item["deactivateProject"],
            servicePlanStore: ServicePlanStore(
                serviceID: item['servicePlanStore']['serviceID'],
                serviceName: item['servicePlanStore']['serviceName'],
                serviceDescription: item['servicePlanStore']
                    ['serviceDescription'],
                regionStore: RegionStore(
                    regionID: item['servicePlanStore']['regionStore']
                        ['regionID'],
                    regionName: item['servicePlanStore']['regionStore']
                        ['regionName'],
                    regionDescription: item['servicePlanStore']['regionStore']
                        ['regionDescription'],
                    server: item['servicePlanStore']['regionStore']
                        ['server']))));
      }
    }
    return listOfProjectStoreList;
  }
}
