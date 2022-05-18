
import 'package:redux/redux.dart';

import '../action/actions.dart';

final datePreferenceReducer = combineReducers<int>([
  TypedReducer<int,ChangeDateViewPreference>(_changeUserDateViewPreference)
]);



int _changeUserDateViewPreference(int preference,ChangeDateViewPreference action){
  preference = action.userDateViewPreference;
  return preference;
}