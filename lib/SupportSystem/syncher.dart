import 'dart:async';

class ReSyncher{


  final int interval;

  bool mounted = true;

  ReSyncher({required this.interval});


  set isUIMounted(bool mounted)=> this.mounted=mounted;

  void serverConnector(Function() callBack,bool viewMounted){


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
  
  }
}