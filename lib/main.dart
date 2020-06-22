import 'package:flutter/material.dart';
import 'package:new_emfor/providers/user.dart';
import 'package:new_emfor/screens/depute_detail_screen.dart';
import './screens/phone_verification.dart';
import './providers/notices.dart';
import './screens/category_screen.dart';
import './screens/chat_detail_screen.dart';
import './screens/notice_detail_screen.dart';
import './screens/notice_screen.dart';
import './screens/overview_screen.dart';
import './widgets/change_profile.dart';
import './screens/subcategory_screen.dart';
import './widgets/code_input.dart';
import './widgets/personal_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './providers/work.dart';
import 'package:provider/provider.dart';
import './screens/auth_screen.dart';

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
        ChangeNotifierProvider.value(
          value: User(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          backgroundColor: Colors.amber[300],
          accentColor: Colors.amberAccent,
          accentColorBrightness: Brightness.dark,
          appBarTheme: ThemeData.light().appBarTheme.copyWith(
                color: Colors.black,
                elevation: 2,
                textTheme: TextTheme(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                button: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                headline: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                subhead: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    fontFamily: "OpenSans"),
                body1: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                display1: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                overline: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
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
          DeputeDetailScreen.routeName: (ctx) => DeputeDetailScreen(),
          ChatScreenDetail.routeName: (ctx) => ChatScreenDetail(),
          ChangeProfile.routeName: (ctx) => ChangeProfile(),
          PhoneVerification.routeName: (ctx) => PhoneVerification(),
        },
      ),
    );
  }
}
