import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/AddConnection/Controllers/AddConnectionController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ProjectListing/Model/ProjectModel.dart';
import '../Controllers/ProjectController.dart';

class URLDetails extends StatefulWidget {
  const URLDetails({super.key, this.project});

  final ProjectModel? project;
  @override
  State<URLDetails> createState() => _URLDetailsState();
}

class _URLDetailsState extends State<URLDetails> {
  // AddConnectionController addConnectionController = Get.find();
  ProjectController projectController = Get.find();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text("Enter Project Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  TextField(
                      controller: projectController.webUrlController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                          hintText: "https://",
                          errorText: projectController.evaluateErrorText(projectController.errWebUrl),
                          label: Text("Web URL"))),
                  SizedBox(height: 20),
                  TextField(
                      controller: projectController.armUrlController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                          hintText: "Enter Arm Url",
                          errorText: projectController.evaluateErrorText(projectController.errArmUrl),
                          label: Text("ARM URL"))),
                  SizedBox(height: 20),
                  TextField(
                      controller: projectController.conNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                          hintText: "Enter Connection Name",
                          errorText: projectController.evaluateErrorText(projectController.errName),
                          label: Text("Connection Name"))),
                  SizedBox(height: 20),
                  TextField(
                      controller: projectController.conCaptionController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) => projectController.saveOrUpdateConnection(model: widget.project),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                          hintText: "Enter Connection Caption",
                          errorText: projectController.evaluateErrorText(projectController.errCaption),
                          label: Text("Connection Caption"))),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 40),
                        ),
                        onPressed: () {
                          projectController.saveOrUpdateConnection(model: widget.project);
                        },
                        child: Text("SAVE")),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )),
      ),
    );
  }
}
