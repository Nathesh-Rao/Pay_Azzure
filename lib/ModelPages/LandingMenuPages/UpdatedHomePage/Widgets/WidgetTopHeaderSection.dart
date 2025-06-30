import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Controllers/MenuMorePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Models/MenuItemModel.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:substring_highlight/substring_highlight.dart';

class WidgetTopHeaderSection extends StatelessWidget {
  WidgetTopHeaderSection({super.key});

  final LandingPageController landingPageController = Get.find();
  final MenuMorePageController menuMorePageController = Get.find();
  final MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: menuHomePageController.client_info_companyTitle.value != "",
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Container(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          menuHomePageController.client_info_companyTitle.value,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Hello, ${CommonMethods.capitalize(menuHomePageController.user_nickName.value)}",
                        // + CommonMethods.capitalize(landingPageController.userName.value),
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: menuHomePageController.client_info_companyTitle.value != ""
                                    ? FontWeight.w500
                                    : FontWeight.w700)),
                      ),
                    ),
                  )
                ],
              )),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
                // padding: EdgeInsets.only(top: 1),
                // child: Text(
                //   "Agile Labs Pvt. Ltd.",
                //   style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: Colors.white)),
                // ),
                ),
          ),
          Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: TypeAheadField<MenuItemNewmModel>(
                controller: menuMorePageController.searchController,
                itemBuilder: (context, item) {
                  return ListTile(
                    leading: Icon(menuMorePageController.generateIcon(item, 1)),
                    minLeadingWidth: 10,
                    contentPadding: EdgeInsets.only(left: 10),
                    title: SubstringHighlight(
                      text: item.caption,
                      term: menuMorePageController.searchController.text,
                      textStyleHighlight: TextStyle(fontWeight: FontWeight.w700),
                    ), //Text(item.caption),
                  );
                },
                onSelected: (item) {
                  menuMorePageController.openItemClick(item);
                  menuMorePageController.clearField_searchBar();
                },
                suggestionsCallback: (value) {
                  return menuMorePageController.filter_search(value);
                },
                builder: (context, cnt, fn) {
                  return TextField(
                    controller: cnt,
                    focusNode: fn,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        //color: HexColor("#8E8E8E"),
                      ),
                      filled: true,
                      //fillColor: HexColor("#FFFFFF"),
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        //  color: HexColor("#8B193F"),
                      ),
                      contentPadding: EdgeInsets.only(left: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#7070704F")),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      prefixIcon: Icon(
                        Icons.search_outlined,
                      ),
                      suffixIcon: menuMorePageController.getSuffixIcon_searchBar(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: MyColors.blue1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ) /*Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 5),
                  child: Text(
                    landingPageController.toDay,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MyColors.blue2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 20, right: 5, bottom: 10),
                  child: Text(
                    "Hooray! Today is pay day!",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),*/
              )
        ],
      ),
    );
  }
}
