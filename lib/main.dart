import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pizza/allpizza.dart';
import 'package:pizza/api.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
    const Home({super.key});

    @override
    Widget build(BuildContext context) {
    return const MaterialApp(
    home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เข้าสู่ระบบ"),
        backgroundColor: Color(0xffff7f50),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Card(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                height: 400,
                child: Column(
                  children: [
                    Image(
                        height: 100,
                        width: 100,
                        image: AssetImage("assets/images/logo.png")),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "กรุณากรอกข้อมูล";
                        }
                        return null;
                      },
                      decoration: InputDecoration(label: Text("ชื่อผู้ใช้")),
                      controller: _username,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "กรุณากรอกข้อมูล";
                        }
                        return null;
                      },
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(label: Text("รหัสผ่าน")),
                    ),
                    ElevatedButton(
                        onPressed: onClickLogin, child: Text("เข้าสู่ระบบ"))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onClickLogin() async {
    if (_formKey.currentState!.validate()) {
      var login = await CallApi().login(_username.text, _password.text);
      if (login.apiStatus == "200") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Allpizza()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ขออภัย ! ไม่พบข้2อมูล')),
        );
      }
    }
  }
}
