// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ClassMasterDao? _classMasterDaoInstance;

  DataInstanceMasterDao? _dataInstanceMasterDaoInstance;

  UserStoreDao? _userStoreDaoInstance;

  ProjectStoreDao? _projectStoreDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        //  await database.execute('DROP TABLE IF EXISTS  `UserStore`');
        //           await database.execute('DROP TABLE IF EXISTS `projectStore`');
        //  await database.execute('DROP TABLE IF EXISTS `ClassMaster`');
        //  await database.execute('DROP TABLE IF EXISTS `DataInstancesMaster`');

     
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserStore` (`userStoreID` INTEGER PRIMARY KEY AUTOINCREMENT, `linkedEmail` TEXT NOT NULL, `linkedPhone` TEXT, `projectStoreID` INTEGER, `dateViewPreference` INTEGER, `timeViewPreference` INTEGER, `themeID` INTEGER, `userName` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `projectStore` (`projectStoreID` INTEGER PRIMARY KEY AUTOINCREMENT, `projectName` TEXT NOT NULL, `projectDescription` TEXT NOT NULL, `deactivateProject` INTEGER, `userStoreID` INTEGER NOT NULL, FOREIGN KEY (`userStoreID`) REFERENCES `UserStore` (`userStoreID`) ON UPDATE CASCADE ON DELETE CASCADE)');
            await database.execute(
            'CREATE TABLE IF NOT EXISTS `ClassMaster` (`itemMasterID` INTEGER PRIMARY KEY AUTOINCREMENT, `itemName` TEXT NOT NULL, `categoryID` INTEGER NOT NULL, `subCategoryID` INTEGER NOT NULL, `itemClassColorID` INTEGER NOT NULL, `itemPriority` INTEGER NOT NULL, `isItemCommentable` INTEGER NOT NULL, `description` TEXT NOT NULL, `projectStoreID` INTEGER NOT NULL, FOREIGN KEY (`projectStoreID`) REFERENCES `projectStore` (`projectStoreID`) ON UPDATE CASCADE ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DataInstancesMaster` (`dataInstanceID` INTEGER PRIMARY KEY AUTOINCREMENT, `itemMasterID` INTEGER NOT NULL, `dataInstances` TEXT NOT NULL, `instancesTime` INTEGER NOT NULL, `instancesStatus` INTEGER NOT NULL, FOREIGN KEY (`itemMasterID`) REFERENCES `ClassMaster` (`itemMasterID`) ON UPDATE CASCADE ON DELETE CASCADE)');
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ClassMaster` (`itemMasterID` INTEGER PRIMARY KEY AUTOINCREMENT, `itemName` TEXT NOT NULL, `categoryID` INTEGER NOT NULL, `subCategoryID` INTEGER NOT NULL, `itemClassColorID` INTEGER NOT NULL, `itemPriority` INTEGER NOT NULL, `isItemCommentable` INTEGER NOT NULL, `description` TEXT NOT NULL, `projectStoreID` INTEGER NOT NULL, FOREIGN KEY (`projectStoreID`) REFERENCES `projectStore` (`projectStoreID`) ON UPDATE CASCADE ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DataInstancesMaster` (`dataInstanceID` INTEGER PRIMARY KEY AUTOINCREMENT, `itemMasterID` INTEGER NOT NULL, `dataInstances` TEXT NOT NULL, `instancesTime` INTEGER NOT NULL, `instancesStatus` INTEGER NOT NULL, FOREIGN KEY (`itemMasterID`) REFERENCES `ClassMaster` (`itemMasterID`) ON UPDATE CASCADE ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserStore` (`userStoreID` INTEGER PRIMARY KEY AUTOINCREMENT, `linkedEmail` TEXT NOT NULL, `linkedPhone` TEXT, `projectStoreID` INTEGER, `dateViewPreference` INTEGER, `timeViewPreference` INTEGER, `themeID` INTEGER, `userName` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `projectStore` (`projectStoreID` INTEGER PRIMARY KEY AUTOINCREMENT, `projectName` TEXT NOT NULL, `projectDescription` TEXT NOT NULL, `deactivateProject` INTEGER, `userStoreID` INTEGER NOT NULL, FOREIGN KEY (`userStoreID`) REFERENCES `UserStore` (`userStoreID`) ON UPDATE CASCADE ON DELETE CASCADE)');
        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ClassMasterDao get classMasterDao {
    return _classMasterDaoInstance ??=
        _$ClassMasterDao(database, changeListener);
  }

  @override
  DataInstanceMasterDao get dataInstanceMasterDao {
    return _dataInstanceMasterDaoInstance ??=
        _$DataInstanceMasterDao(database, changeListener);
  }

  @override
  UserStoreDao get userStoreDao {
    return _userStoreDaoInstance ??= _$UserStoreDao(database, changeListener);
  }

  @override
  ProjectStoreDao get projectStoreDao {
    return _projectStoreDaoInstance ??=
        _$ProjectStoreDao(database, changeListener);
  }
}

class _$ClassMasterDao extends ClassMasterDao {
  _$ClassMasterDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _classMasterInsertionAdapter = InsertionAdapter(
            database,
            'ClassMaster',
            (ClassMaster item) => <String, Object?>{
                  'itemMasterID': item.itemMasterID,
                  'itemName': item.itemName,
                  'categoryID': item.categoryID,
                  'subCategoryID': item.subCategoryID,
                  'itemClassColorID': item.itemClassColorID,
                  'itemPriority': item.itemPriority,
                  'isItemCommentable': item.isItemCommentable,
                  'description': item.description,
                  'projectStoreID': item.projectStoreID
                }),
        _classMasterUpdateAdapter = UpdateAdapter(
            database,
            'ClassMaster',
            ['itemMasterID'],
            (ClassMaster item) => <String, Object?>{
                  'itemMasterID': item.itemMasterID,
                  'itemName': item.itemName,
                  'categoryID': item.categoryID,
                  'subCategoryID': item.subCategoryID,
                  'itemClassColorID': item.itemClassColorID,
                  'itemPriority': item.itemPriority,
                  'isItemCommentable': item.isItemCommentable,
                  'description': item.description,
                  'projectStoreID': item.projectStoreID
                }),
        _classMasterDeletionAdapter = DeletionAdapter(
            database,
            'ClassMaster',
            ['itemMasterID'],
            (ClassMaster item) => <String, Object?>{
                  'itemMasterID': item.itemMasterID,
                  'itemName': item.itemName,
                  'categoryID': item.categoryID,
                  'subCategoryID': item.subCategoryID,
                  'itemClassColorID': item.itemClassColorID,
                  'itemPriority': item.itemPriority,
                  'isItemCommentable': item.isItemCommentable,
                  'description': item.description,
                  'projectStoreID': item.projectStoreID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ClassMaster> _classMasterInsertionAdapter;

  final UpdateAdapter<ClassMaster> _classMasterUpdateAdapter;

  final DeletionAdapter<ClassMaster> _classMasterDeletionAdapter;

  @override
  Future<List<ClassMaster>> findAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM ClassMaster',
        mapper: (Map<String, Object?> row) => ClassMaster(
            itemMasterID: row['itemMasterID'] as int?,
            itemName: row['itemName'] as String,
            categoryID: row['categoryID'] as int,
            subCategoryID: row['subCategoryID'] as int,
            itemClassColorID: row['itemClassColorID'] as int,
            itemPriority: row['itemPriority'] as int,
            isItemCommentable: row['isItemCommentable'] as int,
            description: row['description'] as String,
            projectStoreID: row['projectStoreID'] as int));
  }

  @override
  Future<List<ClassMaster>?> findItemById(int projectStoreID) async {
    return _queryAdapter.queryList('SELECT * FROM ClassMaster WHERE projectStoreID = ?1',
        mapper: (Map<String, Object?> row) => ClassMaster(
            itemMasterID: row['itemMasterID'] as int?,
            itemName: row['itemName'] as String,
            categoryID: row['categoryID'] as int,
            subCategoryID: row['subCategoryID'] as int,
            itemClassColorID: row['itemClassColorID'] as int,
            itemPriority: row['itemPriority'] as int,
            isItemCommentable: row['isItemCommentable'] as int,
            description: row['description'] as String,
            projectStoreID: row['projectStoreID'] as int),
        arguments: [projectStoreID]);
  }

  @override
  Future<void> insertItem(ClassMaster classMaster) async {
    await _classMasterInsertionAdapter.insert(
        classMaster, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItemByEntity(ClassMaster classMaster) async {
    await _classMasterUpdateAdapter.update(
        classMaster, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItemById(ClassMaster classMaster) async {
    await _classMasterDeletionAdapter.delete(classMaster);
  }
}

class _$DataInstanceMasterDao extends DataInstanceMasterDao {
  _$DataInstanceMasterDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _dataInstancesMasterInsertionAdapter = InsertionAdapter(
            database,
            'DataInstancesMaster',
            (DataInstancesMaster item) => <String, Object?>{
                  'dataInstanceID': item.dataInstanceID,
                  'itemMasterID': item.itemMasterID,
                  'dataInstances': item.dataInstances,
                  'instancesTime': item.instancesTime,
                  'instancesStatus': item.instancesStatus
                },
            changeListener),
        _dataInstancesMasterUpdateAdapter = UpdateAdapter(
            database,
            'DataInstancesMaster',
            ['dataInstanceID'],
            (DataInstancesMaster item) => <String, Object?>{
                  'dataInstanceID': item.dataInstanceID,
                  'itemMasterID': item.itemMasterID,
                  'dataInstances': item.dataInstances,
                  'instancesTime': item.instancesTime,
                  'instancesStatus': item.instancesStatus
                },
            changeListener),
        _dataInstancesMasterDeletionAdapter = DeletionAdapter(
            database,
            'DataInstancesMaster',
            ['dataInstanceID'],
            (DataInstancesMaster item) => <String, Object?>{
                  'dataInstanceID': item.dataInstanceID,
                  'itemMasterID': item.itemMasterID,
                  'dataInstances': item.dataInstances,
                  'instancesTime': item.instancesTime,
                  'instancesStatus': item.instancesStatus
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DataInstancesMaster>
      _dataInstancesMasterInsertionAdapter;

  final UpdateAdapter<DataInstancesMaster> _dataInstancesMasterUpdateAdapter;

  final DeletionAdapter<DataInstancesMaster>
      _dataInstancesMasterDeletionAdapter;

  @override
  Future<List<DataInstancesMaster>> findAllDataInstance() async {
    return _queryAdapter.queryList('SELECT * FROM DataInstancesMaster',
        mapper: (Map<String, Object?> row) => DataInstancesMaster(
            dataInstanceID: row['dataInstanceID'] as int?,
            itemMasterID: row['itemMasterID'] as int,
            dataInstances: row['dataInstances'] as String,
            instancesTime: row['instancesTime'] as int,
            instancesStatus: row['instancesStatus'] as int));
  }

  @override
  Stream<DataInstancesMaster?> findDataInstanceById(int dataInstanceID) {
    return _queryAdapter.queryStream(
        'SELECT * FROM DataInstancesMaster WHERE dataInstanceID = ?1',
        mapper: (Map<String, Object?> row) => DataInstancesMaster(
            dataInstanceID: row['dataInstanceID'] as int?,
            itemMasterID: row['itemMasterID'] as int,
            dataInstances: row['dataInstances'] as String,
            instancesTime: row['instancesTime'] as int,
            instancesStatus: row['instancesStatus'] as int),
        arguments: [dataInstanceID],
        queryableName: 'DataInstancesMaster',
        isView: false);
  }

  @override
  Future<void> insertDataInstance(
      DataInstancesMaster dataInstancesMaster) async {
    await _dataInstancesMasterInsertionAdapter.insert(
        dataInstancesMaster, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDataInstanceByEntity(
      DataInstancesMaster dataInstancesMaster) async {
    await _dataInstancesMasterUpdateAdapter.update(
        dataInstancesMaster, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDataInstanceById(
      DataInstancesMaster dataInstancesMaster) async {
    await _dataInstancesMasterDeletionAdapter.delete(dataInstancesMaster);
  }

   @override
  Future<DataInstancesMaster?> findDataInstanceByLastComment(
      int itemMasterID) async {
    return _queryAdapter.query(
        'SELECT * FROM DataInstancesMaster WHERE  itemMasterID= ?1 ORDER BY instancesTime DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => DataInstancesMaster(dataInstanceID: row['dataInstanceID'] as int?, itemMasterID: row['itemMasterID'] as int, dataInstances: row['dataInstances'] as String, instancesTime: row['instancesTime'] as int, instancesStatus: row['instancesStatus'] as int),
        arguments: [itemMasterID]);
  }

  @override
  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByOneInterval(
      int dateTimeEpoch,
      int zeroDateTimeEpoch,
      int itemMasterID,
      int projectStoreID) async {
    return _queryAdapter.queryList(
        'SELECT ClassMaster.itemClassColorID,DataInstancesMaster.dataInstanceID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime,DataInstancesMaster.instancesStatus  FROM DataInstancesMaster,ClassMaster WHERE DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID AND instancesTime <= ?2 AND instancesTime >= ?1 AND ClassMaster.itemMasterID = ?3',
        mapper: (Map<String, Object?> row) => ClassDataInstanceMaterDuplicate(dataInstanceID: row['dataInstanceID'] as int?, itemMasterID: row['itemMasterID'] as int, dataInstances: row['dataInstances'] as String, instancesTime: int.parse(row['instancesTime'].toString()), instancesStatus: int.parse(row['instancesStatus'].toString()), itemClassColorID: int.parse(row['itemClassColorID'].toString())),
        arguments: [
          dateTimeEpoch,
          zeroDateTimeEpoch,
          itemMasterID,
          projectStoreID
        ]);
  }

//WHERE instancesTime >= ?1 AND instancesTime <= ?2
//int dateTimeEpoch, int zeroDateTimeEpoch
// arguments: [dateTimeEpoch, zeroDateTimeEpoch]
//INNER JOIN ClassMaster ON DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID
//ClassMaster.itemClassColorID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime
  @override
  Future<List<ClassDataInstanceMaterDuplicate>?>
      findDataInstanceByIntervalWithClassMaster(
          int dateTimeEpoch, int zeroDateTimeEpoch, int projectStoreID) async {
    return _queryAdapter.queryList(
        'SELECT ClassMaster.itemClassColorID,DataInstancesMaster.dataInstanceID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime,DataInstancesMaster.instancesStatus  FROM DataInstancesMaster,ClassMaster WHERE DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID AND instancesTime <= ?2 AND instancesTime >= ?1 AND ClassMaster.projectStoreID = ?3',
        mapper: (Map<String, Object?> row) => ClassDataInstanceMaterDuplicate(dataInstances: row['dataInstances'].toString(), itemMasterID: int.parse(row['itemMasterID'].toString()), dataInstanceID: int.parse(row['dataInstanceID'].toString()), instancesStatus: int.parse(row['instancesStatus'].toString()), instancesTime: int.parse(row['instancesTime'].toString()), itemClassColorID: int.parse(row['itemClassColorID'].toString())),
        arguments: [dateTimeEpoch, zeroDateTimeEpoch, projectStoreID]);
  }

  @override
  Future<List<ClassDataInstanceMaterDuplicate>?>
      findDataInstanceByOneIntervalV1(int dateTimeEpoch, int zeroDateTimeEpoch,
          int itemMasterID, int statusType, int projectStoreID) async {
    return _queryAdapter.queryList(
        'SELECT ClassMaster.itemClassColorID,DataInstancesMaster.dataInstanceID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime,DataInstancesMaster.instancesStatus  FROM DataInstancesMaster,ClassMaster WHERE DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID AND instancesTime <= ?2 AND instancesTime >= ?1 AND ClassMaster.itemMasterID = ?3 AND DataInstancesMaster.instancesStatus = ?4 ',
        mapper: (Map<String, Object?> row) => ClassDataInstanceMaterDuplicate(dataInstanceID: row['dataInstanceID'] as int?, itemMasterID: row['itemMasterID'] as int, dataInstances: row['dataInstances'] as String, instancesTime: int.parse(row['instancesTime'].toString()), instancesStatus: int.parse(row['instancesStatus'].toString()), itemClassColorID: int.parse(row['itemClassColorID'].toString())),
        arguments: [
          dateTimeEpoch,
          zeroDateTimeEpoch,
          itemMasterID,
          statusType,
          projectStoreID
        ]);
  }

//WHERE instancesTime >= ?1 AND instancesTime <= ?2
//int dateTimeEpoch, int zeroDateTimeEpoch
// arguments: [dateTimeEpoch, zeroDateTimeEpoch]
//INNER JOIN ClassMaster ON DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID
//ClassMaster.itemClassColorID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime
  @override
  Future<List<ClassDataInstanceMaterDuplicate>?>
      findDataInstanceByIntervalWithClassMasterV1(int dateTimeEpoch,
          int zeroDateTimeEpoch, int statusType, int projectStoreID) async {
    return _queryAdapter.queryList(
        'SELECT ClassMaster.itemClassColorID,DataInstancesMaster.dataInstanceID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime,DataInstancesMaster.instancesStatus FROM DataInstancesMaster,ClassMaster WHERE DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID AND instancesTime <= ?2 AND instancesTime >= ?1 AND DataInstancesMaster.instancesStatus = ?3 AND ClassMaster.projectStoreID = ?4',
        mapper: (Map<String, Object?> row) => ClassDataInstanceMaterDuplicate(dataInstances: row['dataInstances'].toString(), itemMasterID: int.parse(row['itemMasterID'].toString()), dataInstanceID: int.parse(row['dataInstanceID'].toString()), instancesStatus: int.parse(row['instancesStatus'].toString()), instancesTime: int.parse(row['instancesTime'].toString()), itemClassColorID: int.parse(row['itemClassColorID'].toString())),
        arguments: [dateTimeEpoch, zeroDateTimeEpoch, statusType, projectStoreID]);
  }

  @override
  Stream<ClassDataInstanceMaterDuplicate?> findLastDataInstanceByClassMasterID(
      int itemMasterID) {
    return _queryAdapter.queryStream(
        'SELECT * FROM DataInstancesMaster WHERE itemMasterID= ?1',
        mapper: (Map<String, Object?> row) => ClassDataInstanceMaterDuplicate(
            dataInstances: row['dataInstances'].toString(),
            itemMasterID: int.parse(row['itemMasterID'].toString()),
            dataInstanceID: int.parse(row['dataInstanceID'].toString()),
            instancesStatus: int.parse(row['instancesStatus'].toString()),
            instancesTime: int.parse(row['instancesTime'].toString()),
            itemClassColorID: 1
            ),
        arguments: [itemMasterID],
        queryableName: 'DataInstancesMaster',
        isView: false);
  }
}

class _$UserStoreDao extends UserStoreDao {
  _$UserStoreDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _userStoreInsertionAdapter = InsertionAdapter(
            database,
            'UserStore',
            (UserStore item) => <String, Object?>{
                  'userStoreID': item.userStoreID,
                  'linkedEmail': item.linkedEmail,
                  'linkedPhone': item.linkedPhone,
                  'projectStoreID': item.projectStoreID,
                  'dateViewPreference': item.dateViewPreference,
                  'timeViewPreference': item.timeViewPreference,
                  'themeID': item.themeID,
                  'userName': item.userName
                },
            changeListener),
        _userStoreUpdateAdapter = UpdateAdapter(
            database,
            'UserStore',
            ['userStoreID'],
            (UserStore item) => <String, Object?>{
                  'userStoreID': item.userStoreID,
                  'linkedEmail': item.linkedEmail,
                  'linkedPhone': item.linkedPhone,
                  'projectStoreID': item.projectStoreID,
                  'dateViewPreference': item.dateViewPreference,
                  'timeViewPreference': item.timeViewPreference,
                  'themeID': item.themeID,
                  'userName': item.userName
                },
            changeListener),
        _userStoreDeletionAdapter = DeletionAdapter(
            database,
            'UserStore',
            ['userStoreID'],
            (UserStore item) => <String, Object?>{
                  'userStoreID': item.userStoreID,
                  'linkedEmail': item.linkedEmail,
                  'linkedPhone': item.linkedPhone,
                  'projectStoreID': item.projectStoreID,
                  'dateViewPreference': item.dateViewPreference,
                  'timeViewPreference': item.timeViewPreference,
                  'themeID': item.themeID,
                  'userName': item.userName
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserStore> _userStoreInsertionAdapter;

  final UpdateAdapter<UserStore> _userStoreUpdateAdapter;

  final DeletionAdapter<UserStore> _userStoreDeletionAdapter;

  @override
  Future<List<UserStore>> findAllUser() async {
    return _queryAdapter.queryList('SELECT * FROM UserStore',
        mapper: (Map<String, Object?> row) => UserStore(
            linkedEmail: row['linkedEmail'] as String,
            userName: row['userName'] as String,
            userStoreID: row['userStoreID'] as int?,
            linkedPhone: row['linkedPhone'] as String?,
            projectStoreID: row['projectStoreID'] as int?,
            dateViewPreference: row['dateViewPreference'] as int?,
            timeViewPreference: row['timeViewPreference'] as int?,
            themeID: row['themeID'] as int?));
  }

  @override
  Stream<UserStore?> findUserById(int userStoreID) {
    return _queryAdapter.queryStream(
        'SELECT * FROM UserStore WHERE userStoreID = ?1',
        mapper: (Map<String, Object?> row) => UserStore(
            linkedEmail: row['linkedEmail'] as String,
            userName: row['userName'] as String,
            userStoreID: row['userStoreID'] as int?,
            linkedPhone: row['linkedPhone'] as String?,
            projectStoreID: row['projectStoreID'] as int?,
            dateViewPreference: row['dateViewPreference'] as int?,
            timeViewPreference: row['timeViewPreference'] as int?,
            themeID: row['themeID'] as int?),
        arguments: [userStoreID],
        queryableName: 'UserStore',
        isView: false);
  }

  @override
  Future<List<UserStore>?> findUserByEmail(String email) async {
    return _queryAdapter.queryList(
        'SELECT * FROM UserStore WHERE linkedEmail = ?1',
        mapper: (Map<String, Object?> row) => UserStore(
            linkedEmail: row['linkedEmail'] as String,
            userName: row['userName'] as String,
            userStoreID: row['userStoreID'] as int?,
            linkedPhone: row['linkedPhone'] as String?,
            projectStoreID: row['projectStoreID'] as int?,
            dateViewPreference: row['dateViewPreference'] as int?,
            timeViewPreference: row['timeViewPreference'] as int?,
            themeID: row['themeID'] as int?),
        arguments: [email]);
  }

  @override
  Future<List<UserStore>?> findUserByPhone(String phone) async {
    return _queryAdapter.queryList(
        'SELECT * FROM UserStore WHERE linkedPhone = ?1',
        mapper: (Map<String, Object?> row) => UserStore(
            linkedEmail: row['linkedEmail'] as String,
            userName: row['userName'] as String,
            userStoreID: row['userStoreID'] as int?,
            linkedPhone: row['linkedPhone'] as String?,
            projectStoreID: row['projectStoreID'] as int?,
            dateViewPreference: row['dateViewPreference'] as int?,
            timeViewPreference: row['timeViewPreference'] as int?,
            themeID: row['themeID'] as int?),
        arguments: [phone]);
  }

  @override
  Future<void> insertUser(UserStore userStore) async {
    await _userStoreInsertionAdapter.insert(
        userStore, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUserByEntity(UserStore userStore) async {
    await _userStoreUpdateAdapter.update(userStore, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(UserStore userStore) async {
    await _userStoreDeletionAdapter.delete(userStore);
  }
}

class _$ProjectStoreDao extends ProjectStoreDao {
  _$ProjectStoreDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _projectStoreInsertionAdapter = InsertionAdapter(
            database,
            'projectStore',
            (projectStore item) => <String, Object?>{
                  'projectStoreID': item.projectStoreID,
                  'projectName': item.projectName,
                  'projectDescription': item.projectDescription,
                  'deactivateProject': item.deactivateProject == null
                      ? null
                      : (item.deactivateProject! ? 1 : 0),
                  'userStoreID': item.userStoreID
                }),
        _projectStoreUpdateAdapter = UpdateAdapter(
            database,
            'projectStore',
            ['projectStoreID'],
            (projectStore item) => <String, Object?>{
                  'projectStoreID': item.projectStoreID,
                  'projectName': item.projectName,
                  'projectDescription': item.projectDescription,
                  'deactivateProject': item.deactivateProject == null
                      ? null
                      : (item.deactivateProject! ? 1 : 0),
                  'userStoreID': item.userStoreID
                }),
        _projectStoreDeletionAdapter = DeletionAdapter(
            database,
            'projectStore',
            ['projectStoreID'],
            (projectStore item) => <String, Object?>{
                  'projectStoreID': item.projectStoreID,
                  'projectName': item.projectName,
                  'projectDescription': item.projectDescription,
                  'deactivateProject': item.deactivateProject == null
                      ? null
                      : (item.deactivateProject! ? 1 : 0),
                  'userStoreID': item.userStoreID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<projectStore> _projectStoreInsertionAdapter;

  final UpdateAdapter<projectStore> _projectStoreUpdateAdapter;

  final DeletionAdapter<projectStore> _projectStoreDeletionAdapter;

  @override
  Future<List<projectStore>> findAllProject() async {
    return _queryAdapter.queryList('SELECT * FROM projectStore',
        mapper: (Map<String, Object?> row) => projectStore(
            projectStoreID: row['projectStoreID'] as int?,
            projectName: row['projectName'] as String,
            projectDescription: row['projectDescription'] as String,
            userStoreID: row['userStoreID'] as int,
            deactivateProject: row['deactivateProject'] == null
                ? null
                : (row['deactivateProject'] as int) != 0));
  }

   @override
  Future<List<projectStore>> findAllProjectByUserStoreID(int userStoreID) async {
    return _queryAdapter.queryList('SELECT * FROM projectStore WHERE userStoreID = ?1',
        mapper: (Map<String, Object?> row) => projectStore(
            projectStoreID: row['projectStoreID'] as int?,
            projectName: row['projectName'] as String,
            projectDescription: row['projectDescription'] as String,
            userStoreID: row['userStoreID'] as int,
            deactivateProject: row['deactivateProject'] == null
                ? null
                : (row['deactivateProject'] as int) != 0),
                arguments: [userStoreID]);
  }

  @override
  Future<void> insertProject(projectStore projectStore) async {
    await _projectStoreInsertionAdapter.insert(
        projectStore, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProjectByEntity(projectStore projectStore) async {
    await _projectStoreUpdateAdapter.update(
        projectStore, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteProject(projectStore projectStore) async {
    await _projectStoreDeletionAdapter.delete(projectStore);
  }
}
