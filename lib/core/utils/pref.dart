import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum MySharedKeys { userName, userID, favourites}
class MySharedPref {
  late SharedPreferences _preferences;

  Future<SharedPreferences> initSP() async {
    printTest('initSP');
    return _preferences = await SharedPreferences.getInstance();
  }


  void putString({
    required MySharedKeys key,
    required String? value,
  }) async {
    await _preferences.setString(key.name, value ?? "");
  }

  String getString({required MySharedKeys key}) {
    return _preferences.getString(key.name) ?? "";
  }

  // list of strings
  void putStringList({
    required MySharedKeys key,
    required List<String>? value,
  }) async {
    await _preferences.setStringList(key.name, value ?? []);
  }

  List<String> getStringList({required MySharedKeys key}) {
    return _preferences.getStringList(key.name) ?? [];
  }
  // delete String from list
  void deleteStringFromList({
    required MySharedKeys key,
    required String value,
  }) async {
    List<String> list = getStringList(key: key);
    list.remove(value);
    await _preferences.setStringList(key.name, list);
  }

  // add String to list
  void addStringToList({
    required MySharedKeys key,
    required String value,
  }) async {
    List<String> list = getStringList(key: key);
    list.add(value);
    await _preferences.setStringList(key.name, list);
  }


  Future<bool>? clearShared() {
    return _preferences.clear();
  }

}

void printResponse(String text) {
  if (kDebugMode) {
    print('\x1B[33m$text\x1B[0m');
  }
}

void printError(String text) {
  if (kDebugMode) {
    print('\x1B[31m$text\x1B[0m');
  }
}

void printTest(String text) {
  if (kDebugMode) {
    print('\x1B[32m$text\x1B[0m');
  }
}