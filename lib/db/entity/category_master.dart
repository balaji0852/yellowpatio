import 'package:floor/floor.dart';

@Entity(tableName: "CategoryMaster")
class CategoryMaster{

  @PrimaryKey(autoGenerate: true)
  final int? categoryID;

  final String categoryName;

  CategoryMaster({
    this.categoryID,
    required this.categoryName
  });

}