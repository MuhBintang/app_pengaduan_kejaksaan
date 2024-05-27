import 'dart:io';

import 'package:app_kejaksaan/main.dart';
import 'package:app_kejaksaan/models/model_deleteKorupsi.dart';
import 'package:app_kejaksaan/models/model_korupsi.dart';
import 'package:app_kejaksaan/screens/pengaduan_korupsi/detail_korupsi.dart';
import 'package:app_kejaksaan/screens/pengaduan_korupsi/p_korupsi_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../const.dart';

class ListPengaduanKorupsiScreen extends StatefulWidget {
  final Datum? data;
  const ListPengaduanKorupsiScreen({this.data, super.key});

  @override
  State<ListPengaduanKorupsiScreen> createState() => _ListPengaduanKorupsiScreenState();
}

class _ListPengaduanKorupsiScreenState extends State<ListPengaduanKorupsiScreen> {
  TextEditingController txtcari = TextEditingController();
  bool isCari = false;
  bool isLoading = false;
  late List<Datum> _allPengaduan = [];
  late List<Datum> _searchResult = [];
  String? idUser;
  String? statusUser;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = prefs.getString("id");
      statusUser = prefs.getString("status");
    });
    getPengaduan();
  }

  Future<List<Datum>?> getPengaduan() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.get(Uri.parse('$url/getKorupsi.php?id_user=$idUser&status'));
      List<Datum> data = modelKorupsiFromJson(res.body).data ?? [];
      
      List<Datum> filteredData = data.where((datum) =>
          datum.status == "pending" ||
          datum.status == "approved" ||
          datum.status == "rejected"
      ).toList();
      
      setState(() {
        _allPengaduan = filteredData;
        _searchResult = filteredData;
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

  void _filterBerita(String query) {
    List<Datum> filteredBerita = _allPengaduan
      .where((pengaduan) => pengaduan.nama.toLowerCase().contains(query.toLowerCase()))
      .toList();
    setState(() {
      _searchResult = filteredBerita;
    });
  }

  Future<void> deletePengaduan(String id) async {
    try {
      setState(() {
        isLoading = true;
      });

      print("Mengirim permintaan hapus untuk id: $id");

      http.Response res = await http.delete(Uri.parse('$url/delete_pengaduanKorupsi.php?id=$id'));

      print("Respons dari server: ${res.statusCode}");
      print("Respons body: ${res.body}");

      if (res.statusCode == 200) {
        ModelDeleteKorupsi data = modelDeleteKorupsiFromJson(res.body);

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

  Future<String> _downloadFile(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String fileName = url.split('/').last;
    final File file = File('$tempPath/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
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
            MaterialPageRoute(builder: (context) => PengaduanKorupsiScreen()),
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
                      onChanged: _filterBerita,
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
                          Icons.people,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("List Pengaduan Korupsi"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator(color: Colors.green))
                        : ListView.builder(
                            itemCount: _searchResult.length,
                            itemBuilder: (context, index) {
                              Datum data = _searchResult[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailKorupsiScreen(korupsi: data),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<String>(
                                            future: _downloadFile('$url/berkas/${data.fotoLaporan}'),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.done) {
                                                if (snapshot.hasData) {
                                                  return Container(
                                                    height: 200,
                                                    child: PDFView(
                                                      filePath: snapshot.data,
                                                      enableSwipe: true,
                                                      swipeHorizontal: true,
                                                    ),
                                                  );
                                                } else {
                                                  return Text('Gagal memuat pratinjau PDF');
                                                }
                                              } else {
                                                return Center(child: CircularProgressIndicator());
                                              }
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "${data.nama}",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5),
                                          Text("${data.status}"),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                tooltip: "Hapus data",
                                                onPressed: () {
                                                  String idToDelete = _searchResult[index].id.toString();
                                                  deletePengaduan(idToDelete);
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
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             EditPengaduanPegawaiScreen(data))
                                                  //             );
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
                                                      builder: (context) => DetailKorupsiScreen(korupsi: data),
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