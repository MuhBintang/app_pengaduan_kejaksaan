import 'dart:convert';

import 'package:app_kejaksaan/const.dart';
import 'package:app_kejaksaan/models/model_createJMS.dart';
import 'package:app_kejaksaan/models/model_jms.dart';
import 'package:app_kejaksaan/models/model_pengaduan.dart';
import 'package:app_kejaksaan/screens/jaksa_masuk_sekolah/list_jms_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditJMSScreen extends StatefulWidget {
  final DatumJMS data;
  const EditJMSScreen(this.data, {Key? key}) : super(key: key);

  @override
  State<EditJMSScreen> createState() => _EditJMSScreenState();
}

class _EditJMSScreenState extends State<EditJMSScreen> {
  final TextEditingController _sekolahController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  String? id;
  bool isLoading = false;
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
    });
    getJMSData();
  }

  Future<void> getJMSData() async {
    _sekolahController.text = widget.data.sekolah ?? '';
    _namaController.text = widget.data.nama ?? '';
  }

  Future<void> editJMS() async {
    if (keyForm.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });

        var request = http.MultipartRequest('POST', Uri.parse('$url/edit_jms.php'));
        request.fields['id'] = widget.data.id.toString();
        request.fields['sekolah'] = _sekolahController.text;
        request.fields['nama'] = _namaController.text;
        request.fields['id_user'] = id!;
        request.fields['status'] = "pending";

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        if (response.statusCode == 200) {
          ModelCreateJms data = modelCreateJmsFromJson(responseString);
          if (data.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data.message}')));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ListJMSScreen()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data.message}')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload data')));
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'images/banner.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 30.0,
                  left: 10.0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Card(
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 12),
                    child: Text(
                      "Jaksa Masuk Sekolah (JMS)",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: keyForm, // Add keyForm to Form
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _sekolahController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Sekolah tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Sekolah yang mau dituju',
                        hintText: 'Sekolah yang mau dituju',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _namaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama Pemohon tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Nama Pemohon',
                        hintText: 'Nama Pemohon',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          editJMS(); // Call editJMS() when button is pressed
                        },
                        style: ElevatedButton.styleFrom(
                          padding:
EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        ),
                        child: Text(
                          'SIMPAN',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
