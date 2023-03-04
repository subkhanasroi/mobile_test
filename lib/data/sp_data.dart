import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_youapp/common/shared_data_type.dart';

class SPData {
  static Future<E> load<E>(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key) as E;
  }

  static Future save<E>(String key, E value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      switch (value.runtimeType) {
        case bool:
          return await prefs.setBool(key, value as bool);
        case int:
          return await prefs.setInt(key, value as int);
        case String:
          return await prefs.setString(key, value as String);
        default:
          return null;
      }
    } catch (e) {
      return e;
    }
  }

  Future<Object?> saveToSP(
      String key, SharedDataType type, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      switch (type) {
        case SharedDataType.bool:
          await prefs.setBool(key, value);
          break;
        case SharedDataType.int:
          await prefs.setInt(key, value);
          break;
        case SharedDataType.string:
          await prefs.setString(key, value);
          break;
        default:
          return null;
      }
    } catch (e) {
      return e;
    }
    return null;
  }

  static Future<bool> reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      return await prefs.clear();
    } catch (e) {
      return false;
    }
  }
}
