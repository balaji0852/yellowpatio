import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/item_master.dart';

@dao
abstract class ItemMasterDao {
  @Query('SELECT * FROM ItemMaster')
  Future<List<ItemMaster>> findAllItems();

  @Query('SELECT * FROM ItemMaster WHERE id = :id')
  Stream<ItemMaster?> findItemById(int id);

  @insert
  Future<void> insertItem(ItemMaster item);
}
