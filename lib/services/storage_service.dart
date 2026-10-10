import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  /// Initialize SharedPreferences
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //-------------------------
  // Login Status
  //-------------------------

  static Future saveLogin(bool value) async {
    await _prefs.setBool("isLoggedIn", value);
  }

  static bool getLogin() {
    return _prefs.getBool("isLoggedIn") ?? false;
  }

  //-------------------------
  // Farmer Name
  //-------------------------

  static Future saveFarmerName(String name) async {
    await _prefs.setString("farmerName", name);
  }

  static String getFarmerName() {
    return _prefs.getString("farmerName") ?? "Farmer";
  }

  //-------------------------
  // Farm Area
  //-------------------------

  static Future saveFarmArea(String area) async {
    await _prefs.setString("farmArea", area);
  }

  static String getFarmArea() {
    return _prefs.getString("farmArea") ?? "";
  }

  //-------------------------
  // Crop Type
  //-------------------------

  static Future saveCrop(String crop) async {
    await _prefs.setString("crop", crop);
  }

  static String getCrop() {
    return _prefs.getString("crop") ?? "";
  }

  //-------------------------
  // Sowing Date
  //-------------------------

  static Future saveSowingDate(String date) async {
    await _prefs.setString("sowingDate", date);
  }

  static String getSowingDate() {
    return _prefs.getString("sowingDate") ?? "";
  }

  //-------------------------
  // Logout
  //-------------------------

  static Future logout() async {
    await _prefs.clear();
  }
}