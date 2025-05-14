import 'dart:convert';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../Constants/CommonMethods.dart';
import '../../../Constants/Routes.dart';
import '../../../Utils/LogServices/LogService.dart';
import '../../../Utils/ServerConnections/ServerConnections.dart';
import '../../ProjectListing/Model/ProjectModel.dart';

class ProjectController extends GetxController {
  RxList<ProjectModel> projects = <ProjectModel>[].obs;
  var isLoading = false.obs;
  AppStorage appStorage = AppStorage();
  //------------------
  TextEditingController connectionCodeController = TextEditingController();
  TextEditingController webUrlController = TextEditingController();
  TextEditingController armUrlController = TextEditingController();
  TextEditingController conNameController = TextEditingController();
  TextEditingController conCaptionController = TextEditingController();
  var errCode = ''.obs;
  var errWebUrl = ''.obs;
  var errArmUrl = ''.obs;
  var errName = ''.obs;
  var errCaption = ''.obs;
  var isFlashOn = false.obs;
  var isPlayPauseOn = false.obs;
//---------------------------
  MobileScannerController? scannerController;

  // Barcode? barcodeResult;

  ServerConnections serverConnections = ServerConnections();
//---------------------------

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  clearAllData() {
    webUrlController.text = '';
    armUrlController.text = '';
    conNameController.text = '';
    conCaptionController.text = '';
    errArmUrl.value = errCaption.value = errCode.value = errName.value = errWebUrl.value = '';
  }

  edit(ProjectModel project) {
    webUrlController.text = project.web_url;
    armUrlController.text = project.arm_url;
    conNameController.text = project.projectname;
    conCaptionController.text = project.projectCaption;
    errArmUrl.value = errCaption.value = errCode.value = errName.value = errWebUrl.value = '';
    Get.toNamed(Routes.AddNewConnection, arguments: [2, project]);
  }

