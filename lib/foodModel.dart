// To parse this JSON data, do
//
//     final food = foodFromJson(jsonString);

import 'dart:convert';

List<Food> foodFromJsonList(String str) => List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));
Food foodFromJson(String str) => Food.fromJson(json.decode(str));

String foodToJson(List<Food> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Food {
  final int? fid;
  final String? name;
  final int? price;
  final String? image;
  final int? crid;
  final int? ftid;
  final int? sid;
  String? apiStatus;

  Food({
    this.fid,
    this.name,
    this.price,
    this.image,
    this.crid,
    this.ftid,
    this.sid,
    this.apiStatus,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    fid: json["fid"],
    name: json["name"],
    price: json["price"],
    image: json["image"],
    crid: json["crid"],
    ftid: json["ftid"],
    sid: json["sid"],
    apiStatus: json["apiStatus"],
  );

  Map<String, dynamic> toJson() => {
    "fid": fid,
    "name": name,
    "price": price,
    "image": image,
    "crid": crid,
    "ftid": ftid,
    "sid": sid,
    "apiStatus": apiStatus,
  };
}
