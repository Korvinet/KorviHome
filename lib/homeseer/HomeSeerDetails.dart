import 'dart:async';
import 'package:flutter/material.dart';
import 'package:korvihome/KorviHomeColors.dart';
import 'package:korvihome/models/HomeSeerDevice.dart';
import 'package:korvihome/provider/HomeSeerApi.dart';
import 'package:korvihome/provider/SettingsService.dart';

class HomeSeerDetails extends StatefulWidget {

  HomeSeerDetails(this.location);

  String location;

  @override
  _HomeSeerDetailsState createState() => _HomeSeerDetailsState(this.location);
}

class _HomeSeerDetailsState extends State<HomeSeerDetails> {

  _HomeSeerDetailsState(this.location);
  SettingsService settingsService = new SettingsService();
  HomeSeerApi api;

  List<HomeSeerDevice> data = new List();
  String location;
  String errorMessage;

  Future _loadData() async {
    var settings = await settingsService.loadSettings();
    if(settings.homeSeerUrl.isEmpty){
      this.errorMessage = "You must configure HomeSeer Url in app settings.";
      return;
    }

    this.api = new HomeSeerApi(settings.homeSeerUrl);
      errorMessage = null;
      var devices = await api.getHomeSeerDevices(this.location);
      if(devices == null){
        this.errorMessage = "No hay conexión con el servidor.";
      } else if (devices.length <= 0){
        this.errorMessage = "No hay áreas por aquí.";
      } else {
        this.data = devices;
      }

      setState(() { });
  }

  @override
  void initState(){
    this._loadData();
  }

  String getToggleLabel(String status, double value){
    status = status.trim().toLowerCase();
    if(status == "on") return "off";
    if(status == "off") return "on";
    if(value == 0) return "on";
    if(value > 0) return "off";
    return "";
  }

  bool isOn(String status, double value){
    status = status.trim().toLowerCase();
    if(status == "on") return true;
    if(status == "off") return false;
    if(value == 0) return false;
    if(value > 0) return true;
    return false;
  }

  Future<bool> toggleDevice(HomeSeerDevice device) async {
    var label = getToggleLabel(device.status, device.value);
    if(await this.api.toggleHomeSeerDevice(device.ref, label)){
      device.status = label;
      device.value = label == "on"? 255.0 : 0.0;
    }
    setState(() { });
    return isOn(device.status, device.value);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //App Bar
      appBar: new AppBar(
        title: new Text(
          'HomeSeer', 
          style: new TextStyle(
            fontSize: Theme.of(context).platform == TargetPlatform.iOS ? 17.0 : 20.0,
          ),
        ),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      //Content of tabs
      body: this.errorMessage == null ?
        new Container(
          child: new GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0
              ),
            padding: new EdgeInsets.all(8.0),
            itemCount: data.length,
            itemBuilder: (BuildContext contet, int index){
              return GridTile(
                child: new GestureDetector(
                  child: new Container(
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(5.0),
                      color: isOn(this.data[index].status, this.data[index].value)? KorviHomeColors.BLUE : Colors.grey,
                    ),
                    padding: EdgeInsets.all(2.0),
                    margin: EdgeInsets.all(4.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[ 
                            Icon(Icons.star, color: data[index].isFav? Colors.yellow : Colors.black,) 
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: Text(data[index].name + '\n' + data[index].location, textAlign: TextAlign.center,),
                          ),
                        ),
                      ]
                    )
                  ),
                  onTap: () async {
                    await toggleDevice(this.data[index]);
                  },
                  onDoubleTap: () {
                    print('entering double tap.');
                    this.data[index].toggleFavorite();
                    setState(() { });
                  },
                ) ,
              );
            },
          ),
        ) : 
        new Column(
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
        )
    );
  }
}
