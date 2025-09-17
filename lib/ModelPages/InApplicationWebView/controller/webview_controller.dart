import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../LandingPage/Controller/LandingPageController.dart';

class WebViewController extends GetxController {
  var currentIndex = 0.obs;
  var currentUrl = ''.obs;
  var previousUrl = '';
  var isFileDownloading = false.obs;
  var isWebViewLoading = false.obs;
  var isProgressBarActive = true.obs;
  var inAppWebViewController = Rxn<InAppWebViewController>();

  openWebView({required String url}) async {
    LandingPageController landingPageController = Get.find();
    if (!landingPageController.isAxpertConnectEstablished) {
      await landingPageController.callApiForConnectToAxpert();
    }

    if (landingPageController.isAxpertConnectEstablished) {
      currentUrl.value = url;

      await inAppWebViewController.value!
          .loadUrl(
        urlRequest: URLRequest(
          url: WebUri(url),
        ),
      )
          .then((_) {});
      currentIndex.value = 1;
    }
  }

  closeWebView() {
    currentIndex.value = 0;
    isProgressBarActive.value = true;
  }

  signOut({required String url}) async {
    // currentUrl.value = url;

    await inAppWebViewController.value!
        .loadUrl(
      urlRequest: URLRequest(
        url: WebUri(url),
      ),
    )
        .then((_) {});
  }
}
