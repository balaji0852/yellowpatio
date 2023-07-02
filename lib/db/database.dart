
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:planb/db/entity/RegionStore.dart';
import 'package:planb/db/entity/ServicePlanStore.dart';
import 'package:planb/db/entity/class_master.dart';
import 'package:planb/db/entity/data_instances_master.dart';
import 'package:planb/db/entity/user_store.dart';
import 'package:planb/db/entity/project_store.dart';
// import 'package:planb/db/entity/user_store.dart';
import 'package:planb/db/repository/class_master_dao.dart';
import 'package:planb/db/repository/data_instance_master_dao.dart';
import 'package:planb/db/repository/project_store_dao.dart';
import 'package:planb/db/repository/unused/user_store_dao.dart';
import 'entity/class_data_instanceMaster.dart';


part 'database.g.dart';

@Database(version: 1, entities: [ ClassMaster,DataInstancesMaster,UserStore,projectStore])
abstract class AppDatabase extends FloorDatabase {                                    

  ClassMasterDao get classMasterDao;

  DataInstanceMasterDao get dataInstanceMasterDao;

  UserStoreDao get userStoreDao;

  ProjectStoreDao get projectStoreDao;

}
