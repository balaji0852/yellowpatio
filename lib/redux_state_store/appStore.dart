
//@immutable-add to wiki
import 'package:flutter/cupertino.dart';

//default value of a optional value should be const
//
@immutable
class AppStore {
  final state;
  final bool isLoading;
  final int dateViewPreference;
  //20/05/2022 - for managing the bottomnavigation bar state centrally, add below state item
  final int selectedIndex;
  final bool darkMode;
  final int projectStoreID;
  final int userStoreID;
  //Balaji: 16/05/2023 - adding this global gd flag
  final bool showDialog;

  AppStore({
    this.isLoading = false,
    this.state = const {'state':'initialized/by constructor'},
    this.dateViewPreference = 1,
    this.selectedIndex = 0,
    this.darkMode  = true,
    this.showDialog = false,
    this.projectStoreID = 999,
    this.userStoreID = 999
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



 



