import 'package:randomuser/models/schemas/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  static final UserDatabase _instance = UserDatabase._init();
  static UserDatabase get instance => _instance;

  static const String _databaseName = 'users.db';

  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(_databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $usersTable (
  ${UserFields.id} $idType,
  ${UserFields.username} $textType,
  ${UserFields.gender} $textType,
  ${UserFields.firstName} $textType,
  ${UserFields.lastName} $textType,
  ${UserFields.email} $textType,
  ${UserFields.phone} $textType,
  ${UserFields.registerDate} $textType,
  ${UserFields.city} $textType,
  ${UserFields.country} $textType,
  ${UserFields.dateOfBirth} $textType,
  ${UserFields.picture} $textType
  )
''');
  }

  Future close() async {
    final db = await _instance.database;

    db.close();
  }

  Future<User> create(User user) async {
    final db = await _instance.database;

    final id = await db.insert(usersTable, user.toJson());
    return user.copy(id: id);
  }

  Future<User> getUser(int id) async {
    final db = await _instance.database;

    final maps = await db.query(
      usersTable,
      columns: UserFields.values,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<User>> getAllUsers() async {
    final db = await _instance.database;

    // final orderBy = '${UserFields.name} ASC';
    // final result = await db.query(usersTable, orderBy: orderBy);
    final result = await db.query(usersTable);

    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<int> update(User user) async {
    final db = await _instance.database;

    return db.update(
      usersTable,
      user.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _instance.database;

    return await db.delete(
      usersTable,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final db = await _instance.database;

    return await db.delete(usersTable);
  }
}
