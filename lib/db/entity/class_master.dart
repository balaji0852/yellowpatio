import 'package:floor/floor.dart';

@Entity(tableName: "ClassMaster")
class ClassMaster{
  
  @PrimaryKey(autoGenerate: true)
  final int? itemMasterID;

  late final String itemName;

  final int categoryID;

  final int subCategoryID;

  final int itemClassColorID;

  final int itemPriority;

  final int isItemCommentable;

  final String description;

  ClassMaster({
    this.itemMasterID,
    required this.itemName,
    required this.categoryID,
    required this.subCategoryID,
    required this.itemClassColorID,
    required this.itemPriority,
    required this.isItemCommentable,
    required this.description
  });
 
}