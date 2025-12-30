import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyColors {
  static const Color white1 = Color(0xFFFFFFFF);
  static const Color white2 = Color(0xFFFFFFFF);
  static const Color blue1 = Color(0xFF006cff);
  static const Color yellow_background = Color(0xFFe498a0);
  static const Color baseBlue = Color(0xff3764FC);
  static const Color baseYellow = Color(0xffF79E02);
  static const Color baseRed = Color(0xffDD2025);
  static const Color basegray = Color(0xffDEDEDE);
  static const Color baseGray = Color(0xffDEDEDE);
  static const taskClockInWidgetColorPurple = Color(0xff8371EC);
  static const flatButtonColorBlue = Color(0xff2A79E4);
  static const brownRed = Color(0xff4F0006);
  static const flatButtonColorPurple = Color(0xff8371EC);
  static const primaryTitleTextColorBlueGrey = Color(0xff505B77);
  static const primarySubTitleTextColorBlueGreyLight = Color(0xff969DAD);
  static const secondarySubTitleTextColorGreyLight = Color(0xffA2A2A2);
  static const primaryActionColorDarkBlue = Color(0xff282D46);

  static const Color historyCreated = Color(0xffFB6340);
  static const Color historyAssigned = Color(0xff2A79E4);
  static const Color historyCompleted = Color(0xff2DCE89);
  static const primaryButtonBGColorViolet = Color(0xff544D80);
  static const primaryButtonFGColorWhite = Color(0xffE9EDF2);
  static const secondaryButtonBGColorWhite = Colors.white;
  static const secondaryButtonFGColorViolet = primaryButtonBGColorViolet;
  static const secondaryButtonBorderColorGrey = Color(0xffDDDDDD);
  static const normalBoxBorderColorGrey = Color(0xffCCCCCC);
  static const textFieldMainTextColorBlueGrey = Color(0xff757575);
  // static const Color blue2 = Color(0xFF2a2b8f);
  static const Color PayAzzureColor2 = Color(0xFFa81f2c);
  // static const secondaryButtonBorderColorGrey = Color(0xffDDDDDD);
  static const Color blue3 = Color(0xFF4fc3f7);
  static const Color blue4 = Color(0xFF8591B0);
  static const Color blue5 = Color(0xFF0D47A1);
  static const Color blue6 = Color(0xFF1976D2);
  static const Color blue7 = Color(0xFF42A5F5);
  static const Color blue8 = Color(0xFFF7F8FA);
  static const Color blue9 = Color(0xFF0d297d);
  static const Color blue10 = Color(0xff1F41BB);
  static const Color red = Color(0xFFed1c24);
  static const Color maroon = Color(0xFFc22121);
  static const Color orange = Color(0xFFff4500);
  static const Color yellow = Color(0xFFffff4c);
  static const Color gold = Color(0xFFdaa520);
  static const Color yellow1 = Color(0xFFFFBC20);
  static const Color goldpale = Color(0xFFeee8aa);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF808080);
  static const Color grey1 = Color(0xFFd9d5d5);
  static const Color grey1bg = Color(0xFF1f1f2e);
  static const Color grey2 = Color(0xFFF6F7F9);
  static const Color grey3 = Color(0xFF787878);
  static const Color grey4 = Color(0xFF3F3F3F);
  static const Color grey5 = Color(0xFFB6B6B6);
  static const Color grey6 = Color(0xFF999999);
  static const Color grey7 = Color(0xFFb3b3b3);
  static const Color grey8 = Color(0xFFf6f7f9);
  static const Color grey9 = Color(0xFF575E65);
  static const Color teal = Color(0xFFB2DFDB);
  static const Color teal1 = Color(0xFF0288D1);
  static const Color green = Color(0xFF4CAF50);
  static const Color color_grey = Color(0xFFF6F7F8);
  static const Color dialogheaderback = Color(0xFF5b538c);
  static const Color headerback = Color(0xFF164A41);
  static const Color headerback1 = Color(0xFF164A41);

  static const Color buttoncolor1 = Color(0xFF4CAF50);
  static const Color buttoncolor = Color(0xFF164A41);

  static const Color treeview = Color(0xFF9DC88D);
  static const Color pagepanel = Color(0xFF9DC88D);

  static const Color topheeader = Color(0xFF164A41);
  static const Color topheeader1 = Color(0xFF164A41);

  static const Color subheeader = Color(0xFF164A41);
  static const Color subheeader1 = Color(0xFF164A41);

  static const Color buzzilyblack = Color(0xFF1F1D2C);
  static const Color buzzilygrey = Color(0xFFF6F7F8);
  static const Color buzzilybuttonblue = Color(0xFF006CFF);
  static const Color buzzilytext = Color(0xFF2b282b);
  static const Color buzzilybuttontext = Color(0xFF778085);

  static const Color white3 = Color(0xffECECEC);
  static const Color text1 = Color(0xff626262);
  static const Color text2 = Color(0xff919191);
  static const Color AXMDark = Color(0xff363942);
  static const Color AXMGray = Color(0xff61677D);

  static const chipCardWidgetColorViolet = Color(0xff8E61E9);
  static const chipCardWidgetColorRed = Color(0xffE96161);
  static const chipCardWidgetColorGreen = Color(0xff01916A);
  static const chipCardWidgetColorBlue = Color(0xff2A79E4);
  static const leaveWidgetColorSandal = Color(0xffE0A47A);
  static const leaveWidgetColorGreen = Color(0xff379785);
  static const leaveWidgetColorPink = Color(0xffDA5077);
  static const leaveWidgetColorGreenLite = Color(0xff5BBBA9);
  static const snackBarInfoColorGrey = Color(0xff9E9E9E);
  static const snackBarNotificationColorBlue = Color(0xffA1BAFF);
  static const snackBarSuccessColorGreen = Color(0xff80DCB9);
  static const snackBarWarningColorYellow = Color(0xffFFC786);
  static const snackBarErrorColorRed = Color(0xffF1AA9B);
  static const LinearGradient updatedUIBackgroundGradient =
      LinearGradient(colors: [PayAzzureColor2, PayAzzureColor2]);

  static const LinearGradient subBGGradientVertical = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xff3764FC),
        Color(0xff9764DA),
      ]);

  static const LinearGradient subBGGradientHorizontal = LinearGradient(colors: [
    Color(0xff3764FC),
    Color(0xff9764DA),
  ]);
  //------random- color------>
  static Color getRandomColor() {
    List<Color> colors = [
      Colors.purple,
      Colors.green,
      Colors.amber,
      Colors.red,
      Colors.indigo,
      Colors.blue,
      Colors.orange,
      Colors.cyan,
      Colors.teal,
      Colors.lime,
      Colors.brown,
      Colors.pink,
      Colors.deepOrange,
      Colors.lightGreen,
      Colors.deepPurple,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  static final List<Color> _colorPalette = [
    // Color(0xFF8371EC),
    // Color(0xFFFF9B00),
    // Color(0xFF0271F2),
    // Color(0xFF9764DA),
    // Color(0xFF3764FC),
    // Color(0xFF9C27B0),
    // Color(0xFF9764DA),
    // Color(0xFF0271F2),
    // Color(0xFFFF9B00),
    // Color(0xFF8371EC),
    chipCardWidgetColorViolet,
    chipCardWidgetColorGreen,
    baseYellow,
    baseBlue,
    Colors.teal,
    Colors.blue,
    Colors.orange,
    Colors.cyan,
    Colors.lime,
    Colors.brown,
    Colors.pink,
    Colors.deepOrange,
    Colors.lightGreen,
    Colors.deepPurple,
  ];

  static int _currentIndex = 0;

  static var gradientBlue = Color(0xFF3764FC);

  static var gradientViolet = Color(0xFF9764DA);

  static var violetBorder = Color(0xff8371EC);

  static Color getNextColor() {
    if (_currentIndex >= _colorPalette.length) {
      _currentIndex = 0;
    }
    return _colorPalette[_currentIndex++];
  }

  static void resetColorIndex() {
    _currentIndex = 0;
  }
}
