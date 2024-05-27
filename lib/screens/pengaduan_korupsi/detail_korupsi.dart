import 'package:app_kejaksaan/models/model_korupsi.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:app_kejaksaan/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class DetailKorupsiScreen extends StatelessWidget {
  final Datum korupsi;
  const DetailKorupsiScreen({required this.korupsi});

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
      appBar: AppBar(
        title: Text('Detail Pengaduan Pegawai'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${korupsi.status ?? ''}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.orange),),
            SizedBox(height: 20,),
            Text('Nama: ${korupsi.nama ?? ''}'),
            Text('Status: ${korupsi.status ?? ''}'),
            Text('Nik: ${korupsi.nik ?? ''}'),
            Text('Nomor HP: ${korupsi.noHp ?? ''}'),
            SizedBox(height: 10),
            Text('Laporan korupsi:'),
            Text('${korupsi.uraianLaporan ?? ''}'),
            SizedBox(height: 20),
            Text('Foto KTP:', style: TextStyle(fontWeight: FontWeight.bold)),
            FutureBuilder<String>(
              future: _downloadFile('$url/berkas/${korupsi.fotoKtp}'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 400,
                      child: PDFView(
                        filePath: snapshot.data,
                      ),
                    );
                  } else {
                    return Text('Gagal memuat gambar KTP');
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(height: 20),
            Text('Foto Laporan:', style: TextStyle(fontWeight: FontWeight.bold)),
            FutureBuilder<String>(
              future: _downloadFile('$url/berkas/${korupsi.fotoLaporan}'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 400,
                      child: PDFView(
                        filePath: snapshot.data,
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
          ],
        ),
      ),
    );
  }
}