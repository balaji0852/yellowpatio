

import 'package:redux/redux.dart';
import 'package:planb/redux_state_store/action/actions.dart';

final projectStoreReducer = combineReducers<int>([
  TypedReducer<int,ChangeProjectStoreID>(changeProjectStoreIDReducer)
]);



int changeProjectStoreIDReducer(int projectStoreID,ChangeProjectStoreID action){
  projectStoreID = action.projectStoreID;
  return projectStoreID;
}