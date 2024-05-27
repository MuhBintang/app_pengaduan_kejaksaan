import 'package:shared_preferences/shared_preferences.dart';

class SessionManager{
  int? value;
  String? idUser, userName, nik, noTlp, alamat, email;

  Future<void> saveSession(int val, String id, String userName, String nik, String noTlp, String alamat, String email) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("value", val);
    pref.setString("id", id);
    pref.setString("username", userName);
    pref.setString("nik", nik);
    pref.setString("no_tlp", noTlp);
    pref.setString("alamat", alamat);
    pref.setString("email", email);
  }

  Future getSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt("value");
    pref.getString("id");
    pref.getString("username");
    pref.getString("nik");
    pref.getString("no_tlp");
    pref.getString("alamat");
    pref.getString("email");
    return value;
  }

  Future getSesiIdUser() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getString("id");
    return idUser;
  }

  //clear session --> logout
  Future clearSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

SessionManager session = SessionManager();