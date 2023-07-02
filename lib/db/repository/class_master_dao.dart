import 'package:floor/floor.dart';
import 'package:planb/db/entity/class_master.dart';

@dao
abstract class ClassMasterDao {
  @Query('SELECT * FROM ClassMaster')
  Future<List<ClassMaster>> findAllItems();

  @Query('SELECT * FROM ClassMaster WHERE id = :id')
  Future<List<ClassMaster>?> findItemById(int projectStoreID);

  @insert
  Future<void> insertItem(ClassMaster classMaster);

  //update by id
  @update
  Future<void> updateItemByEntity(ClassMaster classMaster);

  //delete by id
  @delete
  //@Query('DELETE FROM ClassMaster WHERE id = :id')
  Future<void> deleteItemById(ClassMaster classMaster);
  
}
