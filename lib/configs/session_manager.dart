import 'package:shared_preferences/shared_preferences.dart';

class SessionManager{

  static Future<bool> get isFirstRun async {
    // this getter decides whether the user is running the app for the first time
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PreferenceKeys.isFirstRun) ?? true;
  }

  static Future<void> setFirstRun(bool value) async{
    // call this function with [value: false] after the user has seen everything in onboarding screen
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PreferenceKeys.isFirstRun, value);
  }
}

class PreferenceKeys{
  // define shared preference keys here
  static String isFirstRun = 'isFirstRun';
}