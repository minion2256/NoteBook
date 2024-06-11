
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UserHelper {
  // Private constructor
  UserHelper._internal();

  // Static private instance
  static final UserHelper _instance = UserHelper._internal();

  // Database instance
  static Database? _database;

  // Factory constructor that returns the static instance
  factory UserHelper() => _instance;

  // Getter to access the database instance
  Future<Database> get database async {
    _database ??= await _initializeDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print("documentsDirectory");
    print(documentsDirectory);
    String path = "${documentsDirectory.path}/user_database.db";
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create table on database creation
  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fname TEXT,
        lname TEXT,
        email TEXT,
        password TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        date TEXT
      )
    ''');
  }
}
