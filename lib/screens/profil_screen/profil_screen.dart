import 'package:app_kejaksaan/screens/login_screen.dart';
import 'package:app_kejaksaan/utils/cek_session.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String? username;
  String? nik;
  String? email;
  String? nohp;
  String? alamat;
  String? id;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
      nik = pref.getString("nik");
      email = pref.getString("email");
      nohp = pref.getString("no_tlp");
      alamat = pref.getString("alamat");
      id = pref.getString("id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60,),
                  Text(
                    'Profil User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(Icons.person, size: 50),
                  SizedBox(height: 20),
                  Text(
                    '$username', //$username
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: 10),
                  // MaterialButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       session.clearSession();
                  //       // Navigator.pushAndRemoveUntil(
                  //       //     context,
                  //       //     MaterialPageRoute(builder: (context) => ProfilEditScreen()),
                  //       //     (route) => false);
                  //     });
                  //   },
                  //   child: Text('Edit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  //   color: Colors.deepOrange.shade200,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(8.0),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        session.clearSession();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                            (route) => false);
                      });
                    },
                    child: Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    color: Colors.red.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 35),
            Card(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInfoItem(title: 'ID User', value: id ?? ''),
                    UserInfoItem(title: 'Username', value: username ?? ''),
                    UserInfoItem(title: 'NIK', value: nik ?? ''),
                    UserInfoItem(title: 'Email', value: email ?? ''),
                    UserInfoItem(title: 'No. HP', value: nohp ?? ''),
                    UserInfoItem(title: 'Alamat', value: alamat ?? ''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final String title;
  final String value;

  const UserInfoItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}