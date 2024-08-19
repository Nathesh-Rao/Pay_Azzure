import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Controllers/CompletedListController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Models/PendingListModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class WidgetCompletedListItem extends StatelessWidget {
  WidgetCompletedListItem(this.completedActiveListModel, {super.key});

  CompletedListController completedListController = Get.find();

  PendingListModel completedActiveListModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 30,
            child: Stack(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1, 1),
                    )
                  ]),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/add_circle.png',
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.green),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        completedActiveListModel.displaytitle.toString(),
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: HexColor('#495057'))),
                        // mode: TextScrollMode.endless,
                        // velocity: Velocity(pixelsPerSecond: Offset(30, 0)),
                        // delayBefore: Duration(milliseconds: 1500),
                        // //numberOfReps: 5,
                        // pauseBetween: Duration(milliseconds: 1500),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        // selectable: true,
                      ),
                    ),

                    //Expanded(child: Text("")),
                    // SizedBox(
                    //   width: 10,
                    // ),

                    // SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 5),
                Text(completedActiveListModel.displaycontent.toString(),
                    maxLines: 1,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 11,
                        color: HexColor('#495057'),
                      ),
                    )),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 5,
                    ),
                    Text(completedActiveListModel.fromuser.toString().capitalize!,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: HexColor('#495057'),
                          ),
                        ))
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16),
                    SizedBox(width: 10),
                    Text(completedListController.getDateValue(completedActiveListModel.eventdatetime),
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: HexColor('#495057'),
                          ),
                        )),
                    Expanded(child: Text("")),
                    Icon(Icons.access_time, size: 16),
                    SizedBox(width: 10),
                    Text(completedListController.getTimeValue(completedActiveListModel.eventdatetime),
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: HexColor('#495057'),
                          ),
                        )),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          Container(
            height: 60,
            child: Center(
                child: Icon(
              Icons.chevron_right,
              size: 30,
              color: HexColor("B5B5B5"),
            )),
          ),
        ],
      ),
    );
  }
}
