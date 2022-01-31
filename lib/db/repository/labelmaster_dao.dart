import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/label_master.dart';

@dao
abstract class LabelMasterDao {
  @Query('SELECT * FROM Label')
  Future<List<Label>> findAllLabel();

  @Query('SELECT * FROM Label WHERE labelId = :labelId')
  Stream<Label?> findLabelById(int labelId);

  @insert
  Future<void> insertLabel(Label label);
}
