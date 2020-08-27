import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/screens/chat/expert_chat.dart';
import 'package:new_emfor/screens/depute_detail_screen.dart';
import 'package:new_emfor/screens/depute_screen.dart';
import 'package:new_emfor/screens/chat_detail_screen.dart';
import 'package:new_emfor/screens/support_screen.dart';
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
        'page': DeputeScreen(),
        'title': 'Ustawienia',
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

  void navigateToScreen(msg) {
    print("msg $msg");
    print("data ${msg["data"]}");
    var respository = msg["data"]["respository"] as String;
    var id = msg["data"]["chatId"] as String;
    if (respository == "chat") {
      Navigator.of(context)
          .pushNamed(ChatScreenDetail.routeName, arguments: id);
    } else if (respository == "depute") {
      Navigator.of(context)
          .pushNamed(DeputeDetailScreen.routeName, arguments: id);
    } else if (respository == "support") {
      Navigator.of(context).pushNamed(SupportScreen.routeName,
          arguments: {"supportId": id, "problem": true});
    }
  }

  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print("msg $msg");
      print("data ${msg["data"]}");
      return;
    }, onLaunch: (msg) {
      navigateToScreen(msg);
    }, onResume: (msg) {
      navigateToScreen(msg);
    });
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
              Icons.event_available,
            ),
            title: FittedBox(
              child: Text(
                "Zatwierdzone",
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
