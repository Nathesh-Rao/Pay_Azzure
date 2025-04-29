import 'package:axpertflutter/ModelPages/ShowLogs/Controller/ShowLogsController.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowLogs extends StatelessWidget {
  ShowLogs({super.key});
  final ShowLogsController showLogsController = Get.put(ShowLogsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show Logs"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromRGBO(55, 100, 252, 1),
              Color.fromRGBO(151, 100, 218, 1),
            ],
          )),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.download),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Text(
              "Your log shows here",
            ),
          ),
        ),
      ),
    );
  }
}
