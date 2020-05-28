import 'package:flutter/material.dart';

class AddFoodMenu extends StatefulWidget {
  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่ม เมนูอาหาร'),),
    );
  }
}