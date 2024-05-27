import 'package:app_kejaksaan/admin/home_admin.dart';
import 'package:app_kejaksaan/const.dart';
import 'package:app_kejaksaan/models/model_login.dart';
import 'package:app_kejaksaan/screens/register_screen.dart';
import 'package:app_kejaksaan/utils/cek_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_kejaksaan/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtEmail = TextEditingController();

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;

  Future<ModelLogin?> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('$url/login.php'), body: {
        "username": txtUsername.text,
        "password": txtPassword.text,
        "email": txtEmail.text
      });
      ModelLogin data = modelLoginFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value ,1 (ada data login),dan 0 (gagal)
      if (data.value == 1) {
        setState(() {
          //save session
          session.saveSession(
              data.value ?? 0,
              data.id ?? "",
              data.username ?? "",
              data.nik ?? "",
              data.noTlp ?? "",
              data.alamat ?? "",
              data.email ?? ""
              );

          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));

          // //pindah ke page berita
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const BottomNavigationPage()),
          //     (route) => false);
          if (data.isAdmin == "0") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavigationPageAdmin()),
                (route) => false);
          }
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      //munculkan error
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: keyForm,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/logo.png",
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: txtEmail,
                      validator: (val) {
                        return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Email Anda',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 34),
                    TextFormField(
                      controller: txtPassword,
                      obscureText: true,
                      validator: (val) {
                        return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          if (keyForm.currentState?.validate() == true) {
                            //kita panggil function login
                            loginAccount();
                          }
                        },
                        padding: EdgeInsets.symmetric(
                            horizontal: 170, vertical: 15),
                        color: Color(0xff3EBFAA),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xffF2F2F2)),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      '---------------------------------------------- or ----------------------------------------------',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 25),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      padding: EdgeInsets.symmetric(
                          horizontal: 167, vertical: 15),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: BorderSide(color: Colors.black)),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
