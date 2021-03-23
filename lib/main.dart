import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:resume_app/app/resumeapp.dart';
import 'package:resume_app/launch/loading.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final themeData = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Color(0xFF4B7764),
    accentColor: Color(0xFFFFCC2C),
    backgroundColor: Color(0xFFFCF7F8),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: GoogleFonts.notoSans().fontFamily,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // TODO: Add error handling
            print(snapshot.error.toString());
          }

          print(snapshot.connectionState);

          if (snapshot.connectionState == ConnectionState.done) {
            return ResumeApp();
          }

          return Loading(themeData);
        });
  }
}
