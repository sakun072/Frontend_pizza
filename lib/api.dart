import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:pizza/foodModel.dart';
import 'package:pizza/userModel.dart';

class CallApi {
  int usersId = 0;

  Future<List<Food>> getFoodData() async {
    final url = Uri.parse("http://192.168.1.6/pizza/api/allFood.php");
    http.Response res = await http.get(url);
    if (res.statusCode == 200) {
      final foodList = foodFromJsonList(res.body);
      return foodList;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Users> login(String username, String password) async {
    final url = Uri.parse("http://192.168.1.6/pizza/api/login.php");
    http.Response res = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'password': password}),
    );
    if (res.statusCode == 200) {
      final users = usersFromJson(res.body);
      users.apiStatus = res.statusCode.toString();
      usersId = users.oid!;
      return users;
    } else {
      final users = usersFromJson(res.body);
      users.apiStatus = res.statusCode.toString();
      return users;
    }
  }

  Future<Users> logout() async {
    final users = Users();
    usersId = 0;
    users.apiStatus = "200";
    return users;
  }

  Future<Food> createFood(Food foodData) async {
    final url = Uri.parse("http://192.168.1.6/pizza/api/createFood.php");
    http.Response res = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': foodData.name!,
        'price': foodData.price.toString(),
        'image': foodData.image!,
        'ftid': foodData.ftid.toString(),
        'crid': foodData.crid.toString(),
        'sid': foodData.sid.toString(),
      }),
    );
    if (res.statusCode == 200) {
      final food = foodFromJson(res.body);
      food.apiStatus = res.statusCode.toString();
      return food;
    } else {
      final food = foodFromJson(res.body);
      food.apiStatus = res.statusCode.toString();
      return food;
    }
  }

  Future<Food> updateFood(Food foodData) async {
    final url = Uri.parse("http://192.168.1.6/pizza/api/updateFood.php");
    http.Response res = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fid': foodData.fid.toString(),
        'name': foodData.name!,
        'price': foodData.price.toString(),
        'image': foodData.image!,
        'ftid': foodData.ftid.toString(),
        'crid': foodData.crid.toString(),
        'sid': foodData.sid.toString(),
      }),
    );
    if (res.statusCode == 200) {
      final food = foodFromJson(res.body);
      food.apiStatus = res.statusCode.toString();
      return food;
    } else {
      final food = foodFromJson(res.body);
      food.apiStatus = res.statusCode.toString();
      return food;
    }
  }

  Future<Food> getFood(int fid) async {
    final url =
        Uri.parse("http://192.168.1.6/pizza/api/allFood.php?fid=$fid");
    http.Response res = await http.get(url);
    if (res.statusCode == 200) {
      final food = foodFromJson(res.body);
      return food;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
