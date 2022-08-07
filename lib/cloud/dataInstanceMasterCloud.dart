
import 'package:yellowpatioapp/cloud/serverPath.dart';

import '../db/entity/data_instances_master.dart';
import 'package:http/http.dart' as http;


class DataInstanceMasterCloud{

  Future<int> postDataInstanceMaster(DataInstancesMaster dataInstancesMaster) async {
          
    var request = http.Request('POST',
        Uri.parse('${serverPath()}dataInstanceMaster'));
    request.body = dataInstancesMaster.toJsonString();
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    return response.statusCode;

  }


}