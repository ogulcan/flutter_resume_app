import 'package:flutter/material.dart';

@immutable
class Loading extends StatelessWidget {
  ThemeData theme;

  Loading(this.theme);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: theme,
        debugShowCheckedModeBanner: false,
        title: 'Resume App',
        home: Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: new AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
          ),
        ));
  }
}
