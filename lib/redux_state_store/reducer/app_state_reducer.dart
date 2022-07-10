
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';
import 'package:yellowpatioapp/redux_state_store/appStore.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/date_preference_reducer.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/main_widget_scroller_index.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/projectStoreReducer.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/selected_index_reducer.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/userStoreReducer.dart';

AppStore appReducer(AppStore state, action){
  return AppStore(state: const {'state':'changes from app state reducer'},
  dateViewPreference: datePreferenceReducer(state.dateViewPreference,action),
  selectedIndex: selectedIndexReducer(state.selectedIndex,action),
  projectStoreID: projectStoreReducer(state.projectStoreID,action),
  userStoreID: userStoreReducer(state.userStoreID,action),
  mainWidgetScrollControllerIndex: mainWidgetScrolleInexReducer(state.mainWidgetScrollControllerIndex,action)
  );
}


//enum reducer_actions {isInitilaizing, changesToState}