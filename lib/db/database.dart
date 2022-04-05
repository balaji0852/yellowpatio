// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:yellowpatioapp/db/entity/category_master.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/subcategory_master.dart';
import 'package:yellowpatioapp/db/repository/category_master_dao.dart';
import 'package:yellowpatioapp/db/repository/class_master_dao.dart';
import 'package:yellowpatioapp/db/repository/labelmaster_dao.dart';
import 'package:yellowpatioapp/db/repository/sub_category_dao.dart';

import 'entity/item_master.dart';
import 'entity/label_master.dart';
import 'repository/itemmaster_dao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [ItemMaster, Label,ClassMaster,CategoryMaster,SubCategoryMaster])
abstract class AppDatabase extends FloorDatabase {
  ItemMasterDao get itemMasterDao;

  LabelMasterDao get labelMasterDao;

  CategoryMasterDao get categoryMasterDao;

  ClassMasterDao get classMasterDao;

  SubCategoryMasterDao get subCategoryMasterDao;
}
