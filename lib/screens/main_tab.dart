import 'package:abhicaresservice/screens/home/homepage_Screen.dart';
import 'package:abhicaresservice/screens/home/profile_screen.dart';
import 'package:flutter/material.dart';

class MainTabsScreen extends StatefulWidget {
  static const routeName = '/main-tab-screen ';
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  bool _init = true;
  final List<Widget> _pages = [
    const HomePageScreen(),
    const ProfileScreen(),
  ];

  int _selctedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selctedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageNo = ModalRoute.of(context)!.settings.arguments;
    if (pageNo != null && _init) {
      _selctedPageIndex = pageNo as int;
      _init = false;
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: _pages[_selctedPageIndex],
      bottomNavigationBar: Material(
        elevation: 100,
        child: BottomNavigationBar(
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.black,
          onTap: _selectPage,
          backgroundColor: Colors.white,
          currentIndex: _selctedPageIndex,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: 'Abhi Cares',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
