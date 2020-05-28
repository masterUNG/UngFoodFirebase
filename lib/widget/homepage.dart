import 'package:flutter/material.dart';
import 'package:ungfoodfirebase/widget/login.dart';
import 'package:ungfoodfirebase/widget/register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHead(),
            loginMenu(),
            registerMenu(),
          ],
        ),
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
        accountName: Text('Name'), accountEmail: Text('Email'));
  }

  ListTile registerMenu() {
    return ListTile(
      leading: Icon(Icons.perm_identity),
      title: Text('สมัครสมาชิก'),
      subtitle: Text('สำหรับ สมัครสมาชิก ใหม่'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
          builder: (context) => Register(),
        );
        Navigator.push(context, materialPageRoute);
      },
    );
  }

  ListTile loginMenu() {
    return ListTile(
      leading: Icon(Icons.account_box),
      title: Text('ลงชื่อเข้าใช้งาน'),
      subtitle: Text('สำหรับ ลงชื่อ เข้าใช้งาน'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
          builder: (context) => Login(),
        );
        Navigator.push(context, materialPageRoute);
      },
    );
  }
}
