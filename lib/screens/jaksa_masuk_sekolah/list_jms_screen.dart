import 'dart:io';
import 'package:app_kejaksaan/const.dart';
import 'package:app_kejaksaan/main.dart';
import 'package:app_kejaksaan/models/model_createJMS.dart';
import 'package:app_kejaksaan/models/model_deleteJMS.dart';
import 'package:app_kejaksaan/models/model_jms.dart';
import 'package:app_kejaksaan/screens/jaksa_masuk_sekolah/detailJMS_screen.dart';
import 'package:app_kejaksaan/screens/jaksa_masuk_sekolah/edit_jms_screen.dart';
import 'package:app_kejaksaan/screens/jaksa_masuk_sekolah/jms_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListJMSScreen extends StatefulWidget {
  final DatumJMS? data;
  const ListJMSScreen({this.data, super.key});

  @override
  State<ListJMSScreen> createState() => _ListJMSScreenState();
}

class _ListJMSScreenState extends State<ListJMSScreen> {
  TextEditingController txtcari = TextEditingController();
  bool isLoading = false;
  late List<DatumJMS> _allJMS = [];
  late List<DatumJMS> _searchResult = [];
  String? idUser;

  @override
  void initState() {
    getJMS();
    getUserId();
    super.initState();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = prefs.getString("id");
    });
    getJMS();
  }

  Future<List<DatumJMS>?> getJMS() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.get(Uri.parse('$url/getJms.php?id_user=$idUser'));
      List<DatumJMS> data = modelgetJmsFromJson(res.body).data ?? [];
      setState(() {
        _allJMS = data;
        _searchResult = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(e.toString()),
      //   ),
      // );
    }
  }

  void _filterJMS(String query) {
    List<DatumJMS> filteredJMS = _allJMS
        .where((jms) => jms.sekolah.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _searchResult = filteredJMS;
    });
  }

  Future<void> deleteJMS(String id) async {
  try {
    setState(() {
      isLoading = true;
    });

    print("Mengirim permintaan hapus untuk id: $id");

    http.Response res = await http.delete(Uri.parse('$url/delete_jms.php?id=$id'));

    print("Respons dari server: ${res.statusCode}");
    print("Respons body: ${res.body}");

    if (res.statusCode == 200) {
      ModelDeleteJms data = modelDeleteJmsFromJson(res.body);

      if (data.value == 1) {
        setState(() {
          _searchResult.removeWhere((pengaduan) => pengaduan.id == int.parse(id));
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${data.message}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${data.message}'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus Pengaduan'),
        ),
      );
    }
  } catch (e) {
    print("Terjadi kesalahan: $e");
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JMSScreen()),
          );
        },
        tooltip: "Tambah Pengaduan Pegawai",
        child: Icon(
          Icons.add,
          size: 25,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          PreferredSize(
            preferredSize: Size.fromHeight(60), // Set the preferred size accordingly
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavigationPage()),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: _filterJMS,
                      controller: txtcari,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.red,
                        hintText: "Search",
                        hintStyle: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("List Jaksa Masuk Sekolah"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator(color: Colors.green))
                        : ListView.builder(
                            itemCount: _searchResult.length,
                            itemBuilder: (context, index) {
                              DatumJMS data = _searchResult[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailJMSScreen(jms: data),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15), // Set border radius here
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 30,
                                                color: Colors.blue, // Set the color of the person icon here
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "${data.nama}",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          // Text("${data.sekolah}"),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                tooltip: "Hapus data",
                                                onPressed: () {
                                                  String idToDelete = _searchResult[index].id.toString();
                                                  deleteJMS(idToDelete);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: "Edit data",
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditJMSScreen(data))
                                                              );
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.yellow.shade800,
                                                  size: 20,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: "Lihat data",
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => DetailJMSScreen(jms: data),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.info_outline_rounded,
                                                  color: Colors.green,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}