import 'package:redux/redux.dart';
import 'package:planb/redux_state_store/action/actions.dart';

final selectedIndexReducer = combineReducers<int>([
  TypedReducer<int,ChangeBottomNavigationView>(_ChangeBottomNavigationView)
]);


// by only returning the preference, nothing changes in the state, but by setting preference changes happens
int _ChangeBottomNavigationView(int selectedIndexTo,ChangeBottomNavigationView action){
   selectedIndexTo = action.selectedIndex;
  return selectedIndexTo;
}

