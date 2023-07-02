import 'package:floor/floor.dart';
import 'package:planb/db/entity/unused/subcategory_master.dart';

@dao
abstract class SubCategoryMasterDao {
  @Query('SELECT * FROM SubCategoryMaster')
  Future<List<SubCategoryMaster>> findAllItems();

  @Query('SELECT * FROM SubCategoryMaster WHERE id = :id')
  Stream<SubCategoryMaster?> findItemById(int id);

  @insert
  Future<void> insertItem(SubCategoryMaster subCategoryMaster);

  //update by id

  //delete by id
}
