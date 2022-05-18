
import 'package:yellowpatioapp/redux_state_store/appStore.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/date_preference_reducer.dart';

AppStore appReducer(AppStore state, action){
  return AppStore(state: const {'state':'changes from app state reducer'},
  dateViewPreference: datePreferenceReducer(state.dateViewPreference,action)
  );
}


enum reducer_actions {isInitilaizing, changesToState}