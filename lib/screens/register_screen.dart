import 'package:app_kejaksaan/const.dart';
import 'package:app_kejaksaan/models/model_register.dart';
import 'package:app_kejaksaan/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtNoTlp = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtAlamat = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtNik = TextEditingController();
  //key untuk form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  //fungsi untuk post data
  bool isLoading = false;

  Future<ModelRegister?> registerAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('$url/register.php'),
        body: {
            "username" : txtUsername.text,
            "password" : txtPassword.text,
            "email" : txtEmail.text,
            "no_tlp" : txtNoTlp.text,
            "alamat" : txtAlamat.text,
            "nik" : txtNik.text,
        }
      );

     ModelRegister data = modelRegisterFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value 2 (email sudah terdaftar),1 (berhasil),dan 0 (gagal)
      if(data.value == 1){
        setState(() {
          isLoading= false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );
          //pindah ke page login
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context)
                => const LoginScreen()), (route) => false);
        });
      }else if(data.value == 2){
        setState(() {
          isLoading= false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );
        });
      }else{
        setState(() {
          isLoading= false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );
        });
      }

    }catch(e){
      //munculkan error
      setState(() {
          isLoading= false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString()))
          );
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
                  crossAxisAlignment: CrossAxisAlignment.center, // Memindahkan teks ke sebelah kiri
                  children: [
                    Image.asset(
                      "images/logo.png",
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(' Buat Akun Anda', 
                    style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: txtUsername,
                      validator: (val) {
                        return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: txtNik,
                      validator: (val) {
                        return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Nomor NIK Anda',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: txtNoTlp,
                      validator: (val) {
                        return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Nomor Handphone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: txtEmail,
                      validator: (val) {
                        return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: txtAlamat,
                      validator: (val) {
                        return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Alamat Rumah Anda',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 12,
                    ),
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
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: 
                        MaterialButton(onPressed: (){
                          if (keyForm.currentState?.validate() == true) {
                            //kita panggil function login
                            registerAccount();
                          }
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        padding: EdgeInsets.symmetric(horizontal: 170, vertical: 15),
                        color: Color(0xff3EBFAA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)
                        ),
                        child: Text('Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xffF2F2F2)
                          ),
                        ),
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
