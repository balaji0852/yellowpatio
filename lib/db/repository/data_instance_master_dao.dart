
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

  //skipping userStoreID, as we have itemMasterID
  Future<DataInstancesMaster?> findDataInstanceByLastComment(int itemMasterID);
  
  
  @Query('SELECT ClassMaster.itemClassColorID,DataInstancesMaster.dataInstanceID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime,DataInstancesMaster.instancesStatus  FROM DataInstancesMaster,ClassMaster WHERE DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID AND instancesTime <= ?2 AND instancesTime >= ?1 AND ClassMaster.itemMasterID = ?3')
  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByOneInterval(int dateTimeEpoch,int zeroDateTimeEpoch, int itemMasterID,int projectStoreID);
  

  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByOneIntervalV1(int dateTimeEpoch,int zeroDateTimeEpoch, int itemMasterID,int statusType,int projectStoreID);


  @Query('SELECT ClassMaster.itemClassColorID,DataInstancesMaster.dataInstanceID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime,DataInstancesMaster.instancesStatus  FROM DataInstancesMaster,ClassMaster WHERE DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID AND instancesTime <= ?2 AND instancesTime >= ?1')
  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByIntervalWithClassMaster(int dateTimeEpoch,int zeroDateTimeEpoch,int projectStoreID);

 
  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByIntervalWithClassMasterV1(int dateTimeEpoch,int zeroDateTimeEpoch,int statusType,int projectStoreID);

  @insert
  Future<void> insertDataInstance(DataInstancesMaster dataInstancesMaster);

  @update
  Future<void> updateDataInstanceByEntity(DataInstancesMaster dataInstancesMaster);

  @delete
  Future<void> deleteDataInstanceById(DataInstancesMaster dataInstancesMaster);
}