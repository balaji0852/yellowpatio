import 'package:http/http.dart' as http;


import 'package:yellowpatioapp/cloud/serverPath.dart';
import 'package:yellowpatioapp/db/entity/pinnedClass.dart';

class directoryController{

  Future<int> putPinClassMaster(pinnedClass pinnedClass) async {
    var request = http.Request('PUT', Uri.parse('${serverPath()}classMaster/directory'));
    request.body = pinnedClass.toJsonStringWithKey();
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    return response.statusCode;
  }

}