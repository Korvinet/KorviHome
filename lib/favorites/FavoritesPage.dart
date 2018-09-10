import 'dart:async';
import 'package:flutter/material.dart';
import 'package:korvihome/homeseer/HomeSeerDetails.dart';
import 'package:korvihome/models/HomeSeerArea.dart';

class FavoritesPage extends StatefulWidget {
  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  List<HomeSeerArea> data = new List();

  String errorMessage;

  Future _loadData() async {
    this.errorMessage = "Favoritos sin configurar.";
    setState(() {});
    return;
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
