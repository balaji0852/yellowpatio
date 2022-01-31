// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:yellowpatioapp/db/repository/labelmaster_dao.dart';

import 'entity/item_master.dart';
import 'entity/label_master.dart';
import 'repository/itemmaster_dao.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [ItemMaster, Label])
abstract class AppDatabase extends FloorDatabase {
  ItemMasterDao get itemMasterDao;

  LabelMasterDao get labelMasterDao;
}
