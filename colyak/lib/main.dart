import 'package:colyak/controllers/addmeal_controller.dart';
import 'package:colyak/models/auth_model.dart';
import 'package:colyak/models/authgard_model.dart';
import 'package:colyak/utils/colors.dart';
import 'package:colyak/views/screens/loginpage.dart';
import 'package:colyak/views/screens/profilepage.dart';
import 'package:colyak/views/screens/signuppage.dart';
import 'package:colyak/views/screens/verifyemailpage.dart';
import 'package:colyak/views/widgets/bottomnavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthModel()),
        ChangeNotifierProvider(create: (_) => AddMealListController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colyak App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'NotoSans',
          primaryColor: AppColors.bgColor,
          appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontFamily: 'NotoSans'),
              color: AppColors.mainColor)
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => AuthGuard(child: MyHomePage()),
        '/profile': (context) => AuthGuard(child: ProfilePage()),
        '/verify-email': (context) => VerifyEmailPage(verificationId: ''),
      },
      home: FutureBuilder(
        future: _checkSavedTokens(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.data == true) {
            return MyHomePage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }

  Future<bool> _checkSavedTokens(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final refreshToken = prefs.getString('refreshToken');
    final email = prefs.getString('email');
    final userName = prefs.getString('userName');

    if (token != null && refreshToken != null && email != null &&
        userName != null) {
      Provider.of<AuthModel>(context, listen: false).setToken(
          token, refreshToken, email, userName);
      return true;
    } else {
      return false;
    }
  }
}
