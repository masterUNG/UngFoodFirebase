import 'package:flutter/material.dart';
import 'package:ungfoodfirebase/widget/homepage.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      title: 'Ung Food Firebase',
    );
  }
}
