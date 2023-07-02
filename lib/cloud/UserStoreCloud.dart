
import 'package:http/http.dart' as http;
import 'package:planb/cloud/serverPath.dart';
import 'dart:convert' as convert;

import '../db/entity/user_store.dart';

//balaji : 1/17/2023 : adding to putUserStore, default userStoreID = 0
class UserStoreCloud{
   
  Future<int> postUserStore(UserStore userStore)async {
    var request = http.Request('POST', Uri.parse('${serverPath()}userStore'));
    request.body = userStore.toJsonString();
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    return response.statusCode;
  }


  Future<UserStore> putUserStore(UserStore userStore)async {
    var request = http.Request('PUT', Uri.parse('${serverPath()}userStore/update'));
    request.body = userStore.toJsonStringWithKey();
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    UserStore _userStore = UserStore(userStoreID: 0,linkedEmail:"empty"
    , userName:"empty", linkedPhone:"empty", photoURL:"empty");
    if(response.statusCode==200){
        var jsonResponse = 
        convert.jsonDecode(await response.stream.bytesToString());
        _userStore = UserStore(linkedEmail:jsonResponse["linkedEmail"],
            userName:jsonResponse["userName"],
            userStoreID: jsonResponse["userStoreID"],
            linkedPhone: jsonResponse["linkedPhone"],
            dateViewPreference:jsonResponse["dateViewPreference"],
            timeViewPreference: jsonResponse["timeViewPreference"],
            themeID: jsonResponse["themeID"]
            ,photoURL:jsonResponse["photoURL"]);
    }
    return _userStore;
  }


}