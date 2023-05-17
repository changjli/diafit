import 'package:shared_preferences/shared_preferences.dart';

class CustomFunction {
  CustomFunction();

  static void logout(Future<Object?> navigate) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("login");
    pref.remove("api_token");

    navigate;
  }
}
