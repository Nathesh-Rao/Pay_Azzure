import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Controllers/UpdatedActiveTaskListController/ActiveTaskListController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../../Constants/MyColors.dart';
import '../../../Models/UpdatedActiveTaskListModel/ActiveTaskListModel.dart';

class WidgetActiveLisTile extends StatelessWidget {
  const WidgetActiveLisTile({super.key, required this.model});
  final ActiveTaskListModel model;

  @override
  Widget build(BuildContext context) {
    final ActiveTaskListController activeTaskListController = Get.find();
    var style = GoogleFonts.poppins();
    var color = model.cstatus?.toLowerCase() == "active" ? Color(0xff9898FF) : Color(0xff319F43);

    return ListTile(
      contentPadding: EdgeInsets.only(left: 0, right: 10, top: 5),
      titleAlignment: ListTileTitleAlignment.center,
      isThreeLine: true,
      shape: Border(bottom: BorderSide(color: MyColors.grey2)),
      onTap: () {
        activeTaskListController.onTaskClick(model);
      },
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
              right: 25,
            ),
            color: model.cstatus?.toLowerCase() == "active" ? Color(0xff9898FF) : null,
            width: 5,
          ),
          CircleAvatar(
            radius: 23,
            backgroundColor: color.withAlpha(70),
            child: Icon(
              model.cstatus?.toLowerCase() == "active" ? Icons.file_open_rounded : Icons.done,
              color: color,
            ),
          ),
        ],
      ),
      title: activeTaskListController.highlightedText(
          model.displaytitle.toString(), style.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          isTitle: true),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          activeTaskListController.highlightedText(
            model.displaycontent.toString().trim(),
            style.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _tileInfoWidget(model.fromuser.toString(), Color(0xff737674)),
              SizedBox(width: 10),
              model.cstatus?.toLowerCase() != "active"
                  ? _tileInfoWidget(model.cstatus.toString(), Color(0xff319F43))
                  : SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 7),
        ],
      ),
      trailing: RichText(
        text: TextSpan(
          style: style.copyWith(
            fontSize: 9,
            color: MyColors.grey9,
            // color: Color(0xff666D80),
            fontWeight: FontWeight.w600,
          ),
          children: activeTaskListController.formatDateTimeSpan(
            activeTaskListController.formatToDayTime(model.eventdatetime.toString()),
          ),
        ),
      ),
    );

    // return InkWell(
    //   onTap: () {
    //     activeTaskListController.onTaskClick(model);
    //   },
    //   child: Container(
    //     margin: EdgeInsets.only(top: 2, bottom: 2),
    //     padding: EdgeInsets.only(bottom: 10, top: 10),
    //     decoration: BoxDecoration(border: Border(bottom: BorderSide(color: MyColors.grey2))),
    //     // height: 115,
    //     child: Center(
    //       child: IntrinsicHeight(
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Container(
    //               margin: EdgeInsets.only(
    //                 right: 25,
    //               ),
    //               color: model.cstatus?.toLowerCase() == "active" ? Color(0xff9898FF) : null,
    //               width: 5,
    //             ),
    //             CircleAvatar(
    //               radius: 25,
    //               backgroundColor: color.withAlpha(70),
    //               child: Icon(
    //                 model.cstatus?.toLowerCase() == "active" ? Icons.file_open_rounded : Icons.done,
    //                 color: color,
    //               ),
    //             ),
    //             SizedBox(width: 15),
    //             Expanded(
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 // mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Flexible(
    //                         child: activeTaskListController.highlightedText(
    //                             model.displaytitle.toString(), style.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
    //                             isTitle: true),
    //                       ),
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       RichText(
    //                         text: TextSpan(
    //                           style: style.copyWith(
    //                             fontSize: 9,
    //                             color: MyColors.grey9,
    //                             // color: Color(0xff666D80),
    //                             fontWeight: FontWeight.w600,
    //                           ),
    //                           children: activeTaskListController.formatDateTimeSpan(
    //                             activeTaskListController.formatToDayTime(model.eventdatetime.toString()),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   Row(
    //                     children: [
    //                       Flexible(
    //                         child: activeTaskListController.highlightedText(
    //                             model.displaycontent.toString().trim(),
    //                             style.copyWith(
    //                               fontSize: 12,
    //                             ),
    //                             isTitle: true),
    //                       ),
    //                       // Flexible(
    //                       //     child: Text(
    //                       //   model.displaymcontent.toString(),
    //                       //   style: style.copyWith(
    //                       //     fontSize: 12,
    //                       //   ),
    //                       // )),
    //                       SizedBox(width: 40),
    //                     ],
    //                   ),
    //                   SizedBox(height: 10),
    //                   Row(
    //                     children: [
    //                       _tileInfoWidget(model.fromuser.toString(), Color(0xff737674)),
    //                       SizedBox(width: 10),
    //                       model.cstatus?.toLowerCase() != "active"
    //                           ? _tileInfoWidget(model.cstatus.toString(), Color(0xff319F43))
    //                           : SizedBox.shrink(),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             SizedBox(width: 15),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  _tileInfoWidget(String label, Color color) {
    return Container(
      decoration: BoxDecoration(color: color.withAlpha(50), borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(label, style: GoogleFonts.poppins(fontSize: 10, color: color.darken(0.5), fontWeight: FontWeight.w500)),
      ),
    );
  }
}
