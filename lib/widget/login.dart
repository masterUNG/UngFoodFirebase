import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungfoodfirebase/utility/normal_dialog.dart';
import 'package:ungfoodfirebase/widget/rider_service.dart';
import 'package:ungfoodfirebase/widget/shop_service.dart';
import 'package:ungfoodfirebase/widget/user_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email, password;

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              onChanged: (value) => password = value.trim(),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget emailForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              onChanged: (value) => email = value.trim(),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Email :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: loginButton(),
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            emailForm(),
            passwordForm(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton loginButton() {
    return FloatingActionButton(
      child: Icon(Icons.navigate_next),
      onPressed: () {
        if (email == null ||
            email.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(context, 'Have Space');
        } else {
          checkAuthen();
        }
      },
    );
  }

  Future<Null> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      String uidLogin = value.user.uid;
      print('uidLogin ====>>> $uidLogin');
      findTypeUser(uidLogin);
    }).catchError((value) {
      String string = value.message;
      normalDialog(context, string);
    });
  }

  Future<Null> findTypeUser(String uidLogin) async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('User');
    await collectionReference
        .document('AllMember')
        .collection('Member')
        .document(uidLogin)
        .snapshots()
        .listen((event) {
      String typeUser = event.data['TypeUser'];
      print('########### typeUser ==>> $typeUser ###########');
      if (typeUser == 'UserType') {
        routeToService(UserService());
      } else if (typeUser == 'ShopType') {
        routeToService(ShopService());
      } else {
        routeToService(RiderService());
      }
    });
  }

  void routeToService(Widget widget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }
}
