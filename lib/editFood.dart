import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pizza/allpizza.dart';
import 'package:pizza/api.dart';
import 'package:pizza/main.dart';
import 'package:pizza/foodModel.dart';

class EditFood extends StatefulWidget {
  final Food food;
  final String status;

  const EditFood({Key? key, required this.food, required this.status})
      : super(key: key);

  @override
  _EditFoodState createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  int dropdownValueCrust = 1;
  int dropdownValueSize = 1;
  int dropdownValueType = 1;
  var readOnlyStatus = false;
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _image = TextEditingController();

  @override
  void initState() {
    if (widget.status != "create") {
      _name.text = widget.food.name!;
      _price.text = widget.food.price.toString();
      _image.text = widget.food.image!;
      dropdownValueCrust = widget.food.crid!;
      dropdownValueType = widget.food.ftid!;
      dropdownValueSize = widget.food.sid!;
    }
    readOnlyStatus = widget.status == "view";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final foodData = widget.food;
    final foodId = foodData.fid;
    final textBar = widget.status != "create"
        ? foodId != null
            ? widget.status == "view" ? "ดูข้อมูล รหัส $foodId" :"แก้ไขข้อมูล รหัส $foodId"
            : "สร้าง"
        : "สร้าง";

    print(readOnlyStatus);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(textBar),
        backgroundColor: Color(0xffff7f50),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "กรุณากรอกข้อมูล";
                      }
                      return null;
                    },
                    controller: _name,
                    readOnly: readOnlyStatus,
                    decoration: InputDecoration(label: Text("ชื่อ")),
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "กรุณากรอกข้อมูล";
                      }
                      return null;
                    },
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+(?:\.\d+)?$')),
                    ],
                    controller: _price,
                    readOnly: readOnlyStatus,
                    decoration: InputDecoration(label: Text("ราคา")),
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "กรุณากรอกข้อมูล";
                      }
                      return null;
                    },
                    controller: _image,
                    readOnly: readOnlyStatus,
                    decoration: InputDecoration(label: Text("ลิ้งรูปภาพ")),
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(label: Text("ประเภท")),
                    value: dropdownValueType,
                    onChanged: !readOnlyStatus
                        ? (int? value) =>
                            setState(() => dropdownValueType = value!)
                        : null,
                    items: const [
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text("พิซซ่า"),
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child: Text("แฮมเบอร์เกอร์"),
                      ),
                      DropdownMenuItem<int>(
                        value: 3,
                        child: Text("เครื่องดื่ม"),
                      ),
                      DropdownMenuItem<int>(
                        value: 4,
                        child: Text("เฟรนฟราย"),
                      ),
                    ],
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(label: Text("ขนาด")),
                    value: dropdownValueSize,
                    onChanged: !readOnlyStatus
                        ? (int? value) =>
                            setState(() => dropdownValueSize = value!)
                        : null,
                    items: const [
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text("S"),
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child: Text("M"),
                      ),
                      DropdownMenuItem<int>(
                        value: 3,
                        child: Text("L"),
                      ),
                      DropdownMenuItem<int>(
                        value: 4,
                        child: Text("XL"),
                      ),
                    ],
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                        label: Text("ความหนาของแป้ง (เฉพาะพิซซ่า)")),
                    value: dropdownValueCrust,
                    onChanged: !readOnlyStatus
                        ? (int? value) =>
                            setState(() => dropdownValueCrust = value!)
                        : null,
                    items: const [
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text("บางกรอบ"),
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child: Text("หนานุ่ม"),
                      ),
                      DropdownMenuItem<int>(
                        value: 3,
                        child: Text("ขอบชีส"),
                      ),
                      DropdownMenuItem<int>(
                        value: 4,
                        child: Text("ไม่ระบุ"),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () => onClickSave(foodId == null ? 0 : foodId),
                      child: Text("บันทึก")),
                  ElevatedButton(
                      onPressed: readOnlyStatus
                          ? () => setState(() => readOnlyStatus = false)
                          : null,
                      child: Text("แก้ไข"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onClickSave(int id) async {
    if (_formKey.currentState!.validate()) {
      Food foodData = Food(
          fid: id,
          name: _name.text,
          price: int.parse(_price.text),
          image: _image.text,
          crid: dropdownValueCrust,
          ftid: dropdownValueType,
          sid: dropdownValueSize);
      if (id != 0) {
        var update = await CallApi().updateFood(foodData);
        if (update.apiStatus == "200") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('แก้ไขข้อมูลสำเร็จ')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Allpizza()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ขออภัย ! ไม่พบข้อมูล')),
          );
        }
      } else {
        var create = await CallApi().createFood(foodData);
        if (create.apiStatus == "200") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('สร้างข้อมูลสำเร็จ')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Allpizza()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ขออภัย ! ไม่พบข้อมูล')),
          );
        }
      }
    }
  }
}
