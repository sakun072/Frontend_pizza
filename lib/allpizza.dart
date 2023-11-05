import 'package:flutter/material.dart';
import 'package:pizza/api.dart';
import 'package:pizza/editFood.dart';
import 'package:pizza/foodModel.dart';
import 'package:pizza/main.dart';

class Allpizza extends StatefulWidget {
  const Allpizza({Key? key}) : super(key: key);

  @override
  _AllpizzaState createState() => _AllpizzaState();
}

class _AllpizzaState extends State<Allpizza> {
  @override
  void initState() {
    setState(() {
      // CallApi().getPizzaData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('รายการอาหาร'),
        backgroundColor: Color(0xffff7f50),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add), tooltip: 'สร้าง', onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditFood(
                        food: new Food(name: "", image: ""),
                        status: "create")));
          }),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'ออกจากระบบ',
            onPressed: onClickLogOut,
          )
        ],
      ),
      body: Container(
        child: FutureBuilder(
            future: CallApi().getFoodData(),
            builder: ((context, snapshot) {
              if (snapshot.hasData == false) {
                return Text("...Loading");
              }

              final food = snapshot.data;
              // return Column(
              //   children: [
              //     ...pizza!.map((e) => Text(e.name))
              //   ],
              // );
              return ListView.builder(
                  itemCount: food!.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3, // 20%
                            child: Image.network(
                              food![index].image!,
                              height: 130,
                              width: 130,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Image.network("https://cdn2.vectorstock.com/i/1000x1000/13/96/gloomy-face-slice-pizza-cartoon-with-404-boards-vector-35431396.jpg");
                              }
                            ),
                          ),
                          Expanded(
                            flex: 5, // 60%
                            child: Text(food![index].name!),
                          ),
                          Expanded(
                            flex: 1, // 20%
                            child: Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  tooltip: 'ดู',
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditFood(
                                                food: food![index],
                                                status: "view")));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'แก้ไข',
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditFood(
                                                food: food![index],
                                                status: "edit")));
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }));
            })),
      ),
    );
  }

  void onClickLogOut() async {
    var logout = await CallApi().logout();
    if (logout.apiStatus == "200") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ออกจากระบบ')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ขออภัย ! ไม่พบข้อมูล')),
      );
    }
  }
}
