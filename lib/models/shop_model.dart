class ShopModel {
  String name;
  String uid;
  String urlPrice;
  double lat;
  double lng;

  ShopModel({this.name, this.uid, this.urlPrice, this.lat, this.lng});

  ShopModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    uid = json['Uid'];
    urlPrice = json['UrlPrice'];
    lat = json['Lat'];
    lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Uid'] = this.uid;
    data['UrlPrice'] = this.urlPrice;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    return data;
  }
}

