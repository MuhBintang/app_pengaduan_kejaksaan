import 'dart:convert';
import 'dart:io';

import 'package:app_kejaksaan/const.dart';
import 'package:app_kejaksaan/models/model_createPegawai.dart';
import 'package:app_kejaksaan/models/model_pengaduan.dart';
import 'package:app_kejaksaan/screens/penyuluhan_hukum/list_p_hukum_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditPenyuluhanHukumScreen extends StatefulWidget {
  final Datum? data;
  const EditPenyuluhanHukumScreen({this.data ,super.key});

  @override
  State<EditPenyuluhanHukumScreen> createState() => _EditPenyuluhanHukumScreenState();
}

class _EditPenyuluhanHukumScreenState extends State<EditPenyuluhanHukumScreen> {
  File? _ktpFilePath;
  File? _laporanFilePath;
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _laporanController = TextEditingController();

  String? id;
  bool isLoading = false;
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
    getPengaduanData();
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      print(id);
    });
  }

  Future<void> getPengaduanData() async {
    try {
      final response = await http.get(Uri.parse('$url/getPengaduan.php?id=${widget.data}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null) {
          setState(() {
            _namaController.text = data['nama'] ?? '';
            _noHpController.text = data['no_hp'] ?? '';
            _nikController.text = data['nik'] ?? '';
            _laporanController.text = data['laporan_pengaduan'] ?? '';
            // You might need to handle file paths for _ktpFilePath and _laporanFilePath differently
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load data')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _pickFile(bool isKtp) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          if (isKtp) {
            _ktpFilePath = File(result.files.single.path!);
          } else {
            _laporanFilePath = File(result.files.single.path!);
          }
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No file selected')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> editPengaduan() async {
    try {
      setState(() {
        isLoading = true;
      });

      var request = http.MultipartRequest('POST', Uri.parse('$url/edit_pengaduanPegawai.php'));
      request.fields['id'] = widget.data!.id.toString();
      request.fields['nama'] = _namaController.text;
      request.fields['no_hp'] = _noHpController.text;
      request.fields['nik'] = _nikController.text;
      request.fields['laporan_pengaduan'] = _laporanController.text;
      request.fields['id_user'] = id!;
      request.fields['kategori'] = "penyuluhan hukum";

      if (_ktpFilePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto_ktp',
          _ktpFilePath!.path,
          filename: _ktpFilePath!.path.split('/').last,
        ));
      }

      if (_laporanFilePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto_laporan',
          _laporanFilePath!.path,
          filename: _laporanFilePath!.path.split('/').last,
        ));
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        ModelCreatePengaduanPegawai data = modelCreatePengaduanPegawaiFromJson(responseString);
        if (data.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data.message}')));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ListPenyuluhanHukum()),
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
            Form(
              key: keyForm,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Card(
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 12),
                      child: Text(
                        "Edit Pengaduan Pegawai",
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
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Pelapor',
                      hintText: 'Masukkan nama pelapor',
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
                    controller: _noHpController,
                    decoration: InputDecoration(
                      labelText: 'No HP',
                      hintText: 'Masukkan nomor HP',
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
                    controller: _nikController,
                    decoration: InputDecoration(
                      labelText: 'KTP',
                      hintText: 'Masukkan nomor KTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _pickFile(true);
                    },
                    child: Text('Upload File KTP'),
                  ),
                  if (_ktpFilePath != null)
                    Text(
                      _ktpFilePath != null
                          ? _ktpFilePath!.path.split('/').last
                          : 'Upload Foto KTP (PDF)',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _laporanController,
                    decoration: InputDecoration(
                      labelText: 'Laporan Penyuluhan',
                      hintText: 'Tulis laporan penyuluhan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _pickFile(false);
                    },
                    child: Text('Upload PDF Laporan'),
                  ),
                  if (_laporanFilePath != null)
                    Text(
                      _laporanFilePath != null
                          ? _laporanFilePath!.path.split('/').last
                          : 'Upload Foto Laporan (PDF)',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (keyForm.currentState?.validate() == true) {
                          editPengaduan();
                        }
                      },
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