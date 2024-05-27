import 'dart:convert';
import 'package:app_kejaksaan/const.dart';
import 'package:app_kejaksaan/main.dart';
import 'package:app_kejaksaan/screens/jaksa_masuk_sekolah/list_jms_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JMSScreen extends StatefulWidget {
  const JMSScreen({Key? key}) : super(key: key);

  @override
  State<JMSScreen> createState() => _JMSScreenState();
}

class _JMSScreenState extends State<JMSScreen> {
  final TextEditingController _sekolahController = TextEditingController();
  final TextEditingController _namaPemohonController = TextEditingController();

  String? id;
  bool isLoading = false;
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
  }

    Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      print(id);
    });
  }

  Future<void> _simpanData() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (_sekolahController.text.isNotEmpty && _namaPemohonController.text.isNotEmpty) {
        var request = http.MultipartRequest('POST', Uri.parse('$url/create_jms.php'));
        request.fields['sekolah'] = _sekolahController.text;
        request.fields['nama'] = _namaPemohonController.text;
        request.fields['status'] = 'pending';
        request.fields['id_user'] = id!; // Ganti dengan nilai id_user yang sesuai

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(responseString);
          if (responseData['isSuccess']) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
            _sekolahController.clear();
            _namaPemohonController.clear();
              Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ListJMSScreen()),
              (route) => false,
          );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save data')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in both fields')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _sekolahController,
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
                  TextField(
                    controller: _namaPemohonController,
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
                      onPressed: _simpanData,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
          ],
        ),
      ),
    );
  }
}
