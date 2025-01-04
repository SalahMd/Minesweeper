import 'package:get/get.dart';
import 'package:untitled/core/services/shared_pref.dart';

class SharedPrefHelper {
  SharedPref sharedPref = Get.find();

  setData(String key, value) async {
    switch (value.runtimeType) {
      case String:
        await sharedPref.sharedPreferences.setString(key, value);
        break;
      case int:
        await sharedPref.sharedPreferences.setInt(key, value);
        break;
      default:
        return null;
    }
  }

  getInt(String key) async {
    return sharedPref.sharedPreferences.getInt(key) ?? 0;
  }

  getString(String key) async {
    return sharedPref.sharedPreferences.getString(key) ?? '';
  }

  removeData(String key) async {
    await sharedPref.sharedPreferences.remove(key);
  }

  clearAllData() async {
    await sharedPref.sharedPreferences.clear();
  }
}
