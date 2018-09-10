import 'dart:async';
import 'package:flutter/material.dart';
import 'package:korvihome/homeseer/HomeSeerDetails.dart';
import 'package:korvihome/models/HomeSeerArea.dart';
import 'package:korvihome/provider/HomeSeerApi.dart';
import 'package:korvihome/provider/SettingsService.dart';

class HomeSeerPage extends StatefulWidget {
  @override
  HomeSeerPageState createState() => HomeSeerPageState();
}

class HomeSeerPageState extends State<HomeSeerPage> {
  List<HomeSeerArea> data = new List();
  SettingsService settingsService = new SettingsService();

  String errorMessage;

  Future _loadData() async {
    var settings = await settingsService.loadSettings();
    if(settings.homeSeerUrl.isEmpty){
      this.errorMessage = "You must configure HomeSeer Url in app settings.";
      setState(() { });
      return 0;
    }

    var api = new HomeSeerApi(settings.homeSeerUrl);
      this.errorMessage = null;
      var areas = await api.getHomeSeerAreas();

      if(areas == null){
        this.errorMessage = "Error connecting to server api.";
      } else if (areas.length <= 0){
        this.errorMessage = "No locations found.";
      } else {
        this.data = areas;
      }

      setState(() { });
  }

  @override
  void initState(){
    this._loadData();
  }

  @override
  Widget build(BuildContext context) {
     if(this.errorMessage == null){
        return new Container(
          child: ListView.builder(
            padding: new EdgeInsets.all(8.0),
            itemCount: data.length,
            itemBuilder: (BuildContext contet, int index){
              return ListTile(
                title: Text(this.data[index].name),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){
                  print('tapped: ' + this.data[index].name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeSeerDetails(this.data[index].name)),
                  );
                },
              );
            },
          ),
        ); 
     } else { 
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [ Card(
            color: Colors.red,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.error, color: Colors.white,),
                  title: new Text('Ocurrió un error.', style: TextStyle(color: Colors.white),),
                  subtitle: new Text(this.errorMessage, style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          )] 
        );
     }
  }
}
