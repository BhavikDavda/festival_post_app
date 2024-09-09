
import 'package:festival_post_app/screens/detailpage.dart';
import 'package:festival_post_app/screens/home_page.dart';
import 'package:festival_post_app/screens/splash_screen.dart';
import 'package:festival_post_app/screens/startpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "poppins",
      ),
      initialRoute: "splash",
      routes: {
        '/': (context) => const GettingStarted(),
        'homePage': (context) => const HomePage(),
        'splash': (context) => const SplashScreen(),
        'detailPage': (context) => const DetailPage(),
      },
    ),
  );
}
