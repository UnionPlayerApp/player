import 'package:shared_preferences/shared_preferences.dart';

void writeBoolToSharedPreferences(String key, bool value) async {
  await SharedPreferences.getInstance().then((sp) => sp.setBool(key, value));
}

void writeIntToSharedPreferences(String key, int value) async {
  await SharedPreferences.getInstance().then((sp) => sp.setInt(key, value));
}