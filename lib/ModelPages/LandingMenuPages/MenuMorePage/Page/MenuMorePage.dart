import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Controllers/MenuMorePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Models/MenuItemModel.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetNoDataFound.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class MenuMorePage extends StatelessWidget {
  MenuMorePage({super.key});
  final MenuMorePageController menuMorePageController = Get.put(MenuMorePageController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (menuMorePageController.needRefresh.value == true) {
        menuMorePageController.needRefresh.toggle();
        return reBuild(menuMorePageController);
      }
      return reBuild(menuMorePageController);
    });
  }
}

reBuild_old(MenuMorePageController menuMorePageController) {
  return Padding(
    padding: EdgeInsets.all(20),
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          TextField(
            controller: menuMorePageController.searchController,
            onChanged: menuMorePageController.filterList,
            enabled: true,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: HexColor("#8E8E8E"),
              ),
              filled: true,
              fillColor: HexColor("#FFFFFF"),
              labelStyle: TextStyle(
                fontSize: 15,
                fontFamily: 'Poppins',
                color: HexColor("#8B193F"),
              ),
              contentPadding: EdgeInsets.only(left: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#7070704F")),
                borderRadius: BorderRadius.circular(5),
              ),
              suffixIcon: menuMorePageController.searchController.text.toString() == ""
                  ? GestureDetector(
                      child: Icon(
                        Icons.search_outlined,
                        color: HexColor("#8E8E8EA3"),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        menuMorePageController.clearCalled();
                      },
                      child: Icon(
                        Icons.clear,
                        color: HexColor("#8E8E8EA3"),
                      ),
                    ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: MyColors.blue1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          Visibility(visible: menuMorePageController.fetchList.length == 0 ? true : false, child: WidgetNoDataFound()),
          FutureBuilder(
            future: menuMorePageController.futureBuilder(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (menuMorePageController.fetchList.length == 0)
                  return Text("Menu is not Initialized");
                else
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    controller: ScrollController(),
                    itemCount: menuMorePageController.fetchList.length,
                    // itemCount: 1,
                    itemBuilder: (context, mainIndex) {
                      //print("valuen: $mainIndex");
                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: HexColor('EDF0F8')), borderRadius: BorderRadius.circular(10)),
                        child: Theme(
                          data: ThemeData().copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(
                              menuMorePageController.fetchList[mainIndex].toString(),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(color: HexColor("#3E4153"), fontSize: 14, fontWeight: FontWeight.w900)),
                            ),
                            children: [
                              SizedBox(height: 3),
                              Container(
                                height: 1,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1,
                                    crossAxisCount: 3, // HERE YOU CAN ADD THE NO OF ITEMS PER LINE
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10),
                                // childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 5),
                                shrinkWrap: true,
                                controller: ScrollController(),
                                physics: ClampingScrollPhysics(),
                                itemCount: menuMorePageController.getSubmenuItemList(mainIndex).length,
                                // itemCount: 200,
                                itemBuilder: (context, index) {
                                  print("value mainIndex, subIndex: $mainIndex $index");
                                  return getGridItem(
                                      menuMorePageController, menuMorePageController.getSubmenuItemList(mainIndex)[index], index);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
              } else {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Text(
                    "Loading Please Wait...",
                    style: TextStyle(color: MyColors.blue2, fontWeight: FontWeight.bold),
                  )); //Center(child: CircularProgressIndicator());
                }
              }
              return Text("Menu not Initialized");
            },
          )
        ],
      ),
    ),
  );
}

reBuild(MenuMorePageController menuMorePageController) {
  return Padding(
    padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 0),
    child: NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextField(
              controller: menuMorePageController.searchController,
              onChanged: menuMorePageController.filterList,
              enabled: true,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: HexColor("#8E8E8E"),
                ),
                filled: true,
                fillColor: HexColor("#FFFFFF"),
                labelStyle: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  color: HexColor("#8B193F"),
                ),
                contentPadding: EdgeInsets.only(left: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#7070704F")),
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: menuMorePageController.searchController.text.toString() == ""
                    ? GestureDetector(
                        child: Icon(
                          Icons.search_outlined,
                          color: HexColor("#8E8E8EA3"),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          menuMorePageController.clearCalled();
                        },
                        child: Icon(
                          Icons.clear,
                          color: HexColor("#8E8E8EA3"),
                        ),
                      ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: MyColors.blue1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: menuMorePageController.fetchList.length,
        itemBuilder: (context, mainIndex) {
          //print("valuen: $mainIndex");
          return Container(
            margin: EdgeInsets.only(bottom: 10, top: 10),
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: HexColor('EDF0F8')), borderRadius: BorderRadius.circular(10)),
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  menuMorePageController.fetchList[mainIndex].toString(),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: HexColor("#3E4153"), fontSize: 14, fontWeight: FontWeight.w900)),
                ),
                children: [
                  SizedBox(height: 3),
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: isTablet() ? 3 : 5, // HERE YOU CAN ADD THE NO OF ITEMS PER LINE
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    // childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 5),
                    shrinkWrap: true,
                    controller: ScrollController(),
                    physics: ClampingScrollPhysics(),
                    itemCount: menuMorePageController.getSubmenuItemList(mainIndex).length,
                    // itemCount: 200,
                    itemBuilder: (context, index) {
                      print("value mainIndex, subIndex: $mainIndex $index");
                      return getGridItem(
                          menuMorePageController, menuMorePageController.getSubmenuItemList(mainIndex)[index], index);
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

getGridItem(MenuMorePageController menuMorePageController, MenuItemModel model, int index) {
  return GestureDetector(
    onTap: () {
      menuMorePageController.openItemClick(model);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Material(
            color: menuMorePageController.colorList[index % 8], //color
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Icon(
                menuMorePageController.generateIcon(model, index), //icon
                color: MyColors.white1,
                size: 25,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
          child: Text(
            model.caption,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(color: (HexColor("#3E4153")), fontSize: 11, fontFamily: "Poppins", fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
