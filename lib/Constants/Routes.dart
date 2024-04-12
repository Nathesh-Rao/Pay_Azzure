import 'package:axpertflutter/ModelPages/AddConnection/page/AddNewConnections.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/page/InApplicationWebView.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Page/PendingListItemDetails.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Page/LandingPage.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Page/ForgetPassword.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Page/LoginPage.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Page/SignUp.dart';
import 'package:axpertflutter/ModelPages/NotificationPage/Pages/NotificationPage.dart';
import 'package:axpertflutter/ModelPages/ProjectListing/Page/ProjectListingPage.dart';
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
    ),
    GetPage(
      name: Routes.NotificationPage,
      page: () => NotificationPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
