import 'package:app_kejaksaan/screens/home_screen.dart';
import 'package:app_kejaksaan/screens/profil_screen/profil_screen.dart';
import 'package:app_kejaksaan/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Kejaksaan',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage>
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
          HomeScreen(), 
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