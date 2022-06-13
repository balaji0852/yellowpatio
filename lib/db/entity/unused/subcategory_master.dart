import 'package:floor/floor.dart';

import 'category_master.dart';

@Entity(
  tableName: 'SubCategoryMaster',
  foreignKeys: [
    ForeignKey(
      childColumns: ['parentCategoryID'],
      parentColumns: ['categoryID'],
      entity: CategoryMaster,
    )
  ],
)
class SubCategoryMaster{

  @PrimaryKey(autoGenerate: true)
  final int? subCategoryID;

  final String subCategoryName;

  final int parentCategoryID;

  SubCategoryMaster({
    this.subCategoryID,
    required this.subCategoryName,
    required this.parentCategoryID
  });

}