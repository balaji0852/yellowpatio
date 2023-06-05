import 'package:redux/redux.dart';
import 'package:yellowpatioapp/db/entity/class_data_instanceMaster.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';

final changeDemoDataInstance = combineReducers<ClassDataInstanceMaterDuplicate>([
  TypedReducer<ClassDataInstanceMaterDuplicate,DEMODataInstance>(_changeDataInstance)
]);


ClassDataInstanceMaterDuplicate _changeDataInstance(ClassDataInstanceMaterDuplicate state,DEMODataInstance action){
  return action.demoDataInstance;
}