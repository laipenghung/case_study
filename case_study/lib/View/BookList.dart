import 'dart:convert';
import 'package:case_study/Data/SQLiteDatabase.dart';
import 'package:case_study/Model/Book.dart';
import 'package:case_study/Utility/CheckConnection.dart';
import 'package:case_study/View/ListViewWidget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BookList extends StatefulWidget {
  BookList({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BookList();
}

class _BookList extends State<BookList>{
  late SQLiteDatabase sqliteDatabase;
  
  @override
  void initState() {
    super.initState();
    sqliteDatabase = SQLiteDatabase();
  }

  Future<List<Book>> loadBooks(bool isOnline) async {
    List<Book> books;
    //If got connection, load and store in SQLite
    //Else just load the saved data in SQLite
    if(isOnline){
      String jsonString = await rootBundle.loadString('assets/JSONFiles/bookList.json');
      var jsonResponse = jsonDecode(jsonString)['book_list'];
      books = List<Book>.from(jsonResponse.map((book) => Book.fromJson(book)));
      //Store to sqlite
      await sqliteDatabase.insertBook(books);
    } else {
      books = await sqliteDatabase.getBooks();
    }
    return books;
  }
  
  @override
  Widget build(BuildContext context){
    ConnectivityResult network = Provider.of<ConnectivityResult>(context);
    bool isOnline = CheckConnection().isOnline(network);

    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: FutureBuilder<List<Book>>(
        future: loadBooks(isOnline),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListViewWidget(key: UniqueKey(), bookList: snapshot, isFavoriteList: false);
          }
          return Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }
}

