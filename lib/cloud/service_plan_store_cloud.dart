import 'package:yellowpatioapp/cloud/serverPath.dart';
import 'package:yellowpatioapp/db/entity/ServicePlanStore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../db/entity/RegionStore.dart';

class ServicePlanStoreCloud {
  Future<List<ServicePlanStore>> getServicePlans() async {
    var request =
        http.Request('GET', Uri.parse('${serverPath()}servicePlanStore'));
    http.StreamedResponse response = await request.send();
    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());
    List<ServicePlanStore> listOfServicePlanStoreList =
        List.empty(growable: true);
    if (response.statusCode == 200 && jsonResponse.toString().length > 2) {
      var listOfServicePlanStore = jsonResponse;
      for (var item in listOfServicePlanStore) {
        listOfServicePlanStoreList.add(ServicePlanStore(
            serviceID: item['serviceID'],
            serviceName: item['serviceName'],
            serviceDescription: item['serviceDescription'],
            regionStore: RegionStore(
                regionID: item['regionStore']['regionID'],
                regionName: item['regionStore']['regionName'],
                regionDescription: item['regionStore']['regionDescription'],
                server: item['regionStore']['server'])));
      }
    }

    return listOfServicePlanStoreList;
  }
}
