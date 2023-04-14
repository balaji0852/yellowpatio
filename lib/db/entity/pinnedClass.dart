


import 'dart:convert';

import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/user_store.dart';

class pinnedClass{
  final int pinID;

  final bool isPinned;

  final int folderID;

  final int userStoreID;

  final ClassMaster classMaster;


  pinnedClass({
    required this.pinID,
   required this.isPinned,
    required  this.folderID,
    required  this.userStoreID,
    required  this.classMaster
  });


  Map<String,dynamic> toMapObject()=>  {
        
        "userStore": {
            "userStoreID": userStoreID
        },
        "classMaster": {
            "itemMasterID": classMaster.itemMasterID
        },
        "folderID": 2,
        "pinned": isPinned
  };


  String toJsonStringWithKey() {
    
    return jsonEncode(toMapObject());
  }
}