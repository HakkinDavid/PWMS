import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Helper singleton de infraestructura para la conexión y gestión de SQLite.
class AppDatabase {
  static Database? _db;

  /// Retorna la instancia activa de [Database] inicializando las tablas si es necesario.
  static Future<Database> get instance async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  /// Inicializa la base de datos soportando Desktop (macOS/Windows/Linux) y Mobile (Android/iOS).
  static Future<Database> _initDatabase([String? inMemoryPath]) async {
    if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path;
    if (inMemoryPath != null) {
      path = inMemoryPath;
    } else if (kIsWeb) {
      path = inMemoryDatabasePath;
    } else {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final pwmsDir = Directory(join(documentsDirectory.path, 'pwms_data'));
      if (!await pwmsDir.exists()) {
        await pwmsDir.create(recursive: true);
      }
      path = join(pwmsDir.path, 'pwms_database.db');
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Crea las tablas base iniciales.
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entities (
        id TEXT PRIMARY KEY,
        template_id TEXT,
        parent_id TEXT,
        attributes_json TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE events (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  /// Método estático útil para pruebas unitarias e integración con DB en memoria.
  static Future<Database> createInMemory() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final db = await openDatabase(inMemoryDatabasePath, version: 1, onCreate: _onCreate);
    return db;
  }
}
