import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:korvihome/models/Settings.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController homeSeerUrl;
  TextEditingController homeSeerUser;
  TextEditingController homeSeerPwd;

  TextEditingController hassUrl;
  TextEditingController hassUser;
  TextEditingController hassPwd;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/settings.txt');
  }

  @override
  void initState() {
    super.initState();
    
    _readSettings().then((result){
      setState(() { });
    });
  }

  Future _readSettings() async {
    try{
      final file = await _localFile;
      String data = await file.readAsString();
      Map settingsMap = json.decode(data);
      var settings = new Settings.fromJson(settingsMap);
      _setValues(settings);
      return true;
    } catch(e){
      _setValues(new Settings('', '', '', '', '', ''));
      return false;
    }
  }

  _setValues(Settings settings){
    homeSeerUrl = new TextEditingController(text: settings.homeSeerUrl);
    homeSeerUser = new TextEditingController(text: settings.homeSeerUser);
    homeSeerPwd = new TextEditingController(text: settings.homeSeerPwd);

    hassUrl = new TextEditingController(text: settings.hassUrl);
    hassUser = new TextEditingController(text: settings.hassUser);
    hassPwd = new TextEditingController(text: settings.hassPwd);

    setState(() { });
  }

  _saveForm() async {
    
    final file = await _localFile;
    
    Settings settings = new Settings(
        homeSeerUrl.text, homeSeerUser.text, homeSeerPwd.text,
        hassUrl.text, hassUser.text, hassPwd.text);

    String fileData = json.encode(settings);

    // Write the file
    await file.writeAsString(fileData);

    final snackBar = SnackBar(content: Text('Settings saved.'));
    Scaffold.of(context).showSnackBar(snackBar);
    
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: new EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("HomeSeer", 
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            TextField(
              keyboardType: TextInputType.url,
              controller: homeSeerUrl,
              decoration: InputDecoration(
                labelText: 'Api url'
              )
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: homeSeerUser,
              decoration: InputDecoration(
                labelText: 'Username'
              )
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: homeSeerPwd,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              )
            ),
            Divider(height: 20.0,),
            Text("HomeAssistant", 
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            TextField(
              keyboardType: TextInputType.url,
              controller: hassUrl,
              decoration: InputDecoration(
                labelText: 'Api url'
              )
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: hassUser,
              decoration: InputDecoration(
                labelText: 'Username',
              )
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: hassPwd,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password'
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () async {
                  await _saveForm();
                },
                child: Text('Save'),
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ),
          ]
        )
      )
    );
  }
}
