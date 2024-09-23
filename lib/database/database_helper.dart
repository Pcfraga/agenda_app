import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'app_database.db');
    print('Initializing database at $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('Creating tables');
        await db.execute(''' 
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');

        await db.execute(''' 
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            date TEXT,
            time TEXT,
            description TEXT,
            userId INTEGER,
            FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<void> insertUser(String email, String password) async {
    final db = await database;
    print('Inserting user with email: $email');
    try {
      await db.insert(
        'users',
        {'email': email, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('User inserted: $email');
    } catch (e) {
      print('Error inserting user: $e');
    }
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    print('Getting user with email: $email');
    try {
      final result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      if (result.isNotEmpty) {
        print('User found: $result');
        return result.first;
      }
      print('User not found');
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    print('Inserting task: $task');
    try {
      return await db.insert(
        'tasks',
        task,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting task: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTasks(int userId) async {
    final db = await database;
    print('Getting tasks for userId: $userId');
    try {
      final result = await db.query(
        'tasks',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      print('Tasks retrieved: $result');
      return result;
    } catch (e) {
      print('Error getting tasks: $e');
      return [];
    }
  }

  Future<int> updateTask(int id, Map<String, dynamic> task) async {
    final db = await database;
    print('Updating task with id: $id');
    try {
      final rowsAffected = await db.update(
        'tasks',
        task,
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Rows updated: $rowsAffected'); // Log para verificar o número de linhas afetadas
      return rowsAffected;
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    print('Deleting task with id: $id');
    try {
      await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Task deleted: $id');
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<Map<String, dynamic>?> getTaskById(int id) async {
    final db = await database;
    print('Getting task with id: $id');
    try {
      final result = await db.query(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        print('Task found: $result');
        return result.first;
      }
      print('Task not found');
      return null;
    } catch (e) {
      print('Error getting task: $e');
      return null;
    }
  }

  Future<void> addTask(String title, String date, String time, String description, int userId) async {
    final task = {
      'title': title,
      'date': date,
      'time': time,
      'description': description,
      'userId': userId,
    };

    final taskId = await insertTask(task);
    print('Task inserted with ID: $taskId');
  }
}
