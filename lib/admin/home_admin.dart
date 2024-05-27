import 'package:app_kejaksaan/admin/screen/list_admin.dart';
import 'package:app_kejaksaan/screens/home_screen.dart';
import 'package:app_kejaksaan/screens/jaksa_masuk_sekolah/list_jms_screen.dart';
import 'package:app_kejaksaan/screens/pengaduan_korupsi/list_korupsi_screen.dart';
import 'package:app_kejaksaan/screens/pengaduan_pegawai/list_pengaduanPegawai.dart';
import 'package:app_kejaksaan/screens/pengawasan_aliran_agama/list_p_agama_screen.dart';
import 'package:app_kejaksaan/screens/penyuluhan_hukum/list_p_hukum_screen.dart';
import 'package:app_kejaksaan/screens/posko_pilkada/list_posko_pilkada_screen.dart';
import 'package:app_kejaksaan/screens/profil_screen/profil_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  top: 70,  // Atur jarak dari atas sesuai kebutuhan
                  child: Image.asset(
                    'images/logo.png',
                    width: 100,  // Berikan lebar yang sesuai
                    height: 100, // Berikan tinggi yang sesuai
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
                    "Selamat Datang Admin",
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
                  _buildGridButton(context, Icons.person, "Pengaduan Pegawai", ListPengaduanAdminScreen()),
                  _buildGridButton(context, Icons.supervised_user_circle, "Pengawasan Agama", ListPengawasanAgamaScreen()),
                  _buildGridButton(context, Icons.book, "Penyuluhan Hukum", ListPenyuluhanHukum()),
                  _buildGridButton(context, Icons.how_to_vote, "Posko Pilkada", ListPoskoPilkadaScreen()),
                ],
              ),
            ),
          ],
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

class BottomNavigationPageAdmin extends StatefulWidget {
  const BottomNavigationPageAdmin({super.key});

  @override
  State<BottomNavigationPageAdmin> createState() => _BottomNavigationPageAdminState();
}

class _BottomNavigationPageAdminState extends State<BottomNavigationPageAdmin>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
        selectedIndex = tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: [
          HomeAdminScreen(), 
          ProfilScreen()
        ],
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: Colors.grey,
        waterDropColor: Colors.grey.shade100,
        onItemSelected: (index) {
          tabController.animateTo(index);
        },
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            filledIcon: Icons.home_rounded,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.person_2_rounded,
            outlinedIcon: Icons.person_2_outlined,
          ),
        ],
      ),
    );
  }
}