import 'package:http/http.dart' as http;
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';

var headers = {'Content-Type': 'application/json'};

postClassMaster(ClassMaster classMaster) async {
  var request = http.Request('POST',
      Uri.parse('https://sightcloud.azurewebsites.net/api/dataInstanceMaster'));
  request.body = classMaster.toJsonString();
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  print(response.statusCode);
}

postDataInstanceMaster(DataInstancesMaster dataInstancesMaster) async {
  // http.post(
  //   Uri.parse('https://sightcloud.azurewebsites.net/api/dataInstanceMaster'),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   },
  //   body: jsonEncode(<String, dynamic>{
  //     'instanceTime': dataInstancesMaster.instancesTime,
  //   }),
  // ).then((value) => print(value.statusCode));

  var request = http.Request('POST',
      Uri.parse('https://sightcloud.azurewebsites.net/api/dataInstanceMaster'));
  request.body = dataInstancesMaster.toJsonString();
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  print(response.statusCode);
}














 
  // var client = new http.Client();
  // client.post(
  //     Uri.parse('https://sightcloud.azurewebsites.net/api/dataInstanceMaster'),
  //     body: dataInstancesMaster.toJsonString()  ).then((response) {
  //   client.close();
  //   if (response.statusCode == 200) {
  //     //enter your code for change state
  //     print('success');
  //   }
  // }).catchError((onError) {
  //   client.close();
  //   print("Error: $onError");
  // });

