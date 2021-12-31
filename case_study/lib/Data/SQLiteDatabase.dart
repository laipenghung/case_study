import 'package:case_study/Model/Book.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteDatabase extends ChangeNotifier {
  Future<Database> initalizeDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'book.db'),
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        Batch batch = db.batch();
        CreateBookTable(batch);
        CreateFavoriteTable(batch);
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        Batch batch = db.batch();
        if(oldVersion == 1){
          CreateFavoriteTable(batch);
        }
        await batch.commit();
      },
      version: 2,
    );
  }

  void CreateBookTable(Batch batch) {
    batch.execute(
      '''
      CREATE TABLE book(
        id INTEGER PRIMARY KEY NOT NULL,
        name TEXT,
        page INTEGER,
        description TEXT,
        picture TEXT
      )
      '''
    );
  }

  void CreateFavoriteTable(Batch batch) {
    batch.execute(
      '''
      CREATE TABLE favorite(
        bookID INTEGER PRIMARY KEY NOT NULL,
        FOREIGN KEY (bookID) REFERENCES book(id) 
      )
      '''
    );
  }

  Future<int> insertBook(List<Book> books) async {
    int result = 0;
    final Database db = await initalizeDB();
    for(Book book in books){
      result = await db.insert(
        'book',
        book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return result;
  }

  Future<List<Book>> getBooks() async {
    final Database db = await initalizeDB();
    final List<Map<String, dynamic>> maps = await db.query('book');
    return List.generate(maps.length, (index) {
      return Book(
        id: maps[index]['id'],
        name: maps[index]['name'],
        page: maps[index]['page'],
        description: maps[index]['description'],
        picture: maps[index]['picture'],
      );
    });
  }

  Future<int> insertFavorite(Book book) async {
    int result = 0;
    final Database db = await initalizeDB();
    result = await db.insert(
      'favorite',
      book.toMapID(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
    return result;
  }

  Future<List<Book>> favoriteList() async {
    final Database db = await initalizeDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT id, name, page, description, picture 
      FROM favorite
      INNER JOIN book ON book.id = favorite.bookID
    ''');

    return List.generate(maps.length, (index) {
      return Book(
        id: maps[index]['id'],
        name: maps[index]['name'],
        page: maps[index]['page'],
        description: maps[index]['description'],
        picture: maps[index]['picture'],
      );
    });
  }

  Future<int> removeFavorite(int? id) async {
    int result = 0;
    final Database db = await initalizeDB();
    result = await db.delete(
      'favorite',
      where: 'bookID = ?',
      whereArgs: [id]
    );
    notifyListeners();
    return result;
  }
}