import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert' show json;

import 'package:korvihome/models/HomeSeerArea.dart';
import 'package:korvihome/models/HomeSeerDevice.dart';

class Api {
  //static String baseUrl = 'https://connected.homeseer.com/JSON?user=demo@homeseer.com&pass=demo100&';
  static String baseUrl = 'http://192.168.2.199/JSON?';

  Future<List<HomeSeerArea>> getHomeSeerAreas() async {
    //final uri = Uri.encodeFull('$baseUrl/movies.json');  
    final uri = Uri.encodeFull(baseUrl + 'request=getlocations');
    try{
      http.Response response = await http.get(uri, headers: { "Accept": "application/json" });
      var rawAreas = json.decode(response.body)['location2'] as List;

      List<HomeSeerArea> areas = new List();
      for(int i = 0; i < rawAreas.length; i++){
        var area = new HomeSeerArea(rawAreas[i]);
        areas.add(area);
      }
      return areas;
    } catch(e){
      return null;
    }
  }

  Future<List<HomeSeerDevice>> getHomeSeerDevices(String location) async {
    final uri = Uri.encodeFull(baseUrl + 'request=getstatus&location2=' + location);
    try{
      http.Response response = await http.get(uri, headers: { "Accept": "application/json" });
      var rawDevices = json.decode(response.body)['Devices'] as List;

      List<HomeSeerDevice> devices = new List();
      for(int i = 0; i < rawDevices.length; i++){
        double value = double.tryParse(rawDevices[i]['value'].toString()) ?? 0.0;
        var device = new HomeSeerDevice(rawDevices[i]['ref'], 
          rawDevices[i]['name'], 
          rawDevices[i]['location'], rawDevices[i]['location2'], 
          value, rawDevices[i]['status'].toString());
          devices.add(device);
      }
      return devices;
    } catch(e){
      print('error on server: ' + e.toString());
      return null;
    }
  }

  Future<bool> toggleHomeSeerDevice(int ref, String label) async {
    final uri = Uri.encodeFull(baseUrl);
    var value = label == "on"? "255" : "0";
    var data = "{'action': 'controlbylabel', 'deviceref': '" + ref.toString() + "', 'label': '" + label + "'}";
    var data2 = "{'action': 'controlbyvalue', 'deviceref': '" + ref.toString() + "', 'value': '" + value + "'}";
    try{
      http.Response response = await http.post(uri, headers: { "Accept": "application/json" }, body: data);
      http.Response response2 = await http.post(uri, headers: { "Accept": "application/json" }, body: data2);
      return response2.statusCode == 200 || response.statusCode == 200;
    } catch(e){
      return null;
    }
  }
}