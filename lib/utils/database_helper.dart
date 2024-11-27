import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DataBaseHelper {
  static final DataBaseHelper _instance = DataBaseHelper._internal();
  factory DataBaseHelper() => _instance;

  static Database? _database;

  DataBaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicialização do banco de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'history.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Criação da tabela de histórico
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        qrCodeLink TEXT,
        timestamp TEXT
      )
    ''');
  }

  // Método para inserir o histórico
  Future<void> insertHistory(String qrCodeLink, String timestamp) async {
    final db = await database;
    await db.insert(
      'history',
      {'qrCodeLink': qrCodeLink, 'timestamp': timestamp},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para obter o histórico
  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'timestamp DESC');
  }
}
