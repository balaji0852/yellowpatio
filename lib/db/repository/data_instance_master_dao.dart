
import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/class_data_instanceMaster.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';


//bnote->":" in query anotation needs to be close the variable
@dao
abstract class DataInstanceMasterDao{


   @Query('SELECT * FROM DataInstancesMaster')
  Future<List<DataInstancesMaster>> findAllDataInstance();

  @Query('SELECT * FROM DataInstancesMaster WHERE dataInstanceID = :dataInstanceID')
  Stream<DataInstancesMaster?> findDataInstanceById(int dataInstanceID);


 Future<List<DataInstancesMaster>?> findDataInstanceByLastComment(int itemMasterID);
  // @Query('SELECT * FROM DataInstancesMaster WHERE  instancesTime >= ?1 AND instancesTime <= ?2 ')
  // Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByInterval(int dateTimeEpoch,int zeroDateTimeEpoch);

  @Query('SELECT ClassMaster.itemClassColorID,DataInstancesMaster.dataInstanceID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime,DataInstancesMaster.instancesStatus  FROM DataInstancesMaster,ClassMaster WHERE DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID AND instancesTime <= ?2 AND instancesTime >= ?1 AND ClassMaster.itemMasterID = ?3')
  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByOneInterval(int dateTimeEpoch,int zeroDateTimeEpoch, int itemMasterID);
  
  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByOneIntervalV1(int dateTimeEpoch,int zeroDateTimeEpoch, int itemMasterID,int statusType);


  @Query('SELECT ClassMaster.itemClassColorID,DataInstancesMaster.dataInstanceID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime,DataInstancesMaster.instancesStatus  FROM DataInstancesMaster,ClassMaster WHERE DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID AND instancesTime <= ?2 AND instancesTime >= ?1')
  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByIntervalWithClassMaster(int dateTimeEpoch,int zeroDateTimeEpoch);

  // @Query('SELECT * FROM DataInstancesMaster INNER JOIN ClassMaster ON DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID ')
  // Future<List<ClassDataInstanceMater>?> findDataInstanceByIntervalWithClassMaster();
  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByIntervalWithClassMasterV1(int dateTimeEpoch,int zeroDateTimeEpoch,int statusType);


  @Query('SELECT * FROM DataInstancesMaster WHERE itemMasterID=:itemMasterID ORDER BY instancesTime DESC LIMIT')
  Stream<ClassDataInstanceMaterDuplicate?> findLastDataInstanceByClassMasterID(int itemMasterID);


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