import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/project_store.dart';

@dao
abstract class ProjectStoreDao {
  //when a google siginin happens, create user in userstore-if acc doesn't exist
  //query with userStoreID in classMaster and dataInstanceMaster, this is the system...


  Future<List<projectStore>> findAllProjectByUserStoreID(int userStoreID);

  @Query('SELECT * FROM projectStore')
  Future<List<projectStore>> findAllProject();

  @insert
  Future<void> insertProject(projectStore projectStore);

  @update
  Future<void> updateProjectByEntity(projectStore projectStore);

  @delete
  Future<void> deleteProject(projectStore projectStore);


  // @Query('SELECT * FROM projectStore WHERE projectStoreID = :projectStoreID')
  // Stream<projectStore?> findProjectById(int projectStoreID);

  // @Query('SELECT * FROM projectStore WHERE linkedEmail = :email')
  // Future<List<projectStore>?> findProjectByEmail(String email); 
  
  // @Query('SELECT * FROM UserStore WHERE linkedPhone = :phone')
  // Future<List<projectStore>?> findUserByPhone(String phone);
  

  //we might need a query with projectStoreID too...

}