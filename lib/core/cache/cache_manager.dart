import 'package:shared_preferences/shared_preferences.dart';

import '../enum/preference_keys.dart';

class CacheManager {
  CacheManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }

  static final CacheManager _instance = CacheManager._init();

  SharedPreferences? _preferences;
  static CacheManager get instance => _instance;
  static Future prefencesInit() async {
    instance._preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> clearAll() async {
    await _preferences!.clear();
  }

  Future<void> clearAllSaveFirst(PreferencesKeys key) async {
    if (_preferences != null) {
      await _preferences!.clear();
      await setBoolValue(key, true);
    }
  }

  Future<void> setStringValue(PreferencesKeys key, String value) async {
    await _preferences!.setString(key.toString(), value);
  }

  Future<void> setBoolValue(PreferencesKeys key, bool value) async {
    await _preferences!.setBool(key.toString(), value);
  }

  Future<void> setIntlValue(PreferencesKeys key, int value) async {
    await _preferences!.setInt(key.toString(), value);
  }

  String getStringValue(PreferencesKeys key) =>
      _preferences?.getString(key.toString()) ?? '';

  int getIntValue(PreferencesKeys key) =>
      _preferences?.getInt(key.toString()) ?? 0;

  bool getBoolValue(PreferencesKeys key) =>
      _preferences?.getBool(key.toString()) ?? false;
}
