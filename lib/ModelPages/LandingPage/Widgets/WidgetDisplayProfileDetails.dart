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
                        landingPageController.showManageWindow();
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
}
