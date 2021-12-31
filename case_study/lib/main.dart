import 'package:case_study/Data/SQLiteDatabase.dart';
import 'package:case_study/View/BookDetails.dart';
import 'package:case_study/View/BookList.dart';
import 'package:case_study/View/FavoriteList.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityResult>.value(
          value: Connectivity().onConnectivityChanged,
          initialData: ConnectivityResult.none,
        ),
        ChangeNotifierProvider.value(
          value: SQLiteDatabase(),
        ),
      ],
      child: MaterialApp(
        title: 'Book Catalogue',
        theme: ThemeData(
            primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(title: 'Book Catalogue'),
          '/bookList': (context) => BookList(),
          '/bookDetails': (context) => BookDetails(),
          '/favoriteList': (context) => FavoriteList(),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _screenOptions() {
    return [
      BookList(),
      FavoriteList(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        contentPadding: 0,
        icon: Icon(Icons.book),
        title: ("Library"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Colors.black,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(title: 'Book Catalogue'),
            '/bookDetails': (context) => BookDetails(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.favorite),
        title: ("Favorite"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Colors.black,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(title: 'Book Catalogue'),
            '/bookDetails': (context) => BookDetails(),
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        context, 
        screens: _screenOptions(),
        items: _navBarsItems(),
        stateManagement: false,
        onItemSelected: (index) {setState(() {});},
    );
  }
}