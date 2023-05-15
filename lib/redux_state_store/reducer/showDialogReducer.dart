import 'package:redux/redux.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';

final showDialogReducer = combineReducers<bool>([
  TypedReducer<bool,ChangeShowDialogState>(_changeDialogReducer)
]);


bool _changeDialogReducer(bool showDialog,ChangeShowDialogState action){
  return action.showDialog;
}

