class ClassDataInstanceMater{
    final int? itemMasterID;

  late final String itemName;

  final int categoryID;

  final int subCategoryID;

  final int itemClassColorID;

  final int itemPriority;

  final int isItemCommentable;

  final String description;

  final int? dataInstanceID;

  //final int itemMasterID;

  final String dataInstances;

  final int instancesTime;


  ClassDataInstanceMater({
    this.itemMasterID,
    required this.itemName,
    required this.categoryID,
    required this.subCategoryID,
    required this.itemClassColorID,
    required this.itemPriority,
    required this.isItemCommentable,
    required this.description,
    this.dataInstanceID,
    required this.dataInstances,
    required this.instancesTime
  });
}



class ClassDataInstanceMaterDuplicate{
  final int? dataInstanceID;

  final int itemMasterID;

  final String dataInstances;

  final int instancesTime;

  final int itemClassColorID;


  ClassDataInstanceMaterDuplicate(
      {this.dataInstanceID,
      required this.itemMasterID, 
      required this.dataInstances,
      required this.instancesTime,
      required this.itemClassColorID
     });
}