// lib/src/core/database/db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/user_model.dart';

class DbHelper {
  static const String _dbName = 'sr_tesis.db';
  static const int _dbVersion = 1;
  static const String tableUser = 'current_user';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUser (
        username TEXT PRIMARY KEY,
        token TEXT,
        role TEXT,
        email TEXT
      )
    ''');
  }

  /// Guardar el usuario cuando el login es exitoso
  Future<void> saveUser(UserModel user) async {
    final db = await database;
    await db.insert(tableUser, {
      'username': user.username,
      'token': user.token,
      'role': user.role,
      'email': user.email,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Obtener el usuario guardado al abrir la APK
  Future<UserModel?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableUser);

    if (maps.isEmpty) return null;

    return UserModel(
      token: maps.first['token'] as String,
      role: maps.first['role'] as String,
      username: maps.first['username'] as String,
      email: maps.first['email'] as String,
    );
  }

  /// Borrar los datos locales al cerrar sesión
  Future<void> deleteUser() async {
    final db = await database;
    await db.delete(tableUser);
  }
}
