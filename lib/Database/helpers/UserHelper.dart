
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
        collabo INTEGER default 0,
        date TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE invited (
        invited_id INTEGER PRIMARY KEY AUTOINCREMENT,
        note_id INTEGER,
        date TEXT,
        FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE col_notes (
        col_note_id INTEGER PRIMARY KEY AUTOINCREMENT,
        invitedId INTEGER ,
        content TEXT,
        collaborator TEXT,
        date TEXT,
        FOREIGN KEY (invitedId) REFERENCES invited (invited_id) ON DELETE CASCADE 
      )
    ''');
    await db.execute('''
      CREATE TABLE collaborators (
        collaborator_id INTEGER PRIMARY KEY AUTOINCREMENT,
        invited_collabo INTEGER ,
        collaborator TEXT,
        date TEXT,
        FOREIGN KEY (invited_collabo) REFERENCES invited (invited_id) ON DELETE CASCADE 
      )
    ''');
  }
}
