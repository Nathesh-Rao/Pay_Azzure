import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/GlobalVariableController.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/Const.dart';
import 'package:axpertflutter/ModelPages/AddConnection/Controllers/AddConnectionController.dart';
import 'package:axpertflutter/ModelPages/AddConnection/Controllers/ProjectController.dart';
import 'package:axpertflutter/ModelPages/ProjectListing/Model/ProjectModel.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectItemListTile extends StatelessWidget {
  String? keyValue;
  final AppStorage appStorage = AppStorage();


  ProjectItemListTile(ProjectModel value) {
    projectModel = value;
  }
  ProjectModel? projectModel;
  AddConnectionController addConnectionController = Get.find();
  ProjectController projectController = Get.find();
  final globalVariableController = Get.find<GlobalVariableController>();

  @override
  Widget build(BuildContext context) {
    final constInstance = Const();
    return GestureDetector(
      onTap: () async {

        await appStorage.storeValue(AppStorage.CACHED, projectModel!.projectCaption);
        await appStorage.storeValue(projectModel!.projectCaption, projectModel);
        globalVariableController.PROJECT_NAME.value = projectModel!.projectname;
        globalVariableController.PROJECT_URL.value = projectModel!.web_url;
        globalVariableController.ARM_URL.value = projectModel!.arm_url;
        await appStorage.storeValue(AppStorage.PROJECT_NAME, projectModel!.projectname);
        await appStorage.storeValue(AppStorage.PROJECT_URL, projectModel!.web_url);
        await appStorage.storeValue(AppStorage.ARM_URL, projectModel!.arm_url);
        LogService.writeLog(message: "[i] ProjectListingPage\nSelected Project : ${projectModel!.projectname}");
        LogService.writeOnConsole(message: "Const.ARM_URL => ${globalVariableController.ARM_URL.value}");
        Get.offAllNamed(Routes.Login);
      },
      child: Card(
        elevation: 10,
        color: MyColors.white1,
        shadowColor: MyColors.white1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(width: 1, color: Colors.grey.shade300),
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              CircleAvatar(
                backgroundColor: MyColors.blue2,
                child: Text(projectModel!.projectname.characters.first.toUpperCase()),
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
                  // addConnectionController.edit(keyValue);
                  projectController.edit(projectModel!);
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EditWelcomeSmallScreen(weburllist[i], armurllist[i], connectionnamelist[i], connectioncaptionlist[i], i)));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 28, color: MyColors.red),
                tooltip: 'Delete',
                onPressed: () async {
                  LogService.writeLog(message: "[i] ProjectListingPage\n${projectModel!.projectname} Project Deleted");
                  // addConnectionController.delete(keyValue);
                  projectController.delete(projectModel!);
                },
              ),
            ])),
      ),
    );
  }
}
