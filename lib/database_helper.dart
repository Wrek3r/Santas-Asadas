import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'usuario.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuario (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            telefono TEXT NOT NULL,
            direccion TEXT NOT NULL,
            referencias TEXT
          )
        ''');
        await db.execute('''
    CREATE TABLE carrito (
    productId TEXT PRIMARY KEY,
    productTitle TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unitPrice REAL NOT NULL
  )
''');
        await db.execute('''
  CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    resumen TEXT NOT NULL,
    total REAL NOT NULL,
    fecha TEXT NOT NULL
  )
''');
      },
    );
  }
  Future<void> guardarPedido(String resumen, double total) async {
    final db = await database;
    await db.insert('pedidos', {
      'resumen': resumen,
      'total': total,
      'fecha': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> obtenerPedidos() async {
    final db = await database;
    return await db.query('pedidos', orderBy: 'fecha DESC');
  }
  Future<void> guardarUsuario({
    required String nombre,
    required String telefono,
    required String direccion,
    required String referencias,
  }) async {
    final db = await database;
    final existing = await db.query('usuario', where: 'id = ?', whereArgs: [1]);
    if (existing.isEmpty) {
      await db.insert('usuario', {
        'id': 1,
        'nombre': nombre,
        'telefono': telefono,
        'direccion': direccion,
        'referencias': referencias,
      });
    } else {
      await db.update(
        'usuario',
        {
          'nombre': nombre,
          'telefono': telefono,
          'direccion': direccion,
          'referencias': referencias,
        },
        where: 'id = ?',
        whereArgs: [1],
      );
    }
  }

  /// Obtiene los datos del usuario, o null si no existe
  Future<Map<String, dynamic>?> obtenerUsuario() async {
    final db = await database;
    final result = await db.query('usuario', where: 'id = ?', whereArgs: [1]);
    return result.isNotEmpty ? result.first : null;
  }

  /// true si ya hay datos guardados
  Future<bool> usuarioRegistrado() async {
    final usuario = await obtenerUsuario();
    return usuario != null;
  }
  Future<void> guardarCarrito(List<Map<String, dynamic>> items) async {
    final db = await database;
    await db.delete('carrito'); // limpia y reescribe
    for (final item in items) {
      await db.insert('carrito', item);
    }
  }

  Future<List<Map<String, dynamic>>> cargarCarrito() async {
    final db = await database;
    return await db.query('carrito');
  }

  Future<void> guardarToken(String token) async {
    final db = await database;
    await db.execute('''
    CREATE TABLE IF NOT EXISTS sesion (
      id INTEGER PRIMARY KEY,
      token TEXT NOT NULL
    )
  ''');
    await db.delete('sesion');
    await db.insert('sesion', {'id': 1, 'token': token});
  }

  Future<String?> obtenerToken() async {
    final db = await database;
    try {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS sesion (
        id INTEGER PRIMARY KEY,
        token TEXT NOT NULL
      )
    ''');


      Future<List<Map<String, dynamic>>> obtenerPedidos() async {
        final db = await database;
        return await db.query('pedidos', orderBy: 'fecha DESC');
      }
      final result = await db.query('sesion', where: 'id = ?', whereArgs: [1]);
      return result.isNotEmpty ? result.first['token'] as String : null;
    } catch (_) {
      return null;
    }
  }


  Future<void> cerrarSesion() async {
    final db = await database;
    await db.delete('sesion');
    await db.delete('usuario');
  }
}