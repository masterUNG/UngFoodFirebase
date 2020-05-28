import 'package:flutter/material.dart';
import 'package:ungfoodfirebase/widget/add_food_menu.dart';

class ShopService extends StatefulWidget {
  @override
  _ShopServiceState createState() => _ShopServiceState();
}

class _ShopServiceState extends State<ShopService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Service'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => AddFoodMenu(),
              );
              Navigator.push(context, route);
            },
          )
        ],
      ),
    );
  }
}
