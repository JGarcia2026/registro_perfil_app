import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// DBHelper manages SQLite database creation and queries
class DBHelper {
  static final DBHelper instance = DBHelper._internal();
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, 'usuarios.db');

    // ignore: avoid_print
    print('📁 DB Path: $fullPath');

    return await openDatabase(
      fullPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            email TEXT NOT NULL,
            telefono TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // ✅ Insertar usuario
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('usuarios', user);
  }

  // ✅ Obtener último usuario
  Future<Map<String, dynamic>?> getLastUser() async {
    final db = await database;
    final result = await db.query(
      'usuarios',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) return result.first;
    return null;
  }

  // ✅ Obtener lista de usuarios
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('usuarios', orderBy: 'id DESC');
  }
}