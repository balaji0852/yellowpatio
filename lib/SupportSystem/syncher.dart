import 'dart:async';
import 'dart:io';

import 'package:floor/floor.dart';

class ReSyncher{


  final int interval;

  ReSyncher({required this.interval});

  void serverConnector(Callback callBack,bool viewMounted){
          // Future.delayed(Duration(days: 0,seconds: 0,hours: 0,minutes: interval),callBack);


  Timer.periodic(
    Duration(days: 0,seconds: 0,hours: 0,minutes: interval),
    (Timer){ 
      print("q");
      print(Timer);
      callBack;
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