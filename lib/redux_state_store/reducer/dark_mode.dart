import 'package:redux/redux.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';

final changeDarkModeReducer = combineReducers<bool>([
  TypedReducer<bool,ChangeDarkMode>(_changeDarkMode)
]);


// by only returning the preference, nothing changes in the state, but by setting preference changes happens
bool _changeDarkMode(bool changedMode,ChangeDarkMode action){
   //changedIndex = action.mainWidgetScrollViewIndex;
  return action.DarkMode;
}