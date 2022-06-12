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

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ItemMaster` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `itemText` TEXT NOT NULL, `itemDescription` TEXT NOT NULL, `createdDateTime` TEXT NOT NULL, `userLabel` TEXT NOT NULL, `userTopicID` TEXT NOT NULL, `synced` INTEGER NOT NULL, `dueDate` TEXT NOT NULL, `ypClassIDs` INTEGER, `ypTo` TEXT NOT NULL, FOREIGN KEY (`ypClassIDs`) REFERENCES `Label` (`labelId`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Label` (`labelId` INTEGER PRIMARY KEY AUTOINCREMENT, `labelName` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ClassMaster` (`itemMasterID` INTEGER PRIMARY KEY AUTOINCREMENT, `itemName` TEXT NOT NULL, `categoryID` INTEGER NOT NULL, `subCategoryID` INTEGER NOT NULL, `itemClassColorID` INTEGER NOT NULL, `itemPriority` INTEGER NOT NULL, `isItemCommentable` INTEGER NOT NULL, `description` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CategoryMaster` (`categoryID` INTEGER PRIMARY KEY AUTOINCREMENT, `categoryName` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SubCategoryMaster` (`subCategoryID` INTEGER PRIMARY KEY AUTOINCREMENT, `subCategoryName` TEXT NOT NULL, `parentCategoryID` INTEGER NOT NULL, FOREIGN KEY (`parentCategoryID`) REFERENCES `CategoryMaster` (`categoryID`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DataInstancesMaster` (`dataInstanceID` INTEGER PRIMARY KEY AUTOINCREMENT, `itemMasterID` INTEGER NOT NULL, `dataInstances` TEXT NOT NULL, `instancesTime` INTEGER NOT NULL, `instancesStatus` INTEGER NOT NULL, FOREIGN KEY (`itemMasterID`) REFERENCES `ClassMaster` (`itemMasterID`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

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
}

class _$ClassMasterDao extends ClassMasterDao {
  _$ClassMasterDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
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
                  'description': item.description
                },
            changeListener),
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
                  'description': item.description
                },
            changeListener),
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
                  'description': item.description
                },
            changeListener);

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
            description: row['description'] as String));
  }

  @override
  Stream<ClassMaster?> findItemById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM ClassMaster WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ClassMaster(
            itemMasterID: row['itemMasterID'] as int?,
            itemName: row['itemName'] as String,
            categoryID: row['categoryID'] as int,
            subCategoryID: row['subCategoryID'] as int,
            itemClassColorID: row['itemClassColorID'] as int,
            itemPriority: row['itemPriority'] as int,
            isItemCommentable: row['isItemCommentable'] as int,
            description: row['description'] as String),
        arguments: [id],
        queryableName: 'ClassMaster',
        isView: false);
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
  Future<List<ClassDataInstanceMaterDuplicate>?> findDataInstanceByOneInterval(
      int dateTimeEpoch, int zeroDateTimeEpoch, int itemMasterID) async {
    return _queryAdapter.queryList(
        'SELECT ClassMaster.itemClassColorID,DataInstancesMaster.dataInstanceID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime,DataInstancesMaster.instancesStatus  FROM DataInstancesMaster,ClassMaster WHERE DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID AND instancesTime <= ?2 AND instancesTime >= ?1 AND ClassMaster.itemMasterID = ?3',
        mapper: (Map<String, Object?> row) => ClassDataInstanceMaterDuplicate(dataInstanceID: row['dataInstanceID'] as int?, itemMasterID: row['itemMasterID'] as int, dataInstances: row['dataInstances'] as String, instancesTime: int.parse(row['instancesTime'].toString()), instancesStatus: int.parse(row['instancesStatus'].toString()), itemClassColorID: int.parse(row['itemClassColorID'].toString())),
        arguments: [dateTimeEpoch, zeroDateTimeEpoch, itemMasterID]);
  }

//WHERE instancesTime >= ?1 AND instancesTime <= ?2
//int dateTimeEpoch, int zeroDateTimeEpoch
// arguments: [dateTimeEpoch, zeroDateTimeEpoch]
//INNER JOIN ClassMaster ON DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID
//ClassMaster.itemClassColorID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime
  @override
  Future<List<ClassDataInstanceMaterDuplicate>?>
      findDataInstanceByIntervalWithClassMaster(
          int dateTimeEpoch, int zeroDateTimeEpoch) async {
    return _queryAdapter.queryList(
        'SELECT ClassMaster.itemClassColorID,DataInstancesMaster.dataInstanceID,DataInstancesMaster.itemMasterID,DataInstancesMaster.dataInstances,DataInstancesMaster.instancesTime,DataInstancesMaster.instancesStatus  FROM DataInstancesMaster,ClassMaster WHERE DataInstancesMaster.itemMasterID=ClassMaster.itemMasterID AND instancesTime <= ?2 AND instancesTime >= ?1',
        mapper: (Map<String, Object?> row) => ClassDataInstanceMaterDuplicate(dataInstances: row['dataInstances'].toString(), itemMasterID: int.parse(row['itemMasterID'].toString()), dataInstanceID: int.parse(row['dataInstanceID'].toString()), instancesStatus: int.parse(row['instancesStatus'].toString()), instancesTime: int.parse(row['instancesTime'].toString()), itemClassColorID: int.parse(row['itemClassColorID'].toString())),
        arguments: [dateTimeEpoch, zeroDateTimeEpoch]);
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
}
