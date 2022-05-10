import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/user_store.dart';

@dao
abstract class UserStoreDao {
 
  @Query('SELECT * FROM UserStore WHERE id = :id')
  Stream<UserStore?> findItemById(int id);

  @insert
  Future<void> insertItem(UserStore userStore);
}