import 'dart:async';
import 'dart:io';

import 'package:floor/floor.dart';

class ReSyncher{


  final int interval;

  bool mounted = true;

  ReSyncher({required this.interval});


  set isUIMounted(bool mounted)=> this.mounted=mounted;

  void serverConnector(Function() callBack,bool viewMounted){
          // Future.delayed(Duration(days: 0,seconds: 0,hours: 0,minutes: interval),callBack);


  Timer.periodic(
    Duration(days: 0,seconds: interval,hours: 0,minutes: 0),
    (timer){ 
      print(viewMounted);
      print('from the setter ui mounted? $mounted');
      if(!mounted){
        timer.cancel();
        print("stopping service");
      }
      print('syncher ${DateTime.now()}');
      if(mounted){
      callBack();

      }
    });
  //  bool block = true;
  //  while(viewMounted && block){
  //     //  block = false;
  //      print("q");
  //      sleep(Duration(days: 0,seconds: 0,hours: 0,minutes: interval));
  //     //  Future.delayed(,
  //     //  (){
  //     //    print("hi");
  //     //    block = true;
  //     //  });
  //  }
  }
}