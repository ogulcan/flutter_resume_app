import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExperiencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage>
    with AutomaticKeepAliveClientMixin<ExperiencePage> {
  var experiences = [];

  @override
  void initState() {
    super.initState();
    getTabData();
  }

  Future<void> getTabData() async {
    FirebaseFirestore.instance
        .collection('tabs')
        .doc('experience')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      experiences = documentSnapshot.get("active") as List;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    //experiences.forEach((element) {});

    return Scaffold(
        body: Container(
            margin: EdgeInsets.all(10),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: ListView.builder(
                    itemCount: experiences.length,
                    itemBuilder: (context, index) {
                      return ExperienceItem(index, experiences[index]);
                    },
                  ))
                ])));
  }

  @override
  bool get wantKeepAlive => true;
}

class ExperienceItem extends StatelessWidget {
  var index;
  var data;

  ExperienceItem(this.index, this.data);

  @override
  Widget build(BuildContext context) {
    double paddingTop = (index == 0) ? 10 : 0;

    return Container(
        padding: EdgeInsets.all(0),
        width: double.infinity,
        height: 150,
        child: Card(
            color: Colors.transparent,
            margin: EdgeInsets.all(0),
            elevation: 0,
            child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(25, paddingTop, 0, 0),
                        height: double.infinity,
                        width: 0.2,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('lib/assets/me_sq.png'),
                                radius: 23)),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SDK Developer",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          "Company A ahs asda sd aa ds hasdsadsad",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                        Text(
                          "Description Description Description Description Description Description Description Description",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ))
                ]))));
  }
}
