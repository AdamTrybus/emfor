import 'package:flutter/material.dart';
import 'package:new_emfor/screens/questions_detail_screen.dart';
import 'package:new_emfor/screens/questions_screen.dart';
import 'package:new_emfor/widgets/depute/depute_timeline.dart';
import 'package:new_emfor/widgets/network_video.dart';
import 'package:new_emfor/widgets/support/problem_window.dart';
import 'package:new_emfor/widgets/rating_dialog.dart';
import 'package:new_emfor/widgets/support/report_problem.dart';
import './providers/deputes.dart';
import './screens/auth_screen.dart';
import './screens/support_screen.dart';
import './widgets/chat/confirm_window.dart';
import './widgets/chat/guarantee_window.dart';
import './widgets/depute/depute_detail_info.dart';
import './widgets/depute/renegotiate_window.dart';
import './widgets/depute/side_window.dart';
import './widgets/image_view.dart';
import './providers/read.dart';
import './screens/depute_detail_screen.dart';
import './screens/depute_screen.dart';
import './screens/phone_verification.dart';
import './providers/notices.dart';
import './screens/category_screen.dart';
import './screens/chat_detail_screen.dart';
import './screens/notice_detail_screen.dart';
import './screens/notice_screen.dart';
import './screens/overview_screen.dart';
import './widgets/change_profile.dart';
import './screens/subcategory_screen.dart';
import './screens/profile_screen.dart';
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
        ChangeNotifierProvider.value(
          value: Read(),
        ),
        ChangeNotifierProvider.value(
          value: Deputes(),
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
                color: Colors.white,
                elevation: 2,
                textTheme: TextTheme(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Colors.black,
                    fontSize: 24,
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
                  color: Colors.black,
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
                    ? OverviewScreen(snapshot.data.getBool("expert"))
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
          DeputeScreen.routeName: (ctx) => DeputeScreen(),
          NoticeDetailScreen.routeName: (ctx) => NoticeDetailScreen(),
          DeputeDetailScreen.routeName: (ctx) => DeputeDetailScreen(),
          ChatScreenDetail.routeName: (ctx) => ChatScreenDetail(),
          ChangeProfile.routeName: (ctx) => ChangeProfile(),
          PhoneVerification.routeName: (ctx) => PhoneVerification(),
          GuaranteeWindow.routeName: (ctx) => GuaranteeWindow(),
          ConfirmWindow.routeName: (ctx) => ConfirmWindow(),
          DeputeDetailInfo.routeName: (ctx) => DeputeDetailInfo(),
          RenegotiateWindow.routeName: (ctx) => RenegotiateWindow(),
          SideWindow.routeName: (ctx) => SideWindow(),
          SupportScreen.routeName: (ctx) => SupportScreen(),
          ImageView.routeName: (ctx) => ImageView(),
          QuestionsScreen.routeName: (ctx) => QuestionsScreen(),
          QuestionsDetailScreen.routeName: (ctx) => QuestionsDetailScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          RatingDialog.routeName: (ctx) => RatingDialog(),
          DeputeTimeline.routeName: (ctx) => DeputeTimeline(),
          ProblemWindow.routeName: (ctx) => ProblemWindow(),
          ReportProblem.routeName: (ctx) => ReportProblem(),
          NetworkVideo.routeName: (ctx) => NetworkVideo(),
        },
      ),
    );
  }
}
