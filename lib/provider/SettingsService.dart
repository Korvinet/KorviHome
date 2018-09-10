
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:korvihome/models/Settings.dart';
import 'package:path_provider/path_provider.dart';

class SettingsService {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/settings.txt');
  }

  Future<Settings> loadSettings() async {
    try{
      final file = await _localFile;
      String data = await file.readAsString();
      Map settingsMap = json.decode(data);
      return new Settings.fromJson(settingsMap);
    } catch(e){
      return new Settings('', '', '', '', '', '');
    }
  }

  Future saveSettings(Settings settings) async {
    final file = await _localFile;
    String fileData = json.encode(settings);    
    await file.writeAsString(fileData);
  }

}