import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:resume_app/home/homepage.dart';

class LaunchPage extends StatefulWidget {
  LaunchPage({Key key}) : super(key: key);

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  double firstContainerOpacity = 0;
  double secondContainerOpacity = 0;
  var buttonText = "Detaylara Bak";
  var defaultFadeInDuration = Duration(milliseconds: 500);
  Map<String, dynamic> accessCodes = {};
  TextEditingController accessEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAccessCodes();
    showFirstContainer();
    showSecondContainer();
  }

  @override
  void didUpdateWidget(LaunchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    showFirstContainer();
    showSecondContainer();
  }

  Future<void> loadAccessCodes() async {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        accessCodes.putIfAbsent(doc.id, () => {doc.data()});
      });

      accessCodes.forEach((key, value) {
        print(key);
        print(value);
      });
      //print(accessCodes.for);
    });
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
    return Scaffold(
      body: new GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Center(
            child: SingleChildScrollView(
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
                              controller: accessEditingController,
                              decoration: InputDecoration(
                                  isDense: false,
                                  hintText: "Lütfen erişim kodunu girin",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 0, 0, -12))),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              minimumSize: Size(double.infinity, 44),
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                            ),
                            child: Text("Detaylara Bak",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)),
                            onPressed: () => checkAccessCode(),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size(double.infinity, 22),
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                              child: Text("Ziyaretçi Olarak Giriş Yap",
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16)),
                              onPressed: () => goHomePage(false)),
                        ]))
                  ]),
                ),
              )
            ],
          ),
        )),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  void checkAccessCode() {
    if (accessEditingController.text.isEmpty == false &&
        accessCodes.keys.contains(accessEditingController.text)) {
      goHomePage(true);
    } else {
      showSimpleNotification(
          Text("Erişim kodu yanlış, lütfen kontrol edin",
              style: TextStyle(color: Colors.white)),
          duration: Duration(milliseconds: 6000),
          background: Colors.red);
    }
  }

  void goHomePage(bool hasAccess) {
    var arguments = hasAccess
        ? {
            "access": 1,
          }
        : {};
    Navigator.pushNamed(context, '/home', arguments: arguments);
  }
}
