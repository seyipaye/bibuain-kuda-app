import 'dart:convert';

// import '../data/address/address.dart';
import '../data/user/user.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPrefs {
  SharedPreferences _prefs;

  AppSharedPrefs._(this._prefs);

  static Future<AppSharedPrefs> create() async =>
      AppSharedPrefs._(await SharedPreferences.getInstance());

  static AppSharedPrefs get instance => Get.find<AppSharedPrefs>();

  // -------------------------

  Future<bool> clear() async {
    return _prefs.clear();
  }

  /* Future<bool> setUserType(UserType type) =>
      _prefs.setString('userType', type.name);

  UserType? get type {
    final data = _prefs.get('userType');

    if (data == UserType.vendor.name) {
      return UserType.vendor;
    }

    if (data == UserType.customer.name) {
      return UserType.customer;
    }

    return null;
  } */

  saveItem(String name) async {
    _prefs.setBool(name, true);
  }

  deleteItem(String name) {
    _prefs.remove(name);
  }

  bool getItem(String name) {
    var data = _prefs.get(name);
    if (data == null) {
      return false;
    }

    return true;
  }

// User
  Future<bool> setUser(User user) =>
      _prefs.setString('user', jsonEncode('user.toJson()').toString());

  User? get user {
    final data = _prefs.get('user');

    if (data == null) {
      return null;
    }

    return null;
    // User.fromJson(jsonDecode((data as String)));
  }

  Future<bool> setTimeStamp(DateTime dateTime, String id) =>
      _prefs.setString(id, dateTime.toIso8601String());

  DateTime? getTimpStamp(String id) {
    final data = _prefs.get(id);

    if (data == null) {
      return null;
    }

    return DateTime.tryParse(data.toString());
  }
}
