
//@immutable-add to wiki
import 'package:flutter/cupertino.dart';

//default value of a optional value should be const
//
@immutable
class AppStore {
  final state;
  final bool isLoading;
  final int dateViewPreference;

  AppStore({
    this.isLoading = false,
    this.state = const {'state':'initialized/by constructor'},
    this.dateViewPreference = 1
  });

  factory AppStore.loading() => AppStore(isLoading: true);


  // List<String> reducer(List<String> previousState){
  // // if(action == Actions.Add){
  // //   return new AppState(previousState.value +  1);
  // // }
  // // if(action == Actions.Subtract){
  // //   return new AppState(previousState.value -  1);
  // // }
  // return previousState;
  // }
  
}



 



