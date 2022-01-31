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

  ItemMasterDao? _itemMasterDaoInstance;

  LabelMasterDao? _labelMasterDaoInstance;

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

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ItemMasterDao get itemMasterDao {
    return _itemMasterDaoInstance ??= _$ItemMasterDao(database, changeListener);
  }

  @override
  LabelMasterDao get labelMasterDao {
    return _labelMasterDaoInstance ??=
        _$LabelMasterDao(database, changeListener);
  }
}

class _$ItemMasterDao extends ItemMasterDao {
  _$ItemMasterDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _itemMasterInsertionAdapter = InsertionAdapter(
            database,
            'ItemMaster',
            (ItemMaster item) => <String, Object?>{
                  'id': item.id,
                  'itemText': item.itemText,
                  'itemDescription': item.itemDescription,
                  'createdDateTime': item.createdDateTime,
                  'userLabel': item.userLabel,
                  'userTopicID': item.userTopicID,
                  'synced': item.synced ? 1 : 0,
                  'dueDate': item.dueDate,
                  'ypClassIDs': item.ypClassIDs,
                  'ypTo': item.ypTo
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ItemMaster> _itemMasterInsertionAdapter;

  @override
  Future<List<ItemMaster>> findAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM ItemMaster',
        mapper: (Map<String, Object?> row) => ItemMaster(
            id: row['id'] as int?,
            itemText: row['itemText'] as String,
            itemDescription: row['itemDescription'] as String,
            createdDateTime: row['createdDateTime'] as String,
            userLabel: row['userLabel'] as String,
            userTopicID: row['userTopicID'] as String,
            synced: (row['synced'] as int) != 0,
            dueDate: row['dueDate'] as String,
            ypClassIDs: row['ypClassIDs'] as int?,
            ypTo: row['ypTo'] as String));
  }

  @override
  Stream<ItemMaster?> findItemById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM ItemMaster WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ItemMaster(
            id: row['id'] as int?,
            itemText: row['itemText'] as String,
            itemDescription: row['itemDescription'] as String,
            createdDateTime: row['createdDateTime'] as String,
            userLabel: row['userLabel'] as String,
            userTopicID: row['userTopicID'] as String,
            synced: (row['synced'] as int) != 0,
            dueDate: row['dueDate'] as String,
            ypClassIDs: row['ypClassIDs'] as int?,
            ypTo: row['ypTo'] as String),
        arguments: [id],
        queryableName: 'ItemMaster',
        isView: false);
  }

  @override
  Future<void> insertItem(ItemMaster item) async {
    await _itemMasterInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }
}

class _$LabelMasterDao extends LabelMasterDao {
  _$LabelMasterDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _labelInsertionAdapter = InsertionAdapter(
            database,
            'Label',
            (Label item) => <String, Object?>{
                  'labelId': item.labelId,
                  'labelName': item.labelName
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Label> _labelInsertionAdapter;

  @override
  Future<List<Label>> findAllLabel() async {
    return _queryAdapter.queryList('SELECT * FROM Label',
        mapper: (Map<String, Object?> row) => Label(
            labelId: row['labelId'] as int?,
            labelName: row['labelName'] as String));
  }

  @override
  Stream<Label?> findLabelById(int labelId) {
    return _queryAdapter.queryStream('SELECT * FROM Label WHERE labelId = ?1',
        mapper: (Map<String, Object?> row) => Label(
            labelId: row['labelId'] as int?,
            labelName: row['labelName'] as String),
        arguments: [labelId],
        queryableName: 'Label',
        isView: false);
  }

  @override
  Future<void> insertLabel(Label label) async {
    await _labelInsertionAdapter.insert(label, OnConflictStrategy.abort);
  }
}
