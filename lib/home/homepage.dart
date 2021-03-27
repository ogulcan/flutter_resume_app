import 'package:flutter/material.dart';
import 'package:resume_app/home/about.dart';
import 'package:resume_app/home/experience.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var hasAccess = false;
  var tabs = [
    Tab(text: 'Hakkımda', icon: Icon(Icons.person_outline)),
    Tab(text: 'İş Geçmişi', icon: Icon(Icons.work_outline)),
    Tab(text: 'Projeler', icon: Icon(Icons.list_outlined)),
    Tab(text: 'Diğer', icon: Icon(Icons.book_outlined)),
  ];
  var views = [
    AboutPage(),
    ExperiencePage(),
    Icon(Icons.directions_bike),
    Icon(Icons.directions_bike),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    hasAccess = (ModalRoute.of(context).settings.arguments as Map)
        .containsKey("access");

    if (hasAccess == false) {
      tabs.remove(tabs.removeLast());
      views.remove(views.removeLast());
      setState(() {
        tabs:
        tabs;
        views:
        views;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: tabs,
          ),
          title: Text('Oğulcan'),
        ),
        body: TabBarView(
          children: views,
        ),
      ),
    );
  }
}
