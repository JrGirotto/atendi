import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('logs.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        photoPath TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertLog(String timestamp, String photoPath) async {
    final db = await instance.database;
    await db.insert('logs', {'timestamp': timestamp, 'photoPath': photoPath});
  }

  Future<List<Map<String, dynamic>>> getLogs() async {
    final db = await instance.database;
    return await db.query('logs');
  }
}
