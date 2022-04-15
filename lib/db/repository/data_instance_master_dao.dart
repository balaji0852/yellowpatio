import 'dart:ffi';

import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';


//":" in query anotation needs to be close the variable
@dao
abstract class DataInstanceMasterDao{


   @Query('SELECT * FROM DataInstancesMaster')
  Future<List<DataInstancesMaster>> findAllDataInstance();

  @Query('SELECT * FROM DataInstancesMaster WHERE dataInstanceID = :dataInstanceID')
  Stream<DataInstancesMaster?> findDataInstanceById(int dataInstanceID);

  @Query('SELECT * FROM DataInstancesMaster WHERE instancesTime <= :dateTimeEpoch AND instancesTime >= :zeroDateTimeEpoch AND itemMasterID = :itemMasterID')
  Future<List<DataInstancesMaster>?> findDataInstanceByOneInterval(int dateTimeEpoch,int zeroDateTimeEpoch, int itemMasterID);

  @insert
  Future<void> insertDataInstance(DataInstancesMaster dataInstancesMaster);

  //update by id
  @update
  Future<void> updateDataInstanceByEntity(DataInstancesMaster dataInstancesMaster);

  //delete by id
  @delete
  // @Query('DELETE FROM ClassMaster WHERE id = :id')
  Future<void> deleteDataInstanceById(DataInstancesMaster dataInstancesMaster);
}