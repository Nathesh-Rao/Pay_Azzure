import 'dart:ui';

import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static final appBarTitleTextStyle = GoogleFonts.poppins(
    color: MyColors.primaryTitleTextColorBlueGrey,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static final textButtonStyle = GoogleFonts.poppins(
    color: MyColors.primaryTitleTextColorBlueGrey,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static final textButtonStyleNormal = GoogleFonts.poppins(
    color: MyColors.primaryTitleTextColorBlueGrey,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );
  static final onboardingTitleTextStyle = GoogleFonts.poppins(
    color: MyColors.primaryTitleTextColorBlueGrey,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  static final onboardingSubTitleTextStyle = GoogleFonts.poppins(
    color: MyColors.primarySubTitleTextColorBlueGreyLight,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final actionButtonStyle = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: MyColors.primaryActionColorDarkBlue,
  );

  static final attendanceWidgetTimeStyle = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: MyColors.primaryActionColorDarkBlue,
  );

  static final searchFieldTextStyle = GoogleFonts.poppins(
    color: MyColors.primaryActionColorDarkBlue,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static final taskHistoryUserNameStyle = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static final leaveActivityMainStyle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static var attendanceLogStyle =
      GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500);
}
