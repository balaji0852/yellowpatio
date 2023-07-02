

import 'package:redux/redux.dart';
import 'package:planb/redux_state_store/action/actions.dart';

final userStoreReducer = combineReducers<int>([
  TypedReducer<int,ChangeUserStoreID>(changeUserStoreIDReducer)
]);



int changeUserStoreIDReducer(int userStoreID,ChangeUserStoreID action){
  userStoreID = action.userStoreID;
  return userStoreID;
}