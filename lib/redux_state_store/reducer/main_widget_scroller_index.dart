import 'package:redux/redux.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';

final mainWidgetScrolleInexReducer = combineReducers<bool>([
  TypedReducer<bool,ChangeMainWidgetScrollViewIndex>(_changeMainWidgetScrollViewIndex)
]);


// by only returning the preference, nothing changes in the state, but by setting preference changes happens
bool _changeMainWidgetScrollViewIndex(bool changedIndex,ChangeMainWidgetScrollViewIndex action){
   changedIndex = action.mainWidgetScrollViewIndex;
  return changedIndex;
}