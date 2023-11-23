
import 'dart:ffi';

import 'package:planb/cloud/cloudConnectAgent.dart';

import '../db/entity/cloudConnect.dart';

const service = 'http://$server/api/';

const server = '192.168.0.106:8080';

const github = 'https://warkfun.github.io/server.json';

String serverPath(){
  return serverAddress.server;
} 

String appServerPath(){
  return server;
} 



 class serverAddress{
  
  static var server;


  static Future<int> initialiseServerAddress() async{

    var response = await CloudConnectAgent().getServerAddressFromGithub();
    if(response.server!= "lite-horse"){
      print('current server - ${response.server}');
      server = response.server ;
      return 0;
    }

    return -1;
  }

}