import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

Future<Map<String, dynamic>> getStats() async {
  Database db = await instance.database;
  
  // Contar cuántos son de 1ra vez y cuántos de 2da
  var primeraVez = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM visitantes WHERE visita_numero = 1')) ?? 0;
  var segundaVez = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM visitantes WHERE visita_numero = 2')) ?? 0;
  
  // Obtener lista de iglesias distintas
  var iglesias = await db.rawQuery('SELECT iglesia, COUNT(*) as cantidad FROM visitantes GROUP BY iglesia');

  return {
    'primera': primeraVez,
    'segunda': segundaVez,
    'iglesias': iglesias,
  };
}
// Método para borrar TODOS los registros de la tabla
Future<int> deleteAll() async {
  Database db = await instance.database;
  return await db.delete('visitantes'); // Elimina todas las filas
}
// Método para borrar un registro específico por su ID
Future<int> delete(int id) async {
  Database db = await instance.database;
  return await db.delete('visitantes', where: 'id = ?', whereArgs: [id]);
}
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('visitas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

 Future _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE visitantes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT,
      apellido TEXT,
      visita_numero INTEGER,
      iglesia TEXT,
      telefono TEXT,
      peticion TEXT,
      fecha TEXT
    )
  ''');
}

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('visitantes', row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query('visitantes', orderBy: 'id DESC');
  }
}