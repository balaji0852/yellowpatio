import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/user_store.dart';
//B-HAVING OPTIONAL VALUES IN CONSTRUCTOR , Customer(this.name, [this.age, this.location]);,using square bracket
//b-redirecting constructor in dart- Customer.empty() : this("", 0, ""); and initializing it is using var customer1 = Customer.empty();, we need : for this operation
//
@dao
abstract class UserStoreDao {
  //when a google siginin happens, create user in userstore-if acc doesn't exist
  //query with userStoreID in classMaster and dataInstanceMaster, this is the system...




  @Query('SELECT * FROM UserStore')
  Future<List<UserStore>> findAllUser();

  @Query('SELECT * FROM UserStore WHERE userStoreID = :userStoreID')
  Stream<UserStore?> findUserById(int userStoreID);

  @Query('SELECT * FROM UserStore WHERE linkedEmail = :email')
  Future<List<UserStore>?> findUserByEmail(String email); 
  
  @Query('SELECT * FROM UserStore WHERE linkedPhone = :phone')
  Future<List<UserStore>?> findUserByPhone(String phone);
  

  //we might need a query with projectStoreID too...

  @insert
  Future<void> insertUser(UserStore userStore);

  //update by id
  @update
  Future<void> updateUserByEntity(UserStore userStore);

  //delete by id
  @delete
  //@Query('DELETE FROM ClassMaster WHERE id = :id')
  Future<void> deleteUser(UserStore userStore);
}