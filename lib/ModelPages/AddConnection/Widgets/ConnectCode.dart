import 'package:axpertflutter/ModelPages/AddConnection/Controllers/AddConnectionController.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectCode extends StatefulWidget {
  const ConnectCode({super.key});

  @override
  State<ConnectCode> createState() => _ConnectCodeState();
}

class _ConnectCodeState extends State<ConnectCode> {
  AddConnectionController addConnectionController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        elevation: 40,
        color: MyColors.white1,
        shadowColor: MyColors.buzzilyblack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Obx(() => Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                SizedBox(height: 20),
                Text("Connection Code", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextField(
                  controller: addConnectionController.connectionCodeController,
                  onSubmitted: (value) => addConnectionController.connectionCodeClick(),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                      hintText: "Enter Connection Code",
                      errorText: addConnectionController.evaluateErrorText(addConnectionController.errCode),
                      label: Text("Connection Code")),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 40),
                      ),
                      onPressed: addConnectionController.connectionCodeClick,
                      child: Text("SAVE")),
                ),
              ]),
            )),
      ),
    );
  }
}
