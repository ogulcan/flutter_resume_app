import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchPage extends StatefulWidget {
  LaunchPage({Key key}) : super(key: key);

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  final ACCESS_CODE = "access_code";

  double firstContainerOpacity = 0;
  double secondContainerOpacity = 0;
  var accessCode = "";
  var buttonText = "Detaylara Bak";
  var defaultFadeInDuration = Duration(milliseconds: 500);

  Map<String, QueryDocumentSnapshot> accessCodes = {};
  TextEditingController accessEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAccessCodes();
    showFirstContainer();
  }

  @override
  void didUpdateWidget(LaunchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<String> getAccessCode() async {
    final prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString(ACCESS_CODE) ?? "");
  }

  void storeAccessCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ACCESS_CODE, code);
  }

  void removeAccessCode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(ACCESS_CODE);
  }

  // TODO: Handle error case
  Future<void> loadAccessCodes() async {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        accessCodes.putIfAbsent(doc.id, () => doc);
      });
    });
  }

  Future<void> showFirstContainer() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        firstContainerOpacity = 1;
      });
    });

    await Future.delayed(Duration(milliseconds: 1000), () {
      getAccessCode().then((code) {
        if (code.isEmpty) {
          showSecondContainer();
        } else if (checkAccessCode(code)) {
          goHomePage(true);
        } else {
          removeAccessCode();
          showNotification("Erişim kodunuz artık geçersiz", Colors.orange);
          showSecondContainer();
        }
      }).catchError((error) => print(error));
    });
  }

  Future<void> showSecondContainer() async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
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
                            onPressed: () => onButtonTap(),
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

  bool checkAccessCode(String code) {
    var expireTS = accessCodes[code].get('ts').seconds;
    var now = DateTime.now().millisecondsSinceEpoch / 1000;

    return (code.isEmpty == false &&
        accessCodes.keys.contains(code) &&
        now < expireTS);
  }

  void onButtonTap() {
    if (checkAccessCode(accessEditingController.text)) {
      storeAccessCode(accessEditingController.text);
      goHomePage(true);
    } else {
      showNotification("Geçersiz erişim kodu", Colors.red);
    }
  }

  void showNotification(String message, Color color) {
    showSimpleNotification(Text(message, style: TextStyle(color: Colors.white)),
        duration: Duration(milliseconds: 6000), background: color);
  }

  void goHomePage(bool hasAccess) {
    var arguments = hasAccess
        ? {
            "access": 1,
          }
        : {};
    //Navigator.pushNamed(context, '/home', arguments: arguments);
    Navigator.pushReplacementNamed(context, '/home', arguments: arguments);
  }
}
