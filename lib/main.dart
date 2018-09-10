import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:korvihome/SettingsPage.dart';
import 'package:korvihome/homeseer/homeseer.dart';
import './tabs/home.dart' as _firstTab;
import './tabs/dashboard.dart' as _secondTab;
import './tabs/settings.dart' as _thirdTab;
import './screens/about.dart' as _aboutPage;
import './screens/support.dart' as _supportPage;

int _selectedDrawerIndex = 0;

void main() => runApp(new MaterialApp(
  title: 'KorviHome',
  theme: new ThemeData(
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.blueGrey, backgroundColor: Colors.white
  ),
  home: Tabs(),
  onGenerateRoute: (RouteSettings settings) {
    switch (settings.name) {
      case '/favs': return new FromRightToLeft(
        builder: (_) => new _aboutPage.About(),
        settings: settings,
      );
      case '/homeseer': return new FromRightToLeft(
        builder: (_) => new HomeSeer(),
        settings: settings,
      );
      case '/hass': return new FromRightToLeft(
        builder: (_) => new _supportPage.Support(),
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

class Tabs extends StatefulWidget {
  @override
  TabsState createState() => new TabsState();
}

class TabsState extends State<Tabs> {
  
  PageController _tabController;

  var _title_app = null;
  int _tab = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = new PageController();
    this._title_app = TabItems[0].title;
  }

  @override
  void dispose(){
    super.dispose();
    _tabController.dispose();
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
     new PageView(
        controller: _tabController,
        onPageChanged: onTabChanged,
        children: <Widget>[
          new _firstTab.Home(),
          new _secondTab.Dashboard(),
          new _thirdTab.Settings()
        ],
      ) : 
    _selectedDrawerIndex == 1?
        new HomeSeer() :
    _selectedDrawerIndex == 2?
        new HomeSeer() :
        new SettingsPage(),

    //Drawer
    drawer: new Drawer(
      child: new ListView(
        children: <Widget>[
          new Container(
            height: 120.0,
            child: new DrawerHeader(
              padding: new EdgeInsets.all(0.0),
              decoration: new BoxDecoration(
                color: new Color(0xFFECEFF1),
              ),
              child: new Center(
                child: new FlutterLogo(
                  colors: Colors.blueGrey,
                  size: 54.0,
                ),
              ),
            ),
          ),
          new ListTile(
            leading: new Icon(Icons.star),
            title: new Text('Favorites'),
            onTap: () {
              setState(() { _selectedDrawerIndex = 0; });
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
            leading: new Icon(Icons.info),
            title: new Text('HomeAssistant'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/hass');
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

  void onTap(int tab){
    _tabController.jumpToPage(tab);
  }

  void onTabChanged(int tab) {
    setState((){
      this._tab = tab;
    });

    switch (tab) {
      case 0:
        this._title_app = TabItems[0].title;
      break;

      case 1:
        this._title_app = TabItems[1].title;
      break;

      case 2:
        this._title_app = TabItems[2].title;
      break;
    }
  }
}

class TabItem {
  const TabItem({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<TabItem> TabItems = const <TabItem>[
  const TabItem(title: 'Sala', icon: Icons.home),
  const TabItem(title: 'SalaTv', icon: Icons.dashboard),
  const TabItem(title: 'Cuarto', icon: Icons.settings)
];