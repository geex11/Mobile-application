import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';
import '../models/timetable_entry.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'smartz.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _createTables,
      onUpgrade: (db, oldVersion, newVersion) => _createTables(db, newVersion),
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS timetable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        day TEXT NOT NULL,
        unitCode TEXT NOT NULL,
        unitName TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        room TEXT NOT NULL,
        lecturer TEXT NOT NULL
      )
    ''');
  }

  // ── NOTES ──────────────────────────────────────────────────────────────────

  static Future<int> insertNote(Note note) async {
    final db = await database;
    return db.insert('notes', note.toMap());
  }

  static Future<List<Note>> getAllNotes() async {
    final db = await database;
    final maps = await db.query('notes', orderBy: 'id DESC');
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  static Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    final maps = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'id DESC',
    );
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  static Future<int> updateNote(Note note) async {
    final db = await database;
    return db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  static Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // ── TIMETABLE ──────────────────────────────────────────────────────────────

  static Future<int> insertTimetableEntry(TimetableEntry entry) async {
    final db = await database;
    return db.insert('timetable', entry.toMap());
  }

  static Future<List<TimetableEntry>> getAllTimetableEntries() async {
    final db = await database;
    final dayOrder = TimetableEntry.days.asMap().entries
        .map((e) => "WHEN '${e.value}' THEN ${e.key}")
        .join(' ');
    final maps = await db.rawQuery(
      'SELECT * FROM timetable ORDER BY CASE day $dayOrder END, startTime ASC',
    );
    return maps.map((m) => TimetableEntry.fromMap(m)).toList();
  }

  static Future<List<TimetableEntry>> searchTimetable(String query) async {
    final db = await database;
    final maps = await db.query(
      'timetable',
      where: 'unitCode LIKE ? OR unitName LIKE ? OR day LIKE ? OR lecturer LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
      orderBy: 'day ASC, startTime ASC',
    );
    return maps.map((m) => TimetableEntry.fromMap(m)).toList();
  }

  static Future<int> updateTimetableEntry(TimetableEntry entry) async {
    final db = await database;
    return db.update('timetable', entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
  }

  static Future<int> deleteTimetableEntry(int id) async {
    final db = await database;
    return db.delete('timetable', where: 'id = ?', whereArgs: [id]);
  }
}
