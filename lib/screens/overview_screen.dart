import 'package:flutter/material.dart';
import 'package:new_emfor/screens/chat/expert_chat.dart';
import '../screens/chat/principal_chat.dart';
import '../screens/home_screen.dart';
import '../screens/notice_screen.dart';
import '../screens/settings_screen.dart';

class OverviewScreen extends StatefulWidget {
  final bool isExpert;
  OverviewScreen(this.isExpert);
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int selectedIndex = 1;
  List<Map<String, Object>> pages(bool isExpert) {
    return [
      {
        'page': !widget.isExpert ? PrincipalChat() : ExpertChat(),
        'title': 'Czat',
      },
      !isExpert
          ? {
              'page': HomeScreen(),
              'title': 'Dodaj Ogłoszenie',
            }
          : {
              'page': NoticeScreen(),
              'title': 'Ogłoszenia',
            },
      {
        'page': SettingsScreen(),
        'title': 'Ustawienia',
      },
    ];
  }

  void setIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages(widget.isExpert)[selectedIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
        onTap: setIndex,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.blueGrey[300],
        currentIndex: selectedIndex,
        iconSize: 40,
        elevation: 8,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedLabelStyle: Theme.of(context).textTheme.subtitle,
        selectedLabelStyle: Theme.of(context).textTheme.subtitle,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
            ),
            title: FittedBox(
              child: Text(
                "Czat",
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              !widget.isExpert ? Icons.add_circle_outline : Icons.event_note,
            ),
            title: FittedBox(
              child: Text(
                !widget.isExpert ? "Dodaj" : "Ogłoszenia",
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
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
