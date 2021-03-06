import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with AutomaticKeepAliveClientMixin<AboutPage> {
  var head = "";
  var content = "";

  @override
  void initState() {
    super.initState();
    getTabData();
  }

  Future<void> getTabData() async {
    FirebaseFirestore.instance
        .collection('tabs')
        .doc('about')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      content = documentSnapshot.get('content');
      head = documentSnapshot.get('head');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 45,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: CircleAvatar(
                          backgroundImage: AssetImage('lib/assets/me_sq.png'),
                          radius: 40)),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(child: Text(head))
                ],
              )),
          Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Text(content),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
