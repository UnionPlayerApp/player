import 'package:shared_preferences/shared_preferences.dart';

Future<int?> readIntFromSharedPreferences(String key) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  int? value = sp.getInt(key);
  return value;
}

void writeBoolToSharedPreferences(String key, bool value) async {
  await SharedPreferences.getInstance().then((sp) => sp.setBool(key, value));
}

void writeIntToSharedPreferences(String key, int value) async {
  await SharedPreferences.getInstance().then((sp) => sp.setInt(key, value));
}