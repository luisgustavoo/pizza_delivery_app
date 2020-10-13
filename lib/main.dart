import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/app/modules/auth/view/login_page.dart';
import 'package:pizza_delivery_app/app/modules/home/view/home_page.dart';
import 'package:pizza_delivery_app/app/modules/splahs/view/splash_page.dart';

import 'app/modules/auth/view/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0XFF9D0000),
        primarySwatch: Colors.red,
      ),
      initialRoute: SplashPage.router,
      routes: {
        SplashPage.router: (_) => SplashPage(),
        LoginPage.router: (_) => LoginPage(),
        RegisterPage.router: (_) => RegisterPage(),
        HomePage.router: (_) => HomePage(),
      },
    );
  }
}
