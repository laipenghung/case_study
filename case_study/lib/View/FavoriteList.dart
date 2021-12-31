import 'package:case_study/Data/SQLiteDatabase.dart';
import 'package:case_study/Model/Book.dart';
import 'package:case_study/View/ListViewWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteList extends StatefulWidget {
  FavoriteList({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _FavoriteList();
}

class _FavoriteList extends State<FavoriteList>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
      ),
      body: StreamBuilder<List<Book>>(
        stream: Provider.of<SQLiteDatabase>(context).favoriteList().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListViewWidget(key: UniqueKey(), bookList: snapshot, isFavoriteList: true);
          }
          return Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }
}

