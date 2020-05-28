import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ungfoodfirebase/models/shop_model.dart';

class UserService extends StatefulWidget {
  @override
  _UserServiceState createState() => _UserServiceState();
}

class _UserServiceState extends State<UserService> {
  List<ShopModel> shopModels = List();
  List<Widget> shopWidgets = List();

  @override
  void initState() {
    super.initState();
    readAllShop();
  }

  Future<Null> readAllShop() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('User');
    await collectionReference
        .document('ShopType')
        .collection('User')
        .snapshots()
        .listen((event) {
      for (var map in event.documents) {
        ShopModel shopModel = ShopModel.fromJson(map.data);
        print('Name ==>> ${shopModel.name}');
        setState(() {
          shopModels.add(shopModel);
          shopWidgets.add(createCart(shopModel));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Service'),
      ),
      body: shopModels.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : showAllShop(),
    );
  }

  Widget createCart(ShopModel shopModel) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            width: 100.0,
            height: 100.0,
            child: Image.network(shopModel.urlPrice),
          ),
          Text(shopModel.name),
        ],
      ),
    );
  }

  Widget showAllShop() => GridView.extent(
        maxCrossAxisExtent: 180.0,
        children: shopWidgets,
      );
}
