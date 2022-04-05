import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/category_master.dart';

@dao
abstract class CategoryMasterDao {
  @Query('SELECT * FROM CategoryMaster')
  Future<List<CategoryMaster>> findAllItems();

  @Query('SELECT * FROM CategoryMaster WHERE id = :id')
  Stream<CategoryMaster?> findItemById(int id);

  @insert
  Future<void> insertItem(CategoryMaster categoryMaster);

  //update by id

  //delete by id
}
