import 'package:axpertflutter/ModelPages/AddConnection/page/AddNewConnections.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/page/InApplicationWebView.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Page/PendingListItemDetails.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/Binding.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Page/LandingPage.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Page/ForgetPassword.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Page/LoginPage.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Page/SignUp.dart';
import 'package:axpertflutter/ModelPages/NotificationPage/Pages/NotificationPage.dart';
import 'package:axpertflutter/ModelPages/ProjectListing/Page/ProjectListingPage.dart';
import 'package:axpertflutter/ModelPages/SettingsPage/Page/SettingsPage.dart';
import 'package:axpertflutter/ModelPages/ShowLogs/Pages/ShowLog.dart';
import 'package:axpertflutter/ModelPages/SpalshPage/page/SplashPageUI.dart';
import 'package:get/get.dart';

class Routes {
  static const String SplashScreen = "/SplashScreen";
  static const String AddNewConnection = "/AddConnection";
  static const String InApplicationWebViewer = "/InApplicationWebViewer";
  static const String ProjectListingPage = "/ProjectListingPage";
  static const String ProjectListingPageDetails = "/ProjectListingPage/Details";
  static const String Login = "/Login";
  static const String SignUp = "/SignUp";
  static const String ForgetPassword = "/ForgetPassword";
  static const String LandingPage = "/LandingPage";
  static const String NotificationPage = "/LandingPage/Notifications";
  static const String SettingsPage = "/LandingPage/Settings";
  static const String ShowLogs = "/LandingPage/ShowLogs";
}

class RoutePages {
  static List<GetPage<dynamic>> pages = [
    GetPage(
      name: Routes.SplashScreen,
      page: () => SplashPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.AddNewConnection,
      page: () => AddNewConnection(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.InApplicationWebViewer,
      page: () => InApplicationWebViewer(""),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.ProjectListingPage,
      page: () => ProjectListingPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.ProjectListingPageDetails,
      page: () => PendingListItemDetails(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.Login,
      page: () => LoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.SignUp,
      page: () => SignUpUser(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.ForgetPassword,
      page: () => ForgetPassword(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.LandingPage,
      page: () => LandingPage(),
      transition: Transition.rightToLeft,
      binding: LandingPageBinding(),
    ),
    GetPage(
      name: Routes.NotificationPage,
      page: () => NotificationPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.SettingsPage,
      page: () => SettingsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.ShowLogs,
      page: () => ShowLogs(),
      transition: Transition.rightToLeft,
    ),
  ];
}
