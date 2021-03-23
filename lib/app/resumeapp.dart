import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resume_app/home/homepage.dart';
import 'package:resume_app/launch/launchpage.dart';
import 'package:overlay_support/overlay_support.dart';

class ResumeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resume App',
      routes: {
        '/launch': (context) => LaunchPage(),
        '/home': (context) => HomePage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF4B7764),
        accentColor: Color(0xFFFFCC2C),
        backgroundColor: Color(0xFFFCF7F8),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      home: LaunchPage(),
    ));
  }
}
