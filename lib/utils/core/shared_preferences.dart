import 'package:shared_preferences/shared_preferences.dart';

Future<int?> readIntFromSharedPreferences(String key) async {
  return SharedPreferences.getInstance().then((sp) => sp.getInt(key));
}

Future<bool> writeBoolToSharedPreferences(String key, bool value) async {
  return SharedPreferences.getInstance().then((sp) => sp.setBool(key, value));
}

Future<bool> writeIntToSharedPreferences(String key, int value) async {
  return SharedPreferences.getInstance().then((sp) => sp.setInt(key, value));
}