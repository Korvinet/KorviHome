import 'dart:async';
import 'package:flutter/material.dart';
import 'package:korvihome/homeseer/HomeSeerDetails.dart';
import 'package:korvihome/models/HomeSeerArea.dart';
import 'package:korvihome/provider/api.dart';

class HomeSeer extends StatefulWidget {
  @override
  _HomeSeerState createState() => _HomeSeerState();
}

class _HomeSeerState extends State<HomeSeer> {
  List<HomeSeerArea> data = new List();

  String errorMessage;

  Future _loadData() async {
    var api = new Api();
      this.errorMessage = null;
      var areas = await api.getHomeSeerAreas();

      if(areas == null){
        this.errorMessage = "No hay conexión con el servidor.";
      } else if (areas.length <= 0){
        this.errorMessage = "No hay áreas por aquí.";
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
