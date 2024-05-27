import 'package:app_kejaksaan/models/model_jms.dart';
import 'package:flutter/material.dart';

class DetailJMSScreen extends StatelessWidget {
  final DatumJMS jms;

  const DetailJMSScreen({required this.jms});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Jaksa Masuk Sekolah'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${jms.status ?? ''}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.orange),
            ),
            SizedBox(height: 20),
            Text('Nama : ${jms.nama ?? ''}', style: TextStyle(fontSize: 20),),
            SizedBox(height: 20),
            Text('Sekolah : ${jms.sekolah ?? ''}', style: TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
