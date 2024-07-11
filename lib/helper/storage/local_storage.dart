import 'package:shared_preferences/shared_preferences.dart';
import 'package:webui/helper/localization/language.dart';
import 'package:webui/helper/services/auth_service.dart';
import 'package:webui/helper/theme/theme_customizer.dart';

class LocalStorage {
  static const String _loggedInUserKey = "user";
  static const String _themeCustomizerKey = "theme_customizer";
  static const String _languageKey = "lang_code";
  static const String _tokenKey = "token";
  static const String _hakAksesKey = "akses";
  static const String _namaKey = "namauser";

  static SharedPreferences? _preferencesInstance;

  static SharedPreferences get preferences {
    if (_preferencesInstance == null) {
      throw ("Call LocalStorage.init() to initialize local storage");
    }
    return _preferencesInstance!;
  }

  static Future<void> init() async {
    _preferencesInstance = await SharedPreferences.getInstance();
    await initData();
  }

  static Future<void> initData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    AuthService.isLoggedIn = preferences.getBool(_loggedInUserKey) ?? false;
    ThemeCustomizer.fromJSON(preferences.getString(_themeCustomizerKey));
  }

  static Future<bool> setLoggedInUser(bool loggedIn) async {
    return preferences.setBool(_loggedInUserKey, loggedIn);
  }

  static Future<bool> setCustomizer(ThemeCustomizer themeCustomizer) {
    return preferences.setString(_themeCustomizerKey, themeCustomizer.toJSON());
  }

  static Future<bool> setLanguage(Language language) {
    return preferences.setString(_languageKey, language.locale.languageCode);
  }

  static String? getLanguage() {
    return preferences.getString(_languageKey);
  }

  static Future<bool> setToken(String token) {
    return preferences.setString(_tokenKey, token);
  }

  static String? getToken() {
    return preferences.getString(_tokenKey);
  }

  static Future<bool> setHakAkses(String token) {
    return preferences.setString(_hakAksesKey, token);
  }

  static String? getHakAkses() {
    return preferences.getString(_hakAksesKey);
  }

  static Future<bool> setNama(String nama) {
    return preferences.setString(_namaKey, nama);
  }

  static String? getNama() {
    return preferences.getString(_namaKey);
  }

  static Future<bool> removeLoggedInUser() async {
    return preferences.remove(_loggedInUserKey);
  }
}
