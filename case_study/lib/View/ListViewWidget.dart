import 'package:case_study/Model/Book.dart';
import 'package:case_study/Utility/CheckConnection.dart';
import 'package:case_study/View/BookDetails.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ListViewWidget extends StatefulWidget {
  final AsyncSnapshot<List<Book>> bookList;
  final bool isFavoriteList;
  ListViewWidget({Key? key, required this.bookList, required this.isFavoriteList}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ListViewWidget(bookList, isFavoriteList);
}

class _ListViewWidget extends State<ListViewWidget> {
  final AsyncSnapshot<List<Book>> bookList;
  final bool isFavoriteList;
  _ListViewWidget(this.bookList, this.isFavoriteList);

  @override
  Widget build(BuildContext context){
    ConnectivityResult network = Provider.of<ConnectivityResult>(context);
    bool isOnline = CheckConnection().isOnline(network);
    double cardHorizontalMargin = MediaQuery.of(context).size.width * 0.03;
    double cardVerticalMargin = MediaQuery.of(context).size.height * 0.005;
    double fontsize = isOnline ? MediaQuery.of(context).size.width * 0.05 : MediaQuery.of(context).size.width * 0.04;
    double textSpacing = MediaQuery.of(context).size.height * 0.005;

    return ListView.builder(
        itemCount: bookList.data?.length,
        itemBuilder: (context, index) {
          var img = Image.network(bookList.data![index].picture.toString(),);
          var noimg = const Center(
            child: Text(
              'Image\nN/A',
              textAlign: TextAlign.center,
            ),
          );

          return Container(
            margin: EdgeInsets.symmetric(horizontal: cardHorizontalMargin, vertical: cardVerticalMargin),
            child: Card(
              child: InkWell(
                splashColor: Colors.red.withAlpha(20),
                onTap: () {
                  pushNewScreenWithRouteSettings(context, screen: BookDetails(), settings: RouteSettings(name: '/bookDetails', 
                  arguments: {'book': bookList.data![index], 'isFavoriteList': isFavoriteList}));
                },
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: cardHorizontalMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Book: ' + bookList.data![index].name.toString(),
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: FontWeight.bold,
                              )
                            ),
                            SizedBox(height: textSpacing),
                            Text(
                              'Page: ' + bookList.data![index].page.toString(),
                              style: TextStyle(
                                fontSize: fontsize,
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: isOnline ? img : noimg,
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}