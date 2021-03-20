import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

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
            return MyApp();
          }

          return Loading();
        });
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Resume App',
        home: Scaffold(
          backgroundColor: Color(0xFFFCF7F8),
        ));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resume App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF4B7764),
        accentColor: Color(0xFFFFCC2C),
        backgroundColor: Color(0xFFFCF7F8),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double firstContainerOpacity = 0;
  double secondContainerOpacity = 0;
  var buttonText = "Detaylara Bak";
  var defaultFadeInDuration = Duration(milliseconds: 500);
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    showFirstContainer();
    showSecondContainer();
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    showFirstContainer();
    showSecondContainer();
  }

  Future<void> showFirstContainer() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    setState(() {
      firstContainerOpacity = 1;
    });
  }

  Future<void> showSecondContainer() async {
    await Future.delayed(Duration(milliseconds: 3500), () {});
    setState(() {
      secondContainerOpacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                print(doc.data()['name']);
              })
            });

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            AnimatedOpacity(
                opacity: firstContainerOpacity,
                duration: defaultFadeInDuration,
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      CircleAvatar(
                          radius: 95,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('lib/assets/me_sq.png'),
                              radius: 90)),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Merhaba.",
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800])),
                    ],
                  ),
                )),
            AnimatedOpacity(
              opacity: secondContainerOpacity,
              duration: defaultFadeInDuration,
              child: Container(
                width: double.infinity,
                child: Column(children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Ben Oğulcan Orhan,\nMobil uygulama geliştiricisiyim.",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[800]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                      child: Column(children: [
                        TextFormField(
                            decoration: InputDecoration(
                                isDense: false,
                                hintText: "Lütfen erişim kodunu girin",
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0, -12))),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                            minWidth: double.infinity,
                            height: 44,
                            child: Text("Detaylara Bak",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)),
                            onPressed: () => {},
                            color: Theme.of(context).primaryColor),
                        FlatButton(
                            minWidth: double.infinity,
                            height: 22,
                            child: Text("Ziyaretçi Olarak Giriş Yap",
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16)),
                            onPressed: () {
                              setState(() {
                                buttonText = "Detaylara baak";
                              });
                            },
                            color: Colors.transparent),
                      ]))
                ]),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
