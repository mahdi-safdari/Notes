import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class NotesDatabase {
  NotesDatabase._init();
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String databaseName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute(''' 
    CREATE TABLE $tableNotes (
      ${NotesFields.id} $idType,
      ${NotesFields.title} $textType,
      ${NotesFields.description} $textType,
      ${NotesFields.time} $textType) ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int? id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: NotesFields.values,
      where: '${NotesFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

  Future<List<Note>> readAllNote() async {
    final db = await instance.database;
    final result = await db.query(tableNotes);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return await db.update(
      tableNotes,
      note.toJson(),
      where: '${NotesFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int? id) async {
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '${NotesFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    return db.close();
  }
}
