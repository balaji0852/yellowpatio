import 'dart:async';

class ReSyncher{


  final int interval;

  ReSyncher({required this.interval});

  void serverConnector(Function() callBack,bool viewMounted){


  Timer.periodic(
    Duration(minutes: interval),
    (timer)async{ 
      if(!viewMounted)
      {
        timer.cancel();
      }else{
        await callBack();
      }
    });
  
  }
}