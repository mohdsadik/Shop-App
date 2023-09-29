import 'package:shared_preferences/shared_preferences.dart';

class Userlogin {
  static const String _userkey = 'sadikisLoggedIn';

  static Future<void> saveduserlogindetails({required bool isLoggedin}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_userkey, isLoggedin);
  }

  static Future<void> userlogindetails({required bool isLoggedin}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.getBool(_userkey) ?? false;
    } catch (e) {
      print(" Eroor while fetching the user details:=>$e");
    }
  }
}
