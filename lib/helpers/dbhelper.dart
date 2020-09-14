import 'package:sqflite/sqflite.dart';
import 'dart:async';
//mendukug pemrograman asinkron
import 'dart:io';
//bekerja pada file dan directory
import 'package:path_provider/path_provider.dart';
import 'package:notes/models/parsing.dart';
//pubspec.yml

//kelass Dbhelper
class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'note.db';

    //create, read databases
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

  //buat tabel baru dengan nama note
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE note (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        text TEXT,
        time TEXT
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  // ambil data berdasarkan waktu
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('note', orderBy: 'time');
    return mapList;
  }

//buat data ke database
  Future<int> insert(ParseData object) async {
    Database db = await this.database;
    int count = await db.insert('note', object.toMap());
    return count;
  }

//update note ke database
  Future<int> update(ParseData object) async {
    print(object.toMap().toString());
    Database db = await this.database;
    int count = await db
        .update('note', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

//delete note dari database
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('note', where: 'id=?', whereArgs: [id]);
    return count;
  }

  // ambil seluruh data dari database
  Future<List<ParseData>> getParseDataList() async {
    var noteMapList = await select();
    int count = noteMapList.length;
    List<ParseData> noteList = List<ParseData>();
    for (int i = 0; i < count; i++) {
      noteList.add(ParseData.fromMap(noteMapList[i]));
    }
    return noteList;
  }
}
