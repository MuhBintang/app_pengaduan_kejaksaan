import 'package:app_kejaksaan/const.dart';
import 'package:app_kejaksaan/main.dart';
import 'package:app_kejaksaan/models/model_rating.dart';
import 'package:app_kejaksaan/screens/jaksa_masuk_sekolah/list_jms_screen.dart';
import 'package:app_kejaksaan/screens/pengaduan_korupsi/list_korupsi_screen.dart';
import 'package:app_kejaksaan/screens/pengaduan_pegawai/list_pengaduanPegawai.dart';
import 'package:app_kejaksaan/screens/pengawasan_aliran_agama/list_p_agama_screen.dart';
import 'package:app_kejaksaan/screens/penyuluhan_hukum/list_p_hukum_screen.dart';
import 'package:app_kejaksaan/screens/posko_pilkada/list_posko_pilkada_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0.0;
  String? id;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
      print(id);
    });
  }

  Future<void> _submitRating(double rating, String feedback) async {
  final String link = '$url/rating.php';  // Ganti dengan URL endpoint Anda
  try {
    var request = http.MultipartRequest('POST', Uri.parse(link));
    // request.fields['id'] = id!;
    request.fields['id_user'] = id!;
    request.fields['rating'] = rating.toString();
    request.fields['pesan'] = feedback;

    var response = await request.send();

    if (response.statusCode == 200) {
      // Handle successful submission
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Rating submitted successfully'),
      ));
    } else {
      // Handle unsuccessful submission
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit rating'),
      ));
    }
  } catch (e) {
    // Handle error
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error: $e'),
    ));
  }
}

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rating'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Beri Rate Aplikasi Kami'),
            SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Berikan Pesan Anda',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
                if (_rating > 0) {
                  await _submitRating(_rating, _feedbackController.text);
                  Navigator.of(context).pop(true);
                } else {
                  // Show a message if the user hasn't rated yet
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please provide a rating'),
                  ));
                }
              },
            child: Text('Submit'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
                    left: 0,
                    right: 0,
                    top: 70,
                    child: Image.asset(
                      'images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Card(
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Pusat Informasi Kejaksaan Tinggi Sumatera Barat",
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
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                  items: [
                    'images/gambar1.jpeg',
                    'images/gambar2.jpeg',
                    'images/gambar3.jpeg',
                    'images/gambar4.jpeg'
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                          ),
                          child: Image.asset(
                            i,
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  padding: EdgeInsets.all(10.0),
                  children: [
                    _buildGridButton(context, Icons.school, "JMS", ListJMSScreen()),
                    _buildGridButton(context, Icons.gavel, "Pengaduan Korupsi", ListPengaduanKorupsiScreen()),
                    _buildGridButton(context, Icons.person, "Pengaduan Pegawai", ListPengaduanPegawaiPage()),
                    _buildGridButton(context, Icons.supervised_user_circle, "Pengawasan Agama", ListPengawasanAgamaScreen()),
                    _buildGridButton(context, Icons.book, "Penyuluhan Hukum", ListPenyuluhanHukum()),
                    _buildGridButton(context, Icons.how_to_vote, "Posko Pilkada", ListPoskoPilkadaScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, IconData icon, String label, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white, // Background color
        onPrimary: Colors.black, // Text and icon color
        padding: EdgeInsets.all(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40.0, color: Colors.black), // Icon color
          SizedBox(height: 5.0),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0, color: Colors.black)), // Text color
        ],
      ),
    );
  }
}

