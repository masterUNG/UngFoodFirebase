import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:ungfoodfirebase/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String typeUser, name, email, password, urlAvatar, uidUser;
  double lat, lng;
  File file;

  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat = $lat, lng = $lng');
    });
  }

  Future<LocationData> findLocationData() async {
    try {
      Location location = Location();
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: ListView(
        children: <Widget>[
          imageGroup(),
          nameForm(),
          emailForm(),
          passwordForm(),
          chooseType(),
          lat == null ? CircularProgressIndicator() : showMap(),
          registerButton(),
        ],
      ),
    );
  }

  Widget registerButton() => RaisedButton(
        onPressed: () {
          print(
              'name = $name, email = $email, password = $password, typeUser = $typeUser');
          if (file == null) {
            normalDialog(context, 'ยังไม่่ได้เลือกรูปภาพเลย');
          } else if (name == null ||
              name.isEmpty ||
              email == null ||
              email.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'กรุณา กรอกให้ครบทุกช่อง คะ');
          } else if (typeUser == null) {
            normalDialog(context, 'กรุณา เลือกชนิดของ User ด้วย คะ');
          } else {
            uploadPictureToFirebase();
          }
        },
        child: Text('สมัครสมาชิก'),
      );

  Future<Null> uploadPictureToFirebase() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'avatar$i.jpg';

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Avatar/$nameFile');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);

    await (await storageUploadTask.onComplete)
        .ref
        .getDownloadURL()
        .then((value) {
      urlAvatar = value;
      print('######################urlAvatar = $urlAvatar################');
      authenThread();
    });
  }

  Future<Null> authenThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      uidUser = value.user.uid;
      print('Authen Success uidUser ====>>> $uidUser');
      addValueToFirestore();
    }).catchError((value) {
      String string = value.message;
      normalDialog(context, string);
    });
  }

  Future<Null> addValueToFirestore() async {
    Firestore firestore = Firestore.instance;

    Map<String, dynamic> map = Map();
    map['Lat'] = lat;
    map['Lng'] = lng;
    map['Name'] = name;
    map['Uid'] = uidUser;
    map['UrlPrice'] = urlAvatar;

    Map<String, dynamic> map2 = Map();
    map2['Name'] = name;
    map2['TypeUser'] = typeUser;

    CollectionReference collectionReference = firestore.collection('User');
    await collectionReference
        .document(typeUser)
        .collection('User')
        .document(uidUser)
        .setData(map);
        // .then((value) {});

    await collectionReference
        .document('AllMember')
        .collection('Member')
        .document(uidUser)
        .setData(map2).then((value) => Navigator.pop(context));
  }

  Set<Marker> myMarkers() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myID'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: 'ร้านอยู่ที่นี่',
          snippet: 'lat = $lat, lng = $lng',
        ),
      ),
    ].toSet();
  }

  Widget showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Container(
      color: Colors.grey,
      height: MediaQuery.of(context).size.height * 0.5,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: myMarkers(),
      ),
    );
  }

  Column chooseType() => Column(
        children: <Widget>[
          userRadio(),
          shopRadio(),
          riderRadio(),
        ],
      );

  Widget userRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0),
          width: 100.0,
          child: Row(
            children: <Widget>[
              Radio(
                value: 'UserType',
                groupValue: typeUser,
                onChanged: (value) {
                  setState(() {
                    typeUser = value;
                  });
                },
              ),
              Text('ผู้ซื้อ')
            ],
          ),
        ),
      ],
    );
  }

  Widget shopRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 100.0,
          child: Row(
            children: <Widget>[
              Radio(
                value: 'ShopType',
                groupValue: typeUser,
                onChanged: (value) {
                  setState(() {
                    typeUser = value;
                  });
                },
              ),
              Text('ร้านค้า')
            ],
          ),
        ),
      ],
    );
  }

  Widget riderRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 100.0,
          child: Row(
            children: <Widget>[
              Radio(
                value: 'RiderType',
                groupValue: typeUser,
                onChanged: (value) {
                  setState(() {
                    typeUser = value;
                  });
                },
              ),
              Text('ผู้ส่ง')
            ],
          ),
        ),
      ],
    );
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              onChanged: (value) => name = value.trim(),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_box),
                labelText: 'Name :',
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

  Row imageGroup() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            child: file == null
                ? Image.asset('images/avatar.png')
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
          )
        ],
      );

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = object;
      });
    } catch (e) {}
  }
}
