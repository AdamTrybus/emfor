import 'package:flutter/material.dart';
import 'package:new_emfor/providers/notices.dart';
import 'package:new_emfor/screens/category_screen.dart';
import 'package:new_emfor/screens/chat_detail_screen.dart';
import 'package:new_emfor/screens/my_notices_detail_screen.dart';
import 'package:new_emfor/screens/notice_detail_screen.dart';
import 'package:new_emfor/screens/notice_screen.dart';
import 'package:new_emfor/screens/overview_screen.dart';
import 'package:new_emfor/widgets/change_profile.dart';
import './screens/auth_screen.dart';
import './screens/subcategory_screen.dart';
import './widgets/code_input.dart';
import './widgets/personal_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './providers/work.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Work(),
        ),
        ChangeNotifierProvider.value(
          value: Notices(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          backgroundColor: Colors.amber[300],
          accentColor: Colors.amberAccent,
          accentColorBrightness: Brightness.dark,
          // buttonTheme: ButtonTheme.of(context).copyWith(
          //   minWidth: 200,
          //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //   buttonColor: Colors.amber[500],
          //   textTheme: ButtonTextTheme.normal,
          //   // shape: OutlineInputBorder(
          //   //   borderRadius: BorderRadius.circular(26),
          //   //   borderSide: BorderSide(width: 1, color: Colors.amber[500]),
          //   // ),
          // ),
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                button: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                headline: TextStyle(
                  fontFamily: 'OpenSans',
                  color: Colors.deepPurple[800],
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                subhead: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Lato"),
                body1: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[700],
                ),
              ),
        ),
        home: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (BuildContext context,
              AsyncSnapshot<SharedPreferences> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                return snapshot.data.getString("phone") != null
                    ? OverviewScreen()
                    : AuthScreen();
            }
          },
        ),
        routes: {
          CategoryScreen.routeName: (ctx) => CategoryScreen(),
          SubcategoryScreen.routeName: (ctx) => SubcategoryScreen(),
          PersonalInfo.routeName: (ctx) => PersonalInfo(),
          CodeInput.routeName: (ctx) => CodeInput(),
          NoticeScreen.routeName: (ctx) => NoticeScreen(),
          NoticeDetailScreen.routeName: (ctx) => NoticeDetailScreen(),
          MyNoticesDetailScreen.routeName: (ctx) => MyNoticesDetailScreen(),
          ChatScreenDetail.routeName: (ctx) => ChatScreenDetail(),
          ChangeProfile.routeName: (ctx) => ChangeProfile(),
        },
      ),
    );
  }
}
