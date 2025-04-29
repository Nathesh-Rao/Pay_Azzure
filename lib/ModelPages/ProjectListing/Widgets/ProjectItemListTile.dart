import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/AddConnection/Controllers/AddConnectionController.dart';
import 'package:axpertflutter/ModelPages/ProjectListing/Model/ProjectModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectItemListTile extends StatelessWidget {
  String? keyValue;
  final AppStorage appStorage = AppStorage();

  ProjectItemListTile(String value) {
    keyValue = value;
    var jsonProject = appStorage.retrieveValue(keyValue ?? "");
    projectModel = ProjectModel.fromJson(jsonProject);
  }
  ProjectModel? projectModel;
  AddConnectionController addConnectionController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        appStorage.storeValue(AppStorage.CACHED, projectModel!.projectname);
        Const.PROJECT_NAME = projectModel!.projectname;
        Const.PROJECT_URL = projectModel!.web_url;
        Const.ARM_URL = projectModel!.arm_url;
        await appStorage.storeValue(AppStorage.PROJECT_NAME, projectModel!.projectname);
        await appStorage.storeValue(AppStorage.PROJECT_URL, projectModel!.web_url);
        await appStorage.storeValue(AppStorage.ARM_URL, projectModel!.arm_url);
        Get.offAllNamed(Routes.Login);
      },
      child: Card(
        elevation: 10,
        color: MyColors.white1,
        shadowColor: MyColors.white1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              CircleAvatar(
                backgroundColor: MyColors.yellow_background,
                child: Text(
                  projectModel!.projectname.characters.first.toUpperCase(),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                  height: 60,
                  child: VerticalDivider(
                    color: Colors.black38,
                    thickness: 2,
                  )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectModel!.projectCaption,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: MyColors.buzzilyblack,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Proxima_Nova_Regular',
                          fontSize: 15),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      projectModel!.arm_url,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: MyColors.buzzilyblack,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Proxima_Nova_Regular',
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_sharp, size: 28, color: MyColors.green),
                tooltip: 'Edit',
                onPressed: () async {
                  addConnectionController.edit(keyValue);
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EditWelcomeSmallScreen(weburllist[i], armurllist[i], connectionnamelist[i], connectioncaptionlist[i], i)));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 28, color: MyColors.red),
                tooltip: 'Delete',
                onPressed: () async {
                  addConnectionController.delete(keyValue);
                },
              ),
            ])),
      ),
    );
  }
}
