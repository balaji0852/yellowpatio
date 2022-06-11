
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';
import 'package:yellowpatioapp/redux_state_store/appStore.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/date_preference_reducer.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/main_widget_scroller_index.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/selected_index_reducer.dart';

AppStore appReducer(AppStore state, action){
  return AppStore(state: const {'state':'changes from app state reducer'},
  dateViewPreference: datePreferenceReducer(state.dateViewPreference,action),
  selectedIndex: selectedIndexReducer(state.selectedIndex,action),
  mainWidgetScrollControllerIndex: mainWidgetScrolleInexReducer(state.mainWidgetScrollControllerIndex,action)
  );
}


//enum reducer_actions {isInitilaizing, changesToState}