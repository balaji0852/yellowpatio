

import 'package:http/http.dart' as http;
import 'package:planb/cloud/serverPath.dart';
import 'dart:convert' as convert;

import '../db/entity/cloudConnect.dart';



class CloudConnectAgent {
  
  Future<cloudConnect> getServerAddressFromGithub() async {
    var request = http.Request('GET',
        Uri.parse(github));
    http.StreamedResponse response = await request.send();
    cloudConnect sample = cloudConnect(server: "lite-horse");
    var jsonResponse =
        convert.jsonDecode(await response.stream.bytesToString());
    if(response.statusCode==200){
      sample = cloudConnect(server: jsonResponse['server']);
    }
     return sample;
  }
  }
