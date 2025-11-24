import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:utspam_b_0030_film/models/user.dart';
import 'package:utspam_b_0030_film/models/transaction.dart' as MyModel;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tiket_film.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        alamat TEXT NOT NULL,
        noTelepon TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        judulFilm TEXT NOT NULL,
        posterFilm TEXT NOT NULL,
        jadwalFilm TEXT NOT NULL,
        namaPembeli TEXT NOT NULL,
        jumlahTiket INTEGER NOT NULL,
        tanggalBeli TEXT NOT NULL,
        totalBiaya INTEGER NOT NULL,
        metodePembayaran TEXT NOT NULL,
        nomorKartu TEXT,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE current_user (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        user_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
  }

  Future<int> createUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String emailOrUsername, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: '(email = ? OR username = ?) AND password = ?',
      whereArgs: [emailOrUsername, emailOrUsername, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> isEmailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<bool> isUsernameExists(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<void> saveCurrentUser(int userId) async {
    final db = await database;
    await db.delete('current_user');
    await db.insert('current_user', {'id': 1, 'user_id': userId});
  }

  Future<User?> getCurrentUser() async {
    final db = await database;
    final maps = await db.query('current_user');

    if (maps.isNotEmpty) {
      final userId = maps.first['user_id'] as int;
      return await getUserById(userId);
    }
    return null;
  }

  Future<void> removeCurrentUser() async {
    final db = await database;
    await db.delete('current_user');
  }

  Future<void> createTransaction(MyModel.Transaction transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap());
  }

  Future<List<MyModel.Transaction>> getTransactionsByUser(String namaPembeli) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'namaPembeli = ? AND status = ?',
      whereArgs: [namaPembeli, 'selesai'],
      orderBy: 'id DESC',
    );

    return maps.map((map) => MyModel.Transaction.fromMap(map)).toList();
  }

  Future<void> updateTransaction(MyModel.Transaction transaction) async {
    final db = await database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
