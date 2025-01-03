import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/core/services/shared_pref.dart';

class SharedPrefHelper {
  SharedPref sharedPreferences = Get.find();

  static removeData(String key) async {
    debugPrint('SharedPrefHelper : data with key : $key has been removed');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);
  }
  static clearAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

   setData(String key, value) async {
    switch (value.runtimeType) {
      case String:
        await sharedPreferences.sharedPreferences.setString(key, value);
        break;
      case int:
        await sharedPreferences.sharedPreferences.setInt(key, value);
        break;
      default:
        return null;
    }
  }

   getInt(String key) async {
    return sharedPreferences.sharedPreferences.getInt(key) ?? 0;
  }

   getString(String key) async {
    return sharedPreferences.sharedPreferences.getString(key) ?? '';
  }


}
