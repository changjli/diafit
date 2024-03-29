import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomFunction {
  CustomFunction();

  static void logout(Future<Object?> navigate, String apiToken) async {
    // logout dari local device
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("login");
    pref.remove('id');
    pref.remove("api_token");
    print(pref.getBool("login"));

    // logout dari web service
    try {
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/logout"),
          headers: {"Authorization": "Bearer $apiToken"});

      if (response.statusCode == 200) {
        navigate;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<Map> getAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString('id'),
      'apiToken': prefs.getString('api_token')!.split('|')[1],
    };
  }

  static Future<bool> deleteNutrition(String id) async {
    Map auth = await getAuth();
    try {
      http.Response response = await http
          .post(Uri.parse("http://10.0.2.2:8000/api/nutrition/$id"), headers: {
        "Authorization": "Bearer ${auth['apiToken']}",
      }, body: {
        "_method": "delete",
      });

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