  delete(ProjectModel project) async {
    await Get.defaultDialog(
        title: "Alert!",
        middleText: "Do you want to delete?",
        confirm: ElevatedButton(
          onPressed: () async {
            await removeProject(project.id);
            Get.back();
          },
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: Text("Yes"),
        ),
        cancel: TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("No")));
  }

  Future<void> saveProjects() async {
    if (projects.isEmpty) {
      await appStorage.storeValue("projects", null);
    } else {
      String encodedData = ProjectModel.encode(projects);
      await appStorage.storeValue("projects", encodedData);
    }
  }

  Future<void> loadProjects() async {
    String? storedData = appStorage.retrieveValue("projects");
    LogService.writeLog(message: "storedData => $storedData || ${storedData?.isEmpty} || ${storedData == []}");
    // LogService.writeLog(message: "projects => storedData => $storedData");

    if (storedData == null || storedData.isEmpty) {
      // var project = ProjectModel(DateTime.now().toString(), "vagmay", "hhttps://dev.payazzure.com/metaspeed/aspx/mainnew.aspx",
      //     "https://dev.payazzure.com/metaspeedarm", "vagmay");
      var project = ProjectModel(DateTime.now().toString(), "meta", "https://dev.payazzure.com/metaspeed/aspx/mainnew.aspx",
          "https://dev.payazzure.com/metaspeedarmmobile", "meta");

      await addProject(project);
    } else {
      projects.assignAll(ProjectModel.decode(storedData));
    }
  }

  Future<void> addProject(ProjectModel project) async {
    projects.add(project);
    await saveProjects();
  }

  Future<void> updateProject(String id, String projectName, String web_url, String arm_url, String caption) async {
    int index = projects.indexWhere((p) => p.id == id);
    if (index != -1) {
      projects[index] = ProjectModel(id, projectName, web_url, arm_url, caption);
      await saveProjects();
    }
  }

  // Future<void> removeProject(String id) async {
  //   //done delete cache if id matches
  //
  //   var cached = appStorage.retrieveValue(AppStorage.CACHED);
  //   try {
  //     if (cached == null) {
  //       // Get.offAllNamed(Routes.ProjectListingPage);
  //       // LogService.writeLog(message: "Cached => $cached");
  //
  //       projects.removeWhere((p) => p.id == id);
  //       await saveProjects();
  //     } else {
  //       var jsonProject = appStorage.retrieveValue(cached);
  //
  //       ProjectModel? projectModel;
  //       if (jsonProject is ProjectModel) {
  //         projectModel = jsonProject;
  //       } else {
  //         projectModel = ProjectModel.fromJson(jsonProject);
  //       }
  //
  //       if (projectModel.id == id) {
  //         appStorage.remove(AppStorage.CACHED);
  //       }
  //
  //       projects.removeWhere((p) => p.id == id);
  //       await saveProjects();
  //     }
  //   } catch (e) {
  //     projects.removeWhere((p) => p.id == id);
  //     await saveProjects();
  //     LogService.writeLog(message: e.toString());
  //   }
  // }
  Future<void> removeProject(String id) async {
    try {
      final cachedData = appStorage.retrieveValue(AppStorage.CACHED);
      final retrievedData = appStorage.retrieveValue(cachedData);
      LogService.writeLog(message: "[i] ProjectController cachedData1 => $cachedData");

      if (retrievedData != null) {
        ProjectModel? projectModel;

        if (retrievedData is ProjectModel) {
          projectModel = retrievedData;
        } else if (retrievedData is String) {
          projectModel = ProjectModel.fromJson(json.decode(retrievedData));
        } else if (retrievedData is Map<String, dynamic>) {
          projectModel = ProjectModel.fromJson(retrievedData);
        }
        // LogService.writeLog(message: "[i] ProjectController projectModel => ${projectModel?.id} || ${id}");
        // LogService.writeLog(message: "[i] projectModel idMatch => ${projectModel?.id == id}");

        if (projectModel?.id == id) {
          // LogService.writeLog(message: "[i] projectModel Cache removed");

          await appStorage.remove(AppStorage.CACHED);
        }
      }

      projects.removeWhere((p) => p.id == id);
      await saveProjects();
      final cachedData2 = appStorage.retrieveValue(AppStorage.CACHED);
      LogService.writeLog(message: "[i] ProjectController cachedData2 => $cachedData2");
    } catch (e) {
      projects.removeWhere((p) => p.id == id);
      await saveProjects();
      LogService.writeLog(message: "Error removing project: $e");
    }
  }

  ///----------------------------------
  saveOrUpdateConnection({ProjectModel? model, bool isQr = false}) async {
    if (!validateProjectDetailsForm()) {
      // LogService.writeOnConsole(message: "validateProjectDetailsForm => false");

      if (isQr) {
        // LogService.writeOnConsole(message: "saveOrUpdateConnection => isQR: $isQr");
        if (!isDuplicate(model)) {
          var project = ProjectModel(DateTime.now().toString(), conNameController.text, webUrlController.text,
              armUrlController.text, conCaptionController.text);

          await addProject(project);
          clearAllData();
          Get.back();
        } else {
          // print("saveOrUpdateConnection => isQR: $isQr => duplicate");

          scannerController!.start();
          // Get.snackbar("Element already exists.", "",
          //     snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      }
    } else {
      // LogService.writeOnConsole(message: "validateProjectDetailsForm => true");

      if (isQr) {
        var project = ProjectModel(DateTime.now().toString(), conNameController.text, webUrlController.text,
            armUrlController.text, conCaptionController.text);

        if (!isDuplicate(model)) {
          LoadingScreen.show();
          await addProject(project);
          clearAllData();
          Get.back();
        } else {
          if (!Get.isSnackbarOpen) {
            Get.snackbar(
              "Element already exists.",
              "",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
          scannerController!.start();
        }
      } else {
        LoadingScreen.show();
        var baseUrl = armUrlController.text.trim();
        baseUrl += baseUrl.endsWith("/") ? "" : "/";
        var url = baseUrl + ServerConnections.API_GET_APPSTATUS;
        final data = await serverConnections.getFromServer(url: url);
        if (data != "" && data.toString().toLowerCase().contains("running successfully".toLowerCase())) {
          if (!isDuplicate(model)) {
            if (await validateConnectionName(baseUrl)) {
              if (model == null) {
                var project = ProjectModel(DateTime.now().toString(), conNameController.text, webUrlController.text,
                    armUrlController.text, conCaptionController.text);

                await addProject(project);
              } else {
                await updateProject(
                    model.id, conNameController.text, webUrlController.text, armUrlController.text, conCaptionController.text);
              }

              clearAllData();
              Get.back();
            }
          }
        }
      }
    }
    LoadingScreen.dismiss();
  }

  bool isDuplicate(ProjectModel? model) {
    String newCaption = conCaptionController.text.trim().toLowerCase();
    var tempList = projects.where((p) => p.projectCaption.trim().toLowerCase() == newCaption);

    if (model == null) {
      if (tempList.isNotEmpty) {
        if (!Get.isSnackbarOpen) {
          Get.snackbar("Element already exists.", "",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
        return true;
      }
    } else {
      if (tempList.any((p) => p.id != model.id)) {
        if (!Get.isSnackbarOpen) {
          Get.snackbar("Element already exists.", "",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
        return true;
      }

      if (webUrlController.text.trim() == model.web_url &&
          armUrlController.text.trim() == model.arm_url &&
          conNameController.text.trim() == model.projectname &&
          newCaption == model.projectCaption.trim().toLowerCase()) {
        if (!Get.isSnackbarOpen) {
          Get.snackbar("Nothing to save.", "",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
        return true;
      }
    }
    return false;
  }

  bool isDuplicateQr(ProjectModel? model) {
    String newCaption = conCaptionController.text.trim().toLowerCase();
    var tempList = projects.where((p) => p.projectCaption.trim().toLowerCase() == newCaption);

    if (model == null) {
      if (tempList.isNotEmpty) return true;
    } else {
      if (tempList.any((p) => p.id != model.id)) {
        if (!Get.isSnackbarOpen) {
          Get.snackbar("Element already exists.", "",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
        return true;
      }

      if (webUrlController.text.trim() == model.web_url &&
          armUrlController.text.trim() == model.arm_url &&
          conNameController.text.trim() == model.projectname &&
          newCaption == model.projectCaption.trim().toLowerCase()) {
        if (!Get.isSnackbarOpen) {
          Get.snackbar("Nothing to save.", "",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
        return true;
      }
    }
    return false;
  }

  evaluateErrorText(controller) {
    return controller.value == '' ? null : controller.value;
  }

  bool validateProjectDetailsForm() {
    Pattern pattern = r"(https?|http)://([-a-z-A-Z0-9.]+)(/[-a-z-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[a-zA-Z0-9+&@#/%=~_|!:,.;]*)?";
    RegExp regex = RegExp(pattern.toString());
    errWebUrl.value = '';
    errArmUrl.value = '';
    errName.value = '';
    errCaption.value = '';
//web url
    if (webUrlController.text.toString().toLowerCase().trim() == "") {
      errWebUrl.value = "Enter Web Url";
      return false;
    }
    if (!regex.hasMatch(webUrlController.text)) {
      errWebUrl.value = "Enter Valid Web Url";
      return false;
    }
    //Arm url
    if (armUrlController.text.toString().toLowerCase().trim() == "") {
      errArmUrl.value = "Enter Arm Url";
      return false;
    }
    if (!regex.hasMatch(armUrlController.text)) {
      errArmUrl.value = "Enter Valid Arm Url";
      return false;
    }
    //connection name
    if (conNameController.text.toString().trim() == "") {
      errName.value = "Enter Connection Name";
      return false;
    }
    if (conCaptionController.text.toString().trim() == "") {
      errCaption.value = "Enter Caption Name";
      return false;
    }

    return true;
  }

  Future<bool> validateConnectionName(String baseUrl) async {
    var url = baseUrl + ServerConnections.API_GET_SIGNINDETAILS;
    var body = "{\"appname\":\"" + conNameController.text.trim() + "\"}";
    final response = await serverConnections.postToServer(url: url, body: body);

    // LogService.writeOnConsole(message: "validateConnectionName(String $baseUrl)=> response: $response");

    if (response != "") {
      var json = jsonDecode(response);
      if (json["result"]["message"].toString().toLowerCase() == "success" && json["result"]["data"]["Value"] is! String)
        return true;
      else {
        errName.value = json["result"]["data"]["Value"].toString();
        return false;
      }
    }
    return false;
  }

  //-------------------------------
  void pickImageFromGalleryCalled() async {
    scannerController!.pause();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      scannerController!.start();
      return;
    }

    print(image.path);
    String path = image.path;
    BarcodeCapture? result = await scannerController!.analyzeImage(path, formats: [BarcodeFormat.all]);
    //print(result);

    if (result == null) {
      scannerController!.start();
      Get.snackbar("Invalid!", "Please choose a valid QR Code",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      var data = result.barcodes.first.rawValue ?? "";
      if (data == "" || !validateQRData(data)) {
        scannerController!.start();
        Get.snackbar("Invalid Data!", "Please choose a valid QR Code",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      } else
        decodeQRResult(data);
    }
  }

  void decodeQRResult(String data) {
    try {
      if (validateQRData(data)) {
        var json = jsonDecode(data);
        armUrlController.text = json['arm_url'];
        webUrlController.text = json['p_url'];
        conNameController.text = json['pname'];
        conCaptionController.text = json['pname'];
        // qrViewController!.stopCamera();
        scannerController!.stop();
        saveOrUpdateConnection(isQr: true);
      } else {
        Get.snackbar("Invalid!", "Please choose a valid QR Code",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      LogService.writeLog(message: "[ERROR] AddConnectionController\nScope: decodeQRResult()\nError: $e");
    }
  }

  validateQRData(data) {
    if (!data.toString().contains("arm_url")) return false;
    if (!data.toString().contains("p_url")) return false;
    if (!data.toString().contains("pname")) return false;
    if (!data.toString().contains("pname")) return false;
    return true;
  }

  doesDeviceHasFlash() {
    return true;
  }
}
