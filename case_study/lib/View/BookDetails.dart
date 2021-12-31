import 'package:case_study/Data/SQLiteDatabase.dart';
import 'package:case_study/Model/Book.dart';
import 'package:case_study/Utility/CheckConnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetails extends StatefulWidget {
  BookDetails({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BookDetails();
}

class _BookDetails extends State<BookDetails>{
  late SQLiteDatabase sqliteDatabase;

  @override
  void initState() {
    super.initState();
    sqliteDatabase = SQLiteDatabase();
  }

  void insertToFavorite(Book book, BuildContext context) async {
    int success = await Provider.of<SQLiteDatabase>(context, listen: false).insertFavorite(book);
    if(success < 0){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error adding to Favorite'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added to Favorite'),
      ));
    }
  }

  void removeFromFavorite(Book book, BuildContext context) async {
    int success = await Provider.of<SQLiteDatabase>(context, listen: false).removeFavorite(book.id);
    if(success < 0){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error removing to Favorite'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Removed from Favorite'),
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context){
    ConnectivityResult network = Provider.of<ConnectivityResult>(context);
    bool isOnline = CheckConnection().isOnline(network);
    
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    Book book = args['book'];
    bool isFavoriteList = args['isFavoriteList'];
    double fontsize = MediaQuery.of(context).size.width * 0.05;
    double textSpacing = MediaQuery.of(context).size.height * 0.01;
    var img = Image.network(book.picture.toString(),);
    var noimg = const Center(
      child: Text(
        "Image\nN/A",
        textAlign: TextAlign.center,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(book.name.toString()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              child: isOnline ? img : noimg,
            ),
            Row(
              children: [
                Spacer(),
                Expanded(
                  flex: 8,
                  child: Text(
                    'Page: ' + book.page.toString(),
                    style: TextStyle(
                      fontSize: fontsize,
                    )
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: textSpacing),
            Row(
              children: [
                Spacer(),
                Expanded(
                  flex: 8,
                  child: Text(
                    'Description: ' + book.description.toString(),
                    style: TextStyle(
                      fontSize: fontsize,
                    )
                  ),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: isFavoriteList ? FloatingActionButton(
        onPressed: () {removeFromFavorite(book, context);},
        tooltip: 'Remove from Favorite',
        child: Icon(Icons.close),
      ) : FloatingActionButton(
        onPressed: () {insertToFavorite(book, context);},
        tooltip: 'Add to Favorite',
        child: Icon(Icons.favorite),
      ),
    );
  }
}

