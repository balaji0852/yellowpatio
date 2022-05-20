
import 'package:redux/redux.dart';

import '../action/actions.dart';

final datePreferenceReducer = combineReducers<int>([
  TypedReducer<int,ChangeDateViewPreference>(_changeUserDateViewPreference)
]);


// by only returning the preference, nothing changes in the state, but by setting preference changes happens
int _changeUserDateViewPreference(int preference,ChangeDateViewPreference action){
  preference = action.userDateViewPreference;
  return preference;
}