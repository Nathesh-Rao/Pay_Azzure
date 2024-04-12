import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetDisplayProfileDetails extends StatelessWidget {
  WidgetDisplayProfileDetails({super.key});

  final LandingPageController landingPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: 40),
        height: 250,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: MyColors.buzzilyblack,
              ),
              height: 200,
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 35.0,
                    backgroundImage: AssetImage(
                      "assets/images/profile.png",
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(landingPageController.userName.value, //main profile name
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: MyColors.white1,
                        fontSize: 12,
                        fontFamily: "nunitoreg1",
                      )),
                  SizedBox(height: 15),
                  Container(
                    height: 30.0,
                    color: MyColors.buzzilyblack,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        showManageWindow();
                      },
                      child: Container(
                        width: 170.0,
                        height: 30,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(38)),
                        ),
                        padding: const EdgeInsets.fromLTRB(4.0, 5.0, 0.0, 0.0),
                        child: Column(children: const [
                          Text(
                            'Manage Your Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "nunitoreg"),
                          ),
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Center(
                child: ElevatedButton.icon(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 20.0,
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              label: const Text(
                'Log Out',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: () {
                Get.back();
                landingPageController.signOut();
              },
            )),
          ],
        ),
      ),
    );
  }

  showManageWindow() {
    return Get.dialog(
        Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 400,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: TabBar(unselectedLabelColor: Colors.black, labelColor: Colors.black, tabs: [
                      Tab(
                        text: "User Profile",
                      ),
                      Tab(text: "Change\nCredentials")
                    ]),
                    body: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TabBarView(
                        children: [userProfile(), userCredentials()],
                      ),
                    ),
                  ),
                ),
              ),
            )),
        barrierDismissible: false);
  }

  userProfile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        TextFormField(
          readOnly: true,
          controller: landingPageController.userCtrl,
          enableInteractiveSelection: false,
          keyboardType: TextInputType.text,
          style: const TextStyle(fontFamily: "nunitobold", fontSize: 14.0),
          decoration: const InputDecoration(
            labelText: 'User Name',
            hintText: 'User Name',
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            landingPageController.closeProfileDialog();
          },
          child: Container(
            width: 600.0,
            height: 30,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: const EdgeInsets.fromLTRB(3.0, 6.0, 3.0, 3.0),
            child: Column(children: const [
              Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "nunitoreg"),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  userCredentials() {
    return Obx(() => Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: landingPageController.oPassCtrl,
              obscureText: !landingPageController.showOldPass.value,
              keyboardType: TextInputType.text,
              onChanged: (value) {},
              style: const TextStyle(fontFamily: "nunitobold", fontSize: 14.0),
              decoration: InputDecoration(
                labelText: 'Old Password',
                hintText: 'Enter your old password',
                errorText: landingPageController.evaluteError(landingPageController.errOPass.value),
                suffixIcon: IconButton(
                  icon: Icon(
                    landingPageController.showOldPass.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    landingPageController.showOldPass.toggle();
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: landingPageController.nPassCtrl,
              obscureText: !landingPageController.showNewPass.value,
              keyboardType: TextInputType.text,
              onChanged: (value) {},
              style: const TextStyle(fontFamily: "nunitobold", fontSize: 14.0),
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter your new password',
                errorText: landingPageController.evaluteError(landingPageController.errNPass.value),
                suffixIcon: IconButton(
                  icon: Icon(
                    landingPageController.showNewPass.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    landingPageController.showNewPass.toggle();
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: landingPageController.cnPassCtrl,
              obscureText: !landingPageController.showConNewPass.value,
              keyboardType: TextInputType.text,
              onChanged: (value) {},
              style: const TextStyle(fontFamily: "nunitobold", fontSize: 14.0),
              decoration: InputDecoration(
                labelText: 'Confrmation Password',
                hintText: 'Enter your Confrmation password',
                errorText: landingPageController.evaluteError(landingPageController.errCNPass.value),
                suffixIcon: IconButton(
                  icon: Icon(
                    landingPageController.showConNewPass.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    landingPageController.showConNewPass.toggle();
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              SizedBox(
                height: 30.0,
                width: 100.0,
                child: ElevatedButton(
                  onPressed: () {
                    landingPageController.closeProfileDialog();
                  },
                  child: Container(
                    width: 600.0,
                    height: 30,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: const EdgeInsets.fromLTRB(3.0, 6.0, 3.0, 3.0),
                    child: Column(children: const [
                      Text('Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "nunitoreg"))
                    ]),
                  ),
                ),
              ),
              Container(
                width: 15.0,
              ),
              SizedBox(
                height: 30.0,
                width: 100.0,
                child: ElevatedButton(
                  onPressed: () {
                    landingPageController.changePasswordCalled();
                  },
                  child: Container(
                    width: 600.0,
                    height: 30,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(3.0, 6.0, 3.0, 3.0),
                    child: Text(
                      'Update',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "nunitoreg"),
                    ),
                  ),
                ),
              )
            ]),
          ],
        ));
  }
}
