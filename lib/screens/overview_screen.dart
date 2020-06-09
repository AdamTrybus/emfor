import 'package:flutter/material.dart';
import '../screens/my_notices_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notice_screen.dart';
import '../screens/settings_screen.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': HomeScreen(),
      'title': 'Dodaj Ogłoszenie',
    },
    {
      'page': NoticeScreen(),
      'title': 'Ogłoszenia',
    },
    {
      'page': MyNoticesScreen(),
      'title': 'Moje ogłoszenia',
    },
    {
      'page': SettingsScreen(),
      'title': 'Ustawienia',
    },
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black87,
        currentIndex: _selectedPageIndex,
        iconSize: 28,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,        
        unselectedLabelStyle: Theme.of(context).textTheme.subtitle,
        selectedLabelStyle: Theme.of(context).textTheme.subtitle,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_add,
            ),
            title: FittedBox(
              child: Text(
                "Dodaj Ogłoszenie",
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_note,
            ),
            title: FittedBox(
              child: Text(
                "Ogłoszenia",
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_available,
            ),
            title: FittedBox(
              child: Text(
                "Moje Ogłoszenia",
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_applications,
            ),
            title: FittedBox(
              child: Text(
                "Ustawienia",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
