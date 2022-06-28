
class ClassDataInstanceMaterDuplicate{
  final int? dataInstanceID;

  final int itemMasterID;

  final String dataInstances;

  final int instancesTime;

  final int itemClassColorID;
  
  final int instancesStatus;

  final int userStoreID;


  ClassDataInstanceMaterDuplicate(
      {this.dataInstanceID,
      required this.itemMasterID, 
      required this.dataInstances,
      required this.instancesTime,
      required this.itemClassColorID,
      required this.instancesStatus,
      required this.userStoreID
     });
}