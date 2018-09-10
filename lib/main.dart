import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:korvihome/KorviHomeColors.dart';
import 'package:korvihome/SettingsPage.dart';
import 'package:korvihome/favorites/FavoritesPage.dart';
import 'package:korvihome/hass/HassPage.dart';
import 'package:korvihome/homeseer/HomeSeerPage.dart';

int _selectedDrawerIndex = 0;

void main() => runApp(new MaterialApp(
  title: 'KorviHome',
  theme: new ThemeData(
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: KorviHomeColors.BLUE, 
    backgroundColor: Colors.white
  ),
  home: Home(),
  onGenerateRoute: (RouteSettings settings) {
    switch (settings.name) {
      case '/favs': return new FromRightToLeft(
        builder: (_) => new FavoritesPage(),
        settings: settings,
      );
      case '/homeseer': return new FromRightToLeft(
        builder: (_) => new HomeSeerPage(),
        settings: settings,
      );
      case '/hass': return new FromRightToLeft(
        builder: (_) => new HassPage(),
        settings: settings,
      );
      case '/settings': return new FromRightToLeft(
        builder: (_) => new SettingsPage(),
        settings: settings,
      );
    }
  },
  // routes: <String, WidgetBuilder> {
  //   '/about': (BuildContext context) => new _aboutPage.About(),
  // }
));

class FromRightToLeft<T> extends MaterialPageRoute<T> {
  FromRightToLeft({ WidgetBuilder builder, RouteSettings settings })
    : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {

    if (settings.isInitialRoute)
      return child;

    return new SlideTransition(
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black26,
              blurRadius: 25.0,
            )
          ]
        ),
        child: child,
      ),
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      )
      .animate(
        new CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        )
      ),
    );
  }
  @override Duration get transitionDuration => const Duration(milliseconds: 400);
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {

  var _title_app;
  
  @override
  void initState() {
    super.initState();
    this._title_app = 'Favoritos';
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build (BuildContext context) => new Scaffold(

    //App Bar
    appBar: new AppBar(
      title: new Text(
        _title_app, 
        style: new TextStyle(
          fontSize: Theme.of(context).platform == TargetPlatform.iOS ? 17.0 : 20.0,
        ),
      ),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
    ),

    //Content of tabs
    body: 
    _selectedDrawerIndex == 0?
      new FavoritesPage() :
    _selectedDrawerIndex == 1?
      new HomeSeerPage() :
    _selectedDrawerIndex == 2?
      new HassPage() :
    _selectedDrawerIndex == 3?
      new SettingsPage() :
      new SettingsPage(),

    //Drawer
    drawer: new Drawer(
      child: new ListView(
        children: <Widget>[
          new Container(
            height: 120.0,
            color: KorviHomeColors.BLUE,
            child: new DrawerHeader(
              padding: new EdgeInsets.all(0.0),
              decoration: new BoxDecoration(
                color: KorviHomeColors.BLUE,
              ),
              child: new Center(
                child: new Image.asset(
                  'assets/white.png',
                  height: 90.0,
                ),
              ),
            ),
          ),
          new ListTile(
            leading: new Icon(Icons.star),
            title: new Text('Favorites'),
            onTap: () {
              setState(() { _selectedDrawerIndex = 0; });
              this._title_app = 'Favorites';
              Navigator.of(context).pop();
            }
          ),
          new ListTile(
            leading: new Icon(Icons.home),
            title: new Text('HomeSeer'),
            onTap: () {
              setState(() { _selectedDrawerIndex = 1; });
              this._title_app = 'HomeSeer';
              Navigator.of(context).pop();
            }
          ),
          new ListTile(
            leading: new Icon(Icons.home),
            title: new Text('HomeAssistant'),
            onTap: () {
              setState(() { _selectedDrawerIndex = 2; });
              this._title_app = 'HomeAssistant';
              Navigator.of(context).pop();
            }
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(Icons.settings),
            title: new Text('Settings'),
            onTap: () {
              setState(() { _selectedDrawerIndex = 3; });
              this._title_app = 'Settings';
              Navigator.of(context).pop();
            }
          ),
        ],
      )
    )
  );  
}