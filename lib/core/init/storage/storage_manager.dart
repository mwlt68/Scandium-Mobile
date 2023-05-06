import 'dart:convert';
import 'package:scandium/core/base/models/mappable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static Future<T?> getObject<T extends IFromMappable>(
      T model, String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var objectString = pref.getString(key);
    if (objectString != null) {
      try {
        Map<String, dynamic> json = jsonDecode(objectString);
        model = model.fromMap(json) as T;
        return model;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future saveObject<T extends IToMappable>(T model, String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var map = model.toMap();
      String modelStr = jsonEncode(map);
      pref.setString(key, modelStr);
      // ignore: empty_catches
    } catch (e) {}
  }

  static Future remove(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(key);
  }
}
