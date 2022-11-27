
import 'dart:convert';

class RegionStore{

     final int? regionID;

     final String regionName;

     final String?  regionDescription;

     final String server;

     RegionStore({
      this.regionID,
      required this.regionName,
      this.regionDescription,
      required this.server
     });

    Map<String,dynamic> toMapObject()=>
    {
     "regionName":regionName,
     "regionDescription":regionDescription,
     "server":server
    };

    Map<String,dynamic> toMapObjectWithKey() {
      var regionStore = toMapObject();
      regionStore["regionID"] = regionID;
      return regionStore;
    }

   

    String toJsonString() {
      return jsonEncode(toMapObject());
    }


    String toJsonStringWithKey() {
      var regionStore = toMapObject();
      regionStore["regionID"] = regionID;
      return jsonEncode(regionStore);
    }

   

}