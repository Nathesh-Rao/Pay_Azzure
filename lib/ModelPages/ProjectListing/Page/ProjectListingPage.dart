import 'dart:io';

import 'package:animated_icon/animated_icon.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/ModelPages/AddConnection/Controllers/AddConnectionController.dart';
import 'package:axpertflutter/ModelPages/ProjectListing/Controller/ProjectListingController.dart';
import 'package:axpertflutter/ModelPages/ProjectListing/Widgets/ProjectItemListTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ProjectListingPage extends StatefulWidget {
  const ProjectListingPage({super.key});

  @override
  State<ProjectListingPage> createState() => _ProjectListingPageState();
}

class _ProjectListingPageState extends State<ProjectListingPage> {
  ProjectListingController projectListingController = Get.put(ProjectListingController());
  AddConnectionController addConnectionController = Get.put(AddConnectionController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Obx(() {
        if (projectListingController.needRefresh.value) {
          projectListingController.getProjectCount();
          projectListingController.needRefresh.value = false;
          return buildContentBody();
        }
        return buildContentBody();
      }),
    );
  }

  _NavigateToAddConnectionPage() async {
    var data = await Get.toNamed(Routes.AddNewConnection);
    if (data != null) {
      if (projectListingController.isCountAvailable.value == false) projectListingController.isCountAvailable.value = true;
      setState(() {
        projectListingController.getProjectList();
      });
    }
    setState(() {});
  }

  buildContentBody() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.white1,
        appBar: Platform.isIOS
            ? AppBar(
                elevation: 0,
                toolbarHeight: 0,
                backgroundColor: Colors.white,
              )
            : null,
        body: LoadingOverlay(
          isLoading: projectListingController.isloading.value,
          progressIndicator: const CircularProgressIndicator(),
          child: Stack(
            children: [
              Positioned(
                  right: -50,
                  bottom: 50,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(80), topLeft: Radius.circular(80), topRight: Radius.circular(80)),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width,
                      color: MyColors.yellow_background,
                    ),
                  )),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      // margin: EdgeInsets.only(left: 10,right: 10),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: Card(
                            elevation: 40,
                            color: MyColors.white1,
                            shadowColor: MyColors.buzzilyblack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Hero(
                                        tag: 'axpertImage',
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                                          child: Image.asset(
                                            // 'assets/images/buzzily-logo.png',
                                            'assets/images/pay_azzure_text.png',
                                            height: 30,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0, left: 0, right: 0),
                                    child: Text(
                                      'Connect to application',
                                      style: TextStyle(
                                        color: MyColors.buzzilyblack,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        fontFamily: 'Proxima_Nova_Regular',
                                      ),
                                    ),
                                  ),
                                  RefreshIndicator(
                                    onRefresh: () {
                                      setState(() {});
                                      return Future.value(true);
                                    },
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.6,
                                      child: projectListingController.isCountAvailable.value
                                          ? FutureBuilder(
                                              future: projectListingController.getProjectList(),
                                              builder: (BuildContext context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                                if (snapshot.connectionState == ConnectionState.done) {
                                                  if (snapshot.hasError) {
                                                    return Text("");
                                                  } else {
                                                    if (snapshot.hasData) {
                                                      return ListView.builder(
                                                          padding: EdgeInsets.only(left: 20, right: 20),
                                                          itemCount: snapshot.data!.length,
                                                          itemBuilder: (_, index) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                print("index data: " + snapshot.data![index]);
                                                              },
                                                              child: Dismissible(
                                                                  background: Container(
                                                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.red,
                                                                        borderRadius:
                                                                            BorderRadius.horizontal(left: Radius.circular(10))),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 10),
                                                                          child: AnimateIcon(
                                                                            iconType: IconType.continueAnimation,
                                                                            color: Colors.white,
                                                                            animateIcon: AnimateIcons.trashBin, onTap: () {},

                                                                            // child: Text(
                                                                            //   "Delete",
                                                                            //   style: TextStyle(fontSize: 18, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  secondaryBackground: Container(
                                                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.green,
                                                                        borderRadius:
                                                                            BorderRadius.horizontal(right: Radius.circular(10))),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: [
                                                                        // Text(
                                                                        //   "Edit",
                                                                        //   style: TextStyle(color: Colors.white, fontSize: 18),
                                                                        // ),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(right: 10),
                                                                          child: AnimateIcon(
                                                                            onTap: () {}, animateIcon: AnimateIcons.edit,
                                                                            iconType: IconType.continueAnimation,
                                                                            color: Colors.white,
                                                                            // child: Text(
                                                                            //   "Edit",
                                                                            //   style: TextStyle(color: Colors.white, fontSize: 18),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  confirmDismiss: (direction) async {
                                                                    if (direction == DismissDirection.endToStart) {
                                                                      addConnectionController.edit(snapshot.data![index]);
                                                                    }
                                                                    if (direction == DismissDirection.startToEnd) {
                                                                      return addConnectionController
                                                                          .delete(snapshot.data![index]);
                                                                    }
                                                                    return false;
                                                                  },
                                                                  key: ValueKey(index),
                                                                  child: ProjectItemListTile(snapshot.data![index])),
                                                            );
                                                          });
                                                    }
                                                  }
                                                }
                                                return Text("");
                                              })
                                          : Visibility(
                                              visible: !projectListingController.isCountAvailable.value,
                                              child: GestureDetector(
                                                onTap: _NavigateToAddConnectionPage,
                                                child: Container(
                                                  padding: EdgeInsets.only(top: 250),
                                                  height: 50,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        width: 250,
                                                        decoration: BoxDecoration(
                                                            color: MyColors.blue2, borderRadius: BorderRadius.circular(30)),
                                                        child: Center(
                                                          child: Text(
                                                            "+ Add Connection",
                                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                                          ),
                                                        ),

                                                        // color: Colors.red,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: projectListingController.isCountAvailable.value,
          child: FloatingActionButton.extended(
            backgroundColor: MyColors.blue2,
            tooltip: 'Add Connection',
            onPressed: _NavigateToAddConnectionPage,
            label: Text(
              'Add Connection',
              style: TextStyle(
                color: MyColors.white1,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                fontFamily: 'Proxima_Nova_Regular',
              ),
            ),
            icon: Icon(Icons.add, color: MyColors.white1, size: 25),
          ),
        ));
  }
}
