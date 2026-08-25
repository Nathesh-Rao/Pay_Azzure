import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/Const.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/controller/webview_controller.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_bundle_service.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_module.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/cached_save_item_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/queue_resolve_result_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/sync_progress_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/widgets/all_records_done_dialog.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/widgets/cached_refresh_dialog.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/widgets/cached_save_dialog.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/widgets/session_validation__dialog.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/widgets/sync_progress_dialog.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Page/LoginPage.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:axpertflutter/Utils/ServerConnections/InternetConnectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/form_field_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/form_page_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/offline_attachment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';

class OfflineFormController extends GetxController {
  late OfflineFormPageModel page;

  final Map<String, OfflineFormFieldModel> fieldMap = {};
  List<Map<String, dynamic>> allRawPages = [];
  var isLoading = false.obs;

  RxList<OfflineFormPageModel> allPages = <OfflineFormPageModel>[].obs;

  RxList<OfflineAttachmentModel> attachments = <OfflineAttachmentModel>[].obs;

  final ImagePicker _imagePicker = ImagePicker();

  // ================= OFFLINE DASHBOARD STATE =================

  var isConnected = false.obs;
  @override
  void onInit() {
    super.onInit();
    refreshPendingCount();
    listenInternetState();
    resetForm();
  }

/////////////////////////////////////////////////////////////////////////////
/////////////////////FROM INWRD ENTRY CONTROLLER////////////////////////////
/////////////////////////////////////////////////////////////////////////////

  ///------------------------------------------------------------
  Map<String, dynamic> schema = {};
  var isFormPreparing = false.obs;
  final Map<String, TextEditingController> textCtrls = {};
  final Map<String, RxString> dropdownCtrls = {};
  final ScrollController scrollCtrl = ScrollController();
  final errors = <String, String>{}.obs;
  final Map<String, List<Map<String, dynamic>>> datasourceMap = {};
  Map<String, dynamic> dc1SubmitFormJson = {};

  ///------------------------------------------------------------
  TextEditingController getTextCtrl(String name) => textCtrls[name]!;
  RxString getDropdownCtrl(String name) => dropdownCtrls[name]!;

  ///------------------------------------------------------------

  ///////////////////////////////////////

  Future<void> prepareForm(Map<String, dynamic> newSchema) async {
    isFormPreparing.value = true;
    page = OfflineFormPageModel.fromJson(newSchema);
    schema = newSchema;
    // 1. clear old stuff
    // resetForm();
    // scrollCtrl.animateTo(
    //   0,
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
    // 2. destroy old controllers
    for (final c in textCtrls.values) {
      c.dispose();
    }
    textCtrls.clear();
    dropdownCtrls.clear();

    // 3. rebuild from schema
    _buildControllersFromSchema();

    // 4. load datasources
    await loadDatasources();

    // 5. attach business rules
    _attachBusinessListeners();

    // 6. scroll to top
    if (scrollCtrl.hasClients) {
      scrollCtrl.jumpTo(0);
    }

    isFormPreparing.value = false;
    update();
  }

  void _buildControllersFromSchema() {
    final List fields = schema["fields"];

    for (final f in fields) {
      final String name = f["fld_name"];
      final String rawType = f["fld_type"];
      final String defValue = f["def_value"]?.toString() ?? "";
      final bool isUpper = rawType.endsWith("_upper");
      final String type = isUpper ? rawType.replaceAll("_upper", "") : rawType;
      if (type == "dd") {
        dropdownCtrls[name] = "".obs;

        if (defValue.isNotEmpty) {
          List<String> validOptions = getDropdownOptions(name);

          if (validOptions.contains(defValue)) {
            dropdownCtrls[name]!.value = defValue;
          }
        }
      } else {
        final ctrl = TextEditingController(text: defValue);

        if (isUpper) {
          ctrl.addListener(() {
            final String text = ctrl.text;
            final String formatted = text.toUpperCase();

            if (text != formatted) {
              int cursorPosition = ctrl.selection.baseOffset;

              ctrl.value = TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: cursorPosition),
              );
            }
          });
        }

        textCtrls[name] = ctrl;
      }
    }
  }

  List<String> getDropdownOptions(String fieldName) {
    if (!isFieldEnabled(fieldName)) return [];

    final fieldDef = (schema['fields'] as List).firstWhere(
      (e) => e['fld_name'] == fieldName,
      orElse: () => null,
    );
    if (fieldDef == null) return [];

    final String? dsName = fieldDef['datasource'];
    if (dsName == null || !datasourceMap.containsKey(dsName)) return [];

    List<Map<String, dynamic>> filteredList = datasourceMap[dsName]!;

    final List deps = fieldDef['dep_field'] ?? [];
    if (deps.isNotEmpty) {
      filteredList = filteredList.where((row) {
        for (final parentKey in deps) {
          final parentSelected = dropdownCtrls[parentKey]?.value ?? "";

          // Data Match Logic
          String rowVal = row[parentKey]?.toString() ?? "";
          if (rowVal.endsWith(".0")) rowVal = rowVal.replaceAll(".0", "");

          String parentVal = parentSelected;
          if (parentVal.endsWith(".0"))
            parentVal = parentVal.replaceAll(".0", "");

          if (rowVal.toLowerCase() != parentVal.toLowerCase()) return false;
        }
        return true;
      }).toList();
    }

    final Set<String> uniqueValues = {};
    for (final row in filteredList) {
      final val = row[fieldName]?.toString();
      if (val != null && val.isNotEmpty) uniqueValues.add(val);
    }

    return uniqueValues.toList()..sort();
  }

  bool isFieldEnabled(String fieldName) {
    final fieldDef = (schema['fields'] as List).firstWhere(
      (e) => e['fld_name'] == fieldName,
      orElse: () => null,
    );

    if (fieldDef == null) return true;

    final List deps = fieldDef['dep_field'] ?? [];

    if (deps.isEmpty) return true;

    for (final parentKey in deps) {
      final parentValue = dropdownCtrls[parentKey]?.value ?? "";
      if (parentValue.isEmpty) {
        return false;
      }
    }

    return true;
  }

  Future<void> loadDatasources() async {
    datasourceMap.clear();

    final List fields = schema["fields"];
    final Set<String> needed = {};

    for (final f in fields) {
      if (f["datasource"] != null && f["datasource"].toString().isNotEmpty) {
        needed.add(f["datasource"]);
      }
    }

    for (final ds in needed) {
      final list = await OfflineDbModule.getDatasourceOptions(
          transId: schema["transid"], datasource: ds);
      datasourceMap[ds] = List<Map<String, dynamic>>.from(list);
    }

    update();
  }

  void _attachBusinessListeners() {
    //ANY BSNS LOGICS GOES HERE
    // getTextCtrl("billed_qty_bags_crates").addListener(_onReceivedChanged);
    // ever(getTextCtrl("eceived_bags_crates"), (_){
    //   _onReceivedChanged();
    // });
    // getTextCtrl("bags_sample").addListener(_recheckMiniFab);
    // getTextCtrl("loaded_truck").addListener(_calculateNetWeight);
    // getTextCtrl("empty_truck").addListener(_calculateNetWeight);
    // getTextCtrl("received_bags_crates").addListener(_checkForBilledQty);
    // getTextCtrl("billed_qty_bags_crates").addListener(_checkForBilledQty);
    // getDropdownCtrl("packing").listen((_) {
    //   _onReceivedChanged();
    // });

    // ever(getDropdownCtrl("packing"), (_) {
    //   _onReceivedChanged();
    // });
  }

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

  Future<void> refreshPendingCount() async {
    try {
      int count = await OfflineDbModule.getPendingCount();
      pendingCount.value = count;
      await refreshPendingQueuesCount();
    } catch (e) {
      print("Error fetching pending count: $e");
    }
  }

  Future<void> refreshPendingQueuesCount() async {
    try {
      var rows = await OfflineDbModule.getPendigQueuesToRefresh();
      pendingQueuesCount.value = rows.length;
    } catch (e) {
      print("Error fetching pending count: $e");
    }
  }

  void listenInternetState() async {
    final InternetConnectivity net = Get.find<InternetConnectivity>();

    isConnected.value = await net.check();

    ever<bool>(net.isConnected, (connected) {
      isConnected.value = connected;
    });
  }

  Map<String, dynamic>? offlineUser;
  var offlineFormsCount = 0.obs;
  var pendingCount = 0.obs;
  var pendingQueuesCount = 0.obs;

  bool isDashboardBusy = false;

  ///////////////////////////////////////

  // ---------------- LOAD ALL PAGES ----------------

  Future<void> getAllPages() async {
    const String tag = "[OFFLINE_PAGES_LOAD_001]";
    try {
      isLoading.value = true;

      final rawPages = allRawPages = await OfflineDbModule.getOfflinePages();

      if (rawPages.isEmpty) {
        LogService.writeLog(
          message: "$tag[INFO] No offline pages in DB",
        );
        allPages.clear();
        return;
      }

      final pages = rawPages
          .map((e) => OfflineFormPageModel.fromJson(e))
          .where((p) => p.visible)
          .toList();

      allPages.value = pages;

      LogService.writeLog(
        message: "$tag[SUCCESS] Loaded ${pages.length} pages from DB",
      );
    } catch (e, st) {
      LogService.writeLog(
        message: "$tag[FAILED] Failed to load offline pages => $e",
      );
      LogService.writeLog(
        message: "$tag[STACK] $st",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPage(OfflineFormPageModel pageModel) async {
    var tempPage =
        await OfflineDbModule.mapDatasourceOptionsIntoPages(pages: [pageModel]);
    page = tempPage.first;
    fieldMap.clear();
    attachments.clear();

    final sortedFields = [...page.fields]
      ..sort((a, b) => a.order.compareTo(b.order));

    for (final field in sortedFields) {
      field.value = field.defValue;
      field.errorText = null;
      fieldMap[field.fldName] = field;
    }
    Get.toNamed(Routes.OfflineFormPage);
  }

  void updateFieldValue(OfflineFormFieldModel field, dynamic newValue) {
    final bool isDs = field.datasource != null && field.datasource!.isNotEmpty;

    switch (field.fldType) {
      case 'cb':
        field.value =
            (newValue == true || newValue.toString().toLowerCase() == 'true')
                .toString();
        break;

      case 'cl':
        if (isDs) {
          // datasource checklist → store list of IDs
          if (newValue is List) {
            field.value = newValue;
          }
        } else {
          // normal checklist → old behavior
          if (newValue is List<String>) {
            field.value = newValue.join(',');
          }
        }
        break;

      case 'rb':
      case 'rl':
      case 'dd':
        if (isDs) {
          field.value = newValue;
        } else {
          field.value = newValue.toString();
        }
        break;

      case 'c':
      case 'n':
      case 'm':
      case 'd':
        field.value = newValue.toString();
        break;

      case 'image':
        field.value = newValue.toString();
        break;

      default:
        field.value = newValue;
        break;
    }

    field.errorText = null;
    fieldMap[field.fldName] = field;
    update([field.fldName]);
  }

  bool validateForm() {
    bool isFormValid = true;

    for (final field in fieldMap.values) {
      final value = field.value.trim();
      bool isValid = true;

      /// allowempty = T means NOT mandatory
      if (field.allowEmpty) {
        field.errorText = null;
        continue;
      }

      switch (field.fldType) {
        case 'cb':
          isValid = value.toLowerCase() == 'true';
          break;

        case 'cl':
          isValid =
              value.split(',').where((e) => e.trim().isNotEmpty).isNotEmpty;
          break;

        default:
          isValid = value.isNotEmpty;
          break;
      }

      if (!isValid) {
        isFormValid = false;
        field.errorText = '${field.fldCaption} is required';
      } else {
        field.errorText = null;
      }

      fieldMap[field.fldName] = field;
      update([field.fldName]);
    }

    return isFormValid;
  }

  void resetForm() {
    for (final c in textCtrls.values) {
      c.clear();
    }
    for (final d in dropdownCtrls.values) {
      d.value = "";
    }
    // clearSampleGrid();
    // showMiniFab.value = false;
    // sampleSummaryJson.clear();
    dc1SubmitFormJson.clear();
    errors.clear();
  }

  // ---------------- COLLECT DATA ----------------

  Map<String, dynamic> collectFormData() {
    final Map<String, dynamic> data = {};

    for (final field in fieldMap.values) {
      data[field.fldName] = field.value;
    }

    return data;
  }

  // ---------------- HELPERS ----------------

  OfflineFormFieldModel? getField(String fldName) {
    return fieldMap[fldName];
  }

  String getFieldValue(String fldName) {
    return fieldMap[fldName]?.value ?? '';
  }

  bool isFieldFilled(String fldName) {
    final v = fieldMap[fldName]?.value.trim() ?? '';
    return v.isNotEmpty;
  }

  Future<void> pickImage({
    required OfflineFormFieldModel field,
    required ImageSource source,
  }) async {
    if (field.readOnly) return;

    final XFile? file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 75,
    );

    if (file == null) {
      _showImageNotSelectedMsg();
      return;
    }

    final bytes = await File(file.path).readAsBytes();
    final base64 = base64Encode(bytes);

    updateFieldValue(field, base64);
  }

  void removeImage(OfflineFormFieldModel field) {
    if (field.readOnly) return;
    updateFieldValue(field, '');
  }

  void _showImageNotSelectedMsg() {
    Get.snackbar(
      'Image not selected',
      'Please select an image to continue',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> pickAttachment() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result == null || result.files.isEmpty) {
      Get.snackbar(
        'No file selected',
        'Please select a file to attach',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    for (final f in result.files) {
      if (f.path == null) continue;

      attachments.add(
        OfflineAttachmentModel(
          name: f.name,
          path: f.path!,
          extension: f.extension ?? '',
        ),
      );
    }
  }

  void removeAttachment(OfflineAttachmentModel file) {
    attachments.remove(file);
  }

  IconData getAttachmentIcon(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'mp4':
      case 'mov':
        return Icons.videocam;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color getAttachmentColor(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return Colors.redAccent;

      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.blueAccent;

      case 'doc':
      case 'docx':
        return Colors.indigo;

      case 'xls':
      case 'xlsx':
        return Colors.green;

      case 'mp4':
      case 'mov':
        return Colors.deepPurple;

      default:
        return Colors.grey;
    }
  }

  String getAttachmentTypeSummary() {
    if (attachments.isEmpty) return '';

    int images = 0;
    int docs = 0;
    int videos = 0;
    int others = 0;

    for (final file in attachments) {
      final ext = file.extension.toLowerCase();

      if (['jpg', 'jpeg', 'png'].contains(ext)) {
        images++;
      } else if (['doc', 'docx', 'pdf', 'xls', 'xlsx'].contains(ext)) {
        docs++;
      } else if (['mp4', 'mov'].contains(ext)) {
        videos++;
      } else {
        others++;
      }
    }

    final List<String> parts = [];

    if (images > 0) parts.add('$images image${images > 1 ? 's' : ''}');
    if (docs > 0) parts.add('$docs doc${docs > 1 ? 's' : ''}');
    if (videos > 0) parts.add('$videos video${videos > 1 ? 's' : ''}');
    if (others > 0) parts.add('$others file${others > 1 ? 's' : ''}');

    return parts.join(', ');
  }

  Future<bool> guardOnlineOrShowDialog() async {
    final connectivity = Get.find<InternetConnectivity>();

    if (connectivity.isConnected.value) return true;

    await Get.dialog(
      AlertDialog(
        title: const Text("No Internet"),
        content: const Text("This action requires internet connection."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    return false;
  }

  Future<void> confirmAndRun({
    required String title,
    required String message,
    required Future<void> Function() action,
  }) async {
    if (isDashboardBusy) return;

    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    isDashboardBusy = true;
    update();

    try {
      await action();
      // await loadOfflineDashboard();
    } finally {
      isDashboardBusy = false;
      update();
    }
  }
  // ================= DASHBOARD ACTIONS =================

  void goToOfflineForms() {
    Get.toNamed(Routes.OfflineListingPage);
  }

// ---------- SYNC ----------

  Future<void> refetchAll() async {
    if (!await guardOnlineOrShowDialog()) return;

    await confirmAndRun(
      title: "Refetch Everything",
      message: "This will re-download all forms and datasources. Continue?",
      action: () async {
        await OfflineDbModule.syncAllData(isInternetAvailable: true);
      },
    );
  }

  Future<void> refetchForms() async {
    if (!await guardOnlineOrShowDialog()) return;

    await confirmAndRun(
      title: "Refetch Forms",
      message: "This will re-download all forms. Continue?",
      action: () async {
        await OfflineDbModule.refetchOnlyForms();
      },
    );
  }

  Future<void> refetchDatasources() async {
    if (!await guardOnlineOrShowDialog()) return;

    await confirmAndRun(
      title: "Refetch Datasources",
      message: "This will re-download all datasources. Continue?",
      action: () async {
        // await OfflineDbModule.refetchOnlyDatasources();
      },
    );
  }

// ---------- CLEAR ----------

  Future<void> clearAllCache() async {
    await confirmAndRun(
      title: "Clear All Cache",
      message: "This will delete all offline data except user. Continue?",
      action: () async {
        // await OfflineDbModule.clearOfflineCache();
      },
    );
  }

  Future<void> clearForms() async {
    await confirmAndRun(
      title: "Clear Forms",
      message: "This will delete all offline forms. Continue?",
      action: () async {
        // await OfflineDbModule.deleteTable(
        //   OfflineDBConstants.TABLE_OFFLINE_PAGES,
        // );
      },
    );
  }

  Future<void> clearDatasources() async {
    await confirmAndRun(
      title: "Clear Datasources",
      message: "This will delete all cached datasources. Continue?",
      action: () async {
        // await OfflineDbModule.deleteTable(
        //   OfflineDBConstants.TABLE_DATASOURCE_DATA,
        // );
      },
    );
  }

  Future<void> clearPending() async {
    await confirmAndRun(
      title: "Clear Pending Uploads",
      message: "This will delete all pending uploads. Continue?",
      action: () async {
        refreshPendingCount();
      },
    );
  }

  Future<void> actionRefetchForms() async {
    const tag = "[OFFLINE_ACTION_REFETCH_FORMS_001]";

    if (!await _isInternetAvailable()) {
      _showNeedInternetDialog();
      return;
    }

    final ok = await _confirm(
      title: "Refetch Forms",
      message: "This will replace all offline forms. Continue?",
    );
    if (!ok) return;

    try {
      isLoading.value = true;

      await OfflineDbModule.fetchAndStoreOfflinePages();
      await getAllPages();
      // await loadOfflineDashboard();

      Get.snackbar("Success", "Forms refreshed");
      LogService.writeLog(message: "$tag[SUCCESS]");
    } catch (e, st) {
      LogService.writeLog(message: "$tag[FAILED] $e");
      LogService.writeLog(message: "$tag[STACK] $st");
      Get.snackbar("Error", "Failed to refetch forms");
    } finally {
      isLoading.value = false;
    }
  }

  void actionShowPending() {}
  Future<void> actionClearForms() async {
    const tag = "[OFFLINE_ACTION_CLEAR_FORMS_001]";

    final ok = await _confirm(
      title: "Clear Forms",
      message: "This will delete all offline forms. Continue?",
    );
    if (!ok) return;

    try {
      isLoading.value = true;

      await OfflineDbModule.clearOfflinePages();
      await getAllPages();
      // await loadOfflineDashboard();

      Get.snackbar("Done", "Offline forms cleared");
      LogService.writeLog(message: "$tag[SUCCESS]");
    } catch (e, st) {
      LogService.writeLog(message: "$tag[FAILED] $e");
      LogService.writeLog(message: "$tag[STACK] $st");
      Get.snackbar("Error", "Failed to clear forms");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> actionClearDatasources() async {
    const tag = "[OFFLINE_ACTION_CLEAR_DS_001]";

    final ok = await _confirm(
      title: "Clear Datasources",
      message: "This will delete all cached datasources. Continue?",
    );
    if (!ok) return;

    try {
      isLoading.value = true;

      await OfflineDbModule.clearDatasources();

      Get.snackbar("Done", "Datasources cleared");
      LogService.writeLog(message: "$tag[SUCCESS]");
    } catch (e, st) {
      LogService.writeLog(message: "$tag[FAILED] $e");
      LogService.writeLog(message: "$tag[STACK] $st");
      Get.snackbar("Error", "Failed to clear datasources");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> actionClearPending() async {
    const tag = "[OFFLINE_ACTION_CLEAR_PENDING_001]";

    final ok = await _confirm(
      title: "Clear Pending Queue",
      message: "This will delete all pending submissions. Continue?",
    );
    if (!ok) return;

    try {
      isLoading.value = true;

      await OfflineDbModule.clearPendingQueue();

      Get.snackbar("Done", "Pending queue cleared");
      LogService.writeLog(message: "$tag[SUCCESS]");
    } catch (e, st) {
      LogService.writeLog(message: "$tag[FAILED] $e");
      LogService.writeLog(message: "$tag[STACK] $st");
      Get.snackbar("Error", "Failed to clear pending queue");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> actionClearAll() async {
    const tag = "[OFFLINE_ACTION_CLEAR_ALL_001]";

    final ok = await _confirm(
      title: "Clear ALL Offline Data",
      message: "This will delete ALL offline data except user. Continue?",
      okText: "Yes, Delete",
    );
    if (!ok) return;

    try {
      isLoading.value = true;

      await OfflineDbModule.clearAllExceptUser();
      await getAllPages();
      // await loadOfflineDashboard();
      refreshPendingCount();
      Get.snackbar("Done", "All offline data cleared");
      LogService.writeLog(message: "$tag[SUCCESS]");
    } catch (e, st) {
      LogService.writeLog(message: "$tag[FAILED] $e");
      LogService.writeLog(message: "$tag[STACK] $st");
      Get.snackbar("Error", "Failed to clear all data");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    String subtitle = '',
    String okText = "Yes",
    String cancelText = "Cancel",
    IconData icon = Icons.help_outline_rounded,
    Color confirmColor = const Color(0xFF2563EB),
    TextAlign? messageTextAlign,
    Color? highLightColor,
    Color? subtitleColor,
  }) async {
    bool result = false;

    Widget _parseText(String text, TextStyle baseStyle, {TextAlign? align}) {
      if (!text.contains("**")) {
        return Text(text,
            textAlign: align ?? TextAlign.center, style: baseStyle);
      }

      final parts = text.split("**");
      return Text.rich(
        TextSpan(
          children: parts.map((part) {
            final isBold = parts.indexOf(part) % 2 != 0;
            return TextSpan(
              text: part,
              style: isBold
                  ? baseStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: highLightColor ?? Colors.grey[600])
                  : baseStyle,
            );
          }).toList(),
        ),
        textAlign: align ?? TextAlign.center,
      );
    }

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: confirmColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: confirmColor),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              if (subtitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _parseText(
                    subtitle,
                    GoogleFonts.poppins(
                      fontSize: 14,
                      color: subtitleColor ?? Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              _parseText(
                message,
                align: messageTextAlign,
                GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        result = false;
                        Get.back();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: Colors.grey[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        result = true;
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        okText,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    return result;
  }

  Future<bool> _isInternetAvailable() async {
    try {
      final conn = Get.find<InternetConnectivity>();
      return await conn.check();
    } catch (_) {
      return false;
    }
  }

  void _showNeedInternetDialog() {
    Get.defaultDialog(
      title: "No Internet",
      middleText: "This action requires an internet connection.",
      textConfirm: "OK",
      onConfirm: Get.back,
    );
  }

  Future<void> actionPushPending() async {
    const tag = "[OFFLINE_ACTION_PUSH_PENDING]";

    if (!await _isInternetAvailable()) {
      _showNeedInternetDialog();
      return;
    }
    var pendingCount = await OfflineDbModule.getPendingCount();
    if (pendingCount == 0) {
      await _confirm(
        title: "No Pending Data",
        message:
            "There is no pending data available.\n\nYou can try saving new forms offline to use this feature",
        okText: "Okay",
        icon: Icons.indeterminate_check_box_outlined,
        confirmColor: const Color.fromARGB(255, 235, 103, 37),
      );
      return;
    }

    final ok = await _confirm(
      title: "Upload Pending Data",
      message:
          "This will upload $pendingCount locally saved records to the server.\n\nAre you sure you want to continue?",
      okText: "Upload Now",
      icon: Icons.cloud_upload_rounded,
      confirmColor: const Color(0xFF2563EB),
    );
    if (!ok) return;
    final progressModel = SyncProgressModel(initialTitle: "Uploading Data");
    Get.dialog(
      SyncProgressDialog(
        progressModel: progressModel,
        reTry: actionPushPending,
        showForcePush: true,
      ),
      barrierDismissible: false,
    );
    try {
      final resultMsg = await OfflineDbModule.processPendingQueue(
        isInternetAvailable: true,
        progress: progressModel,
      );
      log(resultMsg);
      // Get.back();

      // _showSimpleSuccessDialog(title: "Upload Complete", message: resultMsg);
      refreshPendingCount();
      // LogService.writeLog(message: "$tag[DONE] $resultMsg");
    } catch (e, st) {
      // Get.back(); // Ensure dialog closes
      LogService.writeLog(message: "$tag[FAILED] $e \n$st");
      refreshPendingCount();
      Get.snackbar(
        "Upload Error",
        "Failed to process queue. Check logs.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        icon: const Icon(Icons.warning, color: Colors.white),
      );
    } finally {
      log("progress complete called here 4");
      isLoading.value = false;
      // progressModel.completeWithError(errorMsg: "errorMsg");
    }
  }

  Future<void> onForcePushClicked(SyncProgressModel model) async {
    final isOnline = await Get.find<InternetConnectivity>().check();
    final bool ok = await _confirm(
      title: "Confirm Force Push",
      subtitle:
          "**This action will upload failed records to the server log and delete them permanently from this device**.",
      message: "**Important Notes:**"
          "• You can only access this data via the **Web Instance**."
          "• Successfully forced records **cannot be retried** for normal syncing.\n\n"
          "**Are you sure you want to proceed?**",
      okText: "Yes, Force Push",
      confirmColor: Colors.redAccent,
      icon: Icons.warning_amber_rounded,
    );

    if (!ok) return;
    await OfflineDbModule.forcePushFailedRecords(
      isInternetAvailable: isOnline,
      progress: model,
    );
  }

  Future<void> actionSyncAll() async {
    const tag = "[OFFLINE_ACTION_SYNC_ALL]";

    if (!await _isInternetAvailable()) {
      _showNeedInternetDialog();
      return;
    }

    final ok = await _confirm(
      title: "Full Sync",
      message:
          "This will sync pending uploads, forms, and datasources.\n\nContinue?",
      okText: "Start Sync",
    );
    if (!ok) return;

    final progressModel = SyncProgressModel(initialTitle: "Full Sync");

    progressModel.init(total: 3, msg: "Initializing...");
    Get.dialog(
      SyncProgressDialog(progressModel: progressModel),
      barrierDismissible: false,
    );

    try {
      progressModel.updateMessage("Step 1/3: Uploading pending data...");

      final pushResult = await OfflineDbModule.processPendingQueue(
        isInternetAvailable: true,
      );
      LogService.writeLog(message: "$tag[STEP_1] $pushResult");
      progressModel.increment();
      progressModel.updateMessage("Step 2/3: Checking for new forms...");
      final pages = await OfflineDbModule.fetchAndStoreOfflinePages();
      if (pages.isEmpty) {
        progressModel.increment(isSuccess: false);
        progressModel.updateMessage("Sync Failed: NO OFFLINE PAGES");
        isLoading.value = false;
        progressModel.complete();
        return;
      }
      await getAllPages(); // Refresh the list in memory
      LogService.writeLog(
          message: "$tag[STEP_2] Fetched ${pages.length} forms");
      progressModel.increment();
      progressModel.updateMessage("Step 3/3: Updating datasources...");
      await OfflineDbModule.refreshAllDatasourcesFromDownloadedPages(
          isrefetching: true);
      LogService.writeLog(message: "$tag[STEP_3] Datasources updated");
      refreshPendingCount();
      progressModel.increment();
      progressModel.updateMessage(
          "Sync Complete!\nForms: ${pages.length} updated\nUploads: $pushResult");

      // Show the "Close" button and Green Check
      progressModel.complete();
    } catch (e, st) {
      progressModel.updateMessage("Sync Failed: $e");
      progressModel.complete();
      LogService.writeLog(message: "$tag[FAILED] $e");
      LogService.writeLog(message: "$tag[STACK] $st");

      Get.snackbar(
        "Sync Failed",
        "Something went wrong. Please check logs.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> actionRefetchDatasources() async {
    if (!await _isInternetAvailable()) {
      _showNeedInternetDialog();
      return;
    }

    final ok = await _confirm(
      title: "Refetch Datasources",
      message:
          "This will re-download lookup data for all downloaded forms. Continue?",
    );
    if (!ok) return;

    try {
      isLoading.value = true;

      SyncProgressModel progressModel =
          SyncProgressModel(initialTitle: "Refetching Datasources");
      // Open the dialog immediately
      Get.dialog(
        SyncProgressDialog(
          progressModel: progressModel,
          reTry: actionRefetchDatasources,
        ),
        barrierDismissible: false,
      );

      await OfflineDbModule.refreshAllDatasourcesFromDownloadedPages(
          progressModel: progressModel, isrefetching: true);

      progressModel.complete();
    } catch (e) {
      Get.snackbar("Error", "Failed to update datasources");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onReportCardClick(String transId) async {
    WebViewController webViewController = Get.find();
    var urlNew = "aspx/AxMain.aspx?authKey=AXPERT-" +
        AppStorage().retrieveValue(AppStorage.SESSIONID) +
        "&pname=" +
        transId;
    webViewController.openWebView(url: Const.getFullWebUrl(urlNew));
  }

  Future<void> saveAudit({
    required String action,
    bool isError = false,
    String? response,
    String? remarks,
  }) async {
    await OfflineDbModule.logAudit(
      action: action,
      isError: isError,
      response: response,
      remarks: remarks,
    );
  }

  Future<void> actionExportDatabaseOld() async {
    try {
      isLoading.value = true;
      final bundle = await OfflineBundleService.createExportBundle();

      if (bundle == null) return;

      Get.dialog(
        AlertDialog(
          title: const Text("Export Database"),
          content:
              const Text("Choose an action for your secure offline bundle."),
          actions: [
            TextButton(
              child: const Text("Share"),
              onPressed: () {
                Get.back();
                _handleShare(bundle.path);
              },
            ),
            TextButton(
              child: const Text("Download"),
              onPressed: () {
                Get.back();
                _handleDownload(bundle.path);
              },
            ),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar("Export Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> actionExportDatabase() async {
    final String? choice = await _showExportChoiceDialog();
    if (choice == null) return;

    try {
      isLoading.value = true;

      if (choice == "full") {
        Get.showSnackbar(GetSnackBar(
          icon: CupertinoActivityIndicator(
            color: Colors.white,
          ),
          title: "Please Wait",
          message: "Packaging DB and underscore-pathed assets...",
          backgroundColor: MyColors.blue10,
          isDismissible: false,
        ));
        final File? bundle = await OfflineBundleService.createExportBundle();
        Get.back();
        if (bundle == null) {
          Get.snackbar("Export Failed", "Could not create export bundle.");
          return;
        }
        Get.dialog(
          AlertDialog(
            title: const Text("Export Database"),
            content:
                const Text("Choose an action for your secure offline bundle."),
            actions: [
              TextButton(
                child: const Text("Share"),
                onPressed: () {
                  Get.back();
                  _handleShare(bundle.path);
                },
              ),
              TextButton(
                child: const Text("Download"),
                onPressed: () {
                  Get.back();
                  _handleDownload(bundle.path);
                },
              ),
            ],
          ),
        );
        await OfflineDbModule.logAudit(
          action: "bundleAction",
          remarks: "User exported full bundle with images.",
        );
      } else if (choice == "db_only") {
        try {
          await OfflineBundleService.uploadDBFile();
          Get.snackbar("Upload Successful", "DB file uploaded to server.",
              backgroundColor: Colors.green, colorText: Colors.white);
        } catch (e) {
          Get.snackbar("Upload Failed", e.toString(),
              backgroundColor: Colors.red, colorText: Colors.white);
        }

        // await OfflineDbModule.logAudit(
        //   action: "bundleAction",
        //   remarks: "User exported DB file only.",
        // );
      }
    } catch (e) {
      Get.snackbar("Export Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _showExportChoiceDialog() async {
    String? result;

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.upload_rounded,
                    size: 30, color: Color(0xFF2563EB)),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                "Export Data",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                "Choose what to export",
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 6),
              _bulletPoint(
                  "Full Bundle — includes DB + all attached images (.axbundle)."),
              _bulletPoint(
                  "DB Only — exports just the database file (.db). No images included."),
              const SizedBox(height: 24),

              // Cancel
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    result = null;
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Text("CANCEL",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 8),

              // Full bundle
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.folder_zip_rounded),
                  label: Text("EXPORT FULL BUNDLE",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  onPressed: () {
                    result = "full";
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // DB only
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.storage_rounded),
                  label: Text("EXPORT DB ONLY",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  onPressed: () {
                    result = "db_only";
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    return result;
  }

  Future<void> _handleShare(String path) async {
    await SharePlus.instance.share(
      ShareParams(files: [XFile(path)], text: 'Secure Offline Bundle'),
    );
    await _logAudit();
  }

  Future<void> _handleDownload1(String sourcePath) async {
    try {
      File sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw Exception('Bundle file not found at $sourcePath');
      }

      String fileName = sourcePath.split('/').last;
      Uint8List fileBytes = await sourceFile.readAsBytes();

      final String? targetPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Bundle to Downloads',
        fileName: fileName,
        bytes: fileBytes,
      );

      if (targetPath != null) {
        Get.snackbar("File Saved", "Bundle saved successfully",
            colorText: Colors.white, backgroundColor: MyColors.green);
        await _logAudit();
      }
    } catch (e) {
      log(e.toString(), name: "DOWNLOAD BUNDLE");
      Get.snackbar("Download Error", e.toString(),
          colorText: Colors.white, backgroundColor: MyColors.maroon);
    }
  }

  static const _mediaScanner =
      MethodChannel('com.agile.ub_bottleapp/media_scanner');

  Future<void> _handleDownload(String filePath) async {
    try {
      final fileName = basename(filePath);

      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final destPath = join(downloadsDir.path, fileName);
      await File(filePath).copy(destPath);

      await _mediaScanner.invokeMethod('scanFile', {'path': destPath});

      Get.snackbar(
        "Downloaded",
        "Saved to Downloads/$fileName",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Download Failed", e.toString());
    }
  }

  Future<void> _logAudit() async {
    await OfflineDbModule.logAudit(
        action: "DB_BUNDLE_EXPORT", remarks: "Bundled DB and images.");
  }

  // actionImportDatabase1() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['db'],
  //   );
  //   if (result == null || result.files.single.path == null) return;

  //   File dbFile = File(result.files.single.path!);
  //   await DatabaseHelper.instance.replaceDatabase(dbFile);
  // }

  Future<void> actionImportDatabaseOld() async {
    try {
      final bool backupExists = await OfflineBundleService.hasBackup();

      if (backupExists) {
        final meta = await OfflineBundleService.getBackupMeta();
        final String backupInfo = meta != null
            ? "Made on ${meta['displayTime']} by ${meta['user']}"
            : "A previous backup is available.";

        final String? choice = await _showBackupChoiceDialog(backupInfo);

        if (choice == null) return;

        if (choice == "restore") {
          final bool? ok = await _confirm(
            title: "Restore Previous Backup",
            subtitle: backupInfo,
            message:
                "**CAUTION:** This will replace your current data with the backup. Proceed?",
            icon: Icons.history_rounded,
            confirmColor: Colors.orange,
            okText: "RESTORE BACKUP",
            cancelText: "CANCEL",
          );
          if (ok == true) {
            await _executeRestore();
          }
          return;
        }
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['axbundle', 'zip'],
      );
      if (result == null || result.files.single.path == null) return;

      File bundleFile = File(result.files.single.path!);
      String fileName = basename(bundleFile.path);

      final bool? ok = await _confirm(
        title: "Import Data Bundle",
        subtitle: "Selected: $fileName",
        message:
            "**CAUTION:** This will permanently **DELETE** your current local data and logs. "
            "Your current data will be auto-backed up first. "
            "You must login with the **SAME credentials** to use this data. Proceed?",
        icon: Icons.settings_backup_restore_rounded,
        confirmColor: Colors.redAccent,
        okText: "IMPORT NOW",
        cancelText: "KEEP CURRENT",
      );

      if (ok == true) {
        await _executeImport(bundleFile);
      }
    } catch (e) {
      Get.snackbar("Error", "Could not process bundle: $e");
    }
  }

  Future<void> actionImportDatabase() async {
    try {
      final bool backupExists = await OfflineBundleService.hasBackup();

      if (backupExists) {
        final meta = await OfflineBundleService.getBackupMeta();
        final String backupInfo = meta != null
            ? "Made on ${meta['displayTime']} by ${meta['user']}"
            : "A previous backup is available.";

        final String? choice = await _showBackupChoiceDialog(backupInfo);

        if (choice == null) return;

        if (choice == "restore") {
          final bool? ok = await _confirm(
            title: "Restore Previous Backup",
            subtitle: backupInfo,
            message:
                "**CAUTION:** This will replace your current data with the backup. Proceed?",
            icon: Icons.history_rounded,
            confirmColor: Colors.orange,
            okText: "RESTORE BACKUP",
            cancelText: "CANCEL",
          );
          if (ok == true) {
            await _executeRestore();
          }
          return;
        }
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['axbundle', 'zip', 'db'], // 👈 added 'db'
      );
      if (result == null || result.files.single.path == null) return;

      File bundleFile = File(result.files.single.path!);
      String fileName = basename(bundleFile.path);
      final bool isDbOnly =
          fileName.toLowerCase().endsWith('.db'); // 👈 detect .db

      final bool? ok = await _confirm(
        title: isDbOnly ? "Import DB File" : "Import Data Bundle",
        subtitle: "Selected: $fileName",
        message: isDbOnly
            ? "**CAUTION:** This will permanently replace your current database. "
                "Your current data will be auto-backed up first. Proceed?"
            : "**CAUTION:** This will permanently **DELETE** your current local data and logs. "
                "Your current data will be auto-backed up first. "
                "You must login with the **SAME credentials** to use this data. Proceed?",
        icon: Icons.settings_backup_restore_rounded,
        confirmColor: Colors.redAccent,
        okText: "IMPORT NOW",
        cancelText: "KEEP CURRENT",
      );
      Get.showSnackbar(GetSnackBar(
        icon: CupertinoActivityIndicator(
          color: Colors.white,
        ),
        title: "Please Wait",
        message: "Unpacking DB and other details",
        backgroundColor: MyColors.blue10,
        isDismissible: false,
      ));
      if (ok == true) {
        if (isDbOnly) {
          await _executeDbOnlyImport(bundleFile);
        } else {
          await _executeImport(bundleFile);
        }
      }
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Could not process file: $e");
    }
  }

  Future<void> _executeDbOnlyImport(File file) async {
    try {
      isLoading.value = true;

      debugPrint("[IMPORT_DB_ONLY] Backing up current DB before import...");
      await OfflineBundleService.backupCurrentDatabase();

      await OfflineBundleService.importDbOnly(file);
      await getAllPages();
      await refreshPendingCount();
      await OfflineDbModule.logAudit(
        action: "DB_IMPORT_DB_ONLY",
        remarks: "User imported a raw .db file directly.",
      );
      _confirm(
        title: "Success",
        message:
            "Database replaced successfully. A backup of your previous data was saved automatically. "
            "Please ensure you are logged in as the correct user.",
        okText: "Done",
      );
    } catch (e) {
      Get.snackbar("Import Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _showBackupChoiceDialog(String backupInfo) async {
    String? result;

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon Circle ──────────────────────────────────────────────
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.history_rounded,
                    size: 30, color: Colors.orange),
              ),
              const SizedBox(height: 20),

              // ── Title ────────────────────────────────────────────────────
              Text(
                "Previous Backup Found",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // ── Backup Info Subtitle ─────────────────────────────────────
              Text(
                backupInfo,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.orange[700],
                ),
              ),
              const SizedBox(height: 16),

              // ── Body Message ─────────────────────────────────────────────
              Text(
                "What would you like to do?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              _bulletPoint(
                  "Restore Backup — rolls back to the snapshot taken before your last import."),
              _bulletPoint(
                  "Import New File — pick a new .axbundle (your current data will be backed up first)."),
              const SizedBox(height: 24),

              // ── Cancel ───────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    result = null;
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Text(
                    "CANCEL",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ── Restore Backup ───────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.history_rounded),
                  label: Text(
                    "RESTORE BACKUP",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    result = "restore";
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ── Import New ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.folder_open_rounded),
                  label: Text(
                    "IMPORT NEW FILE",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    result = "import_new";
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    return result;
  }

  Future<void> _executeRestore() async {
    try {
      isLoading.value = true;
      await OfflineBundleService.restoreBackup();
      await OfflineDbModule.init();
      await getAllPages();
      await refreshPendingCount();
      await OfflineBundleService.deleteBackup();
      await OfflineDbModule.logAudit(
          action: "DB_BACKUP_RESTORE",
          remarks: "User restored the pre-import backup.");
      _confirm(
        title: "Backup Restored",
        message:
            "Your previous data has been restored successfully. Please ensure you are logged in as the correct user.",
        okText: "Done",
      );
    } catch (e) {
      Get.snackbar("Restore Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _executeImport(File file) async {
    try {
      isLoading.value = true;

      debugPrint("[IMPORT] Backing up current DB before import...");
      await OfflineBundleService.backupCurrentDatabase();

      await OfflineBundleService.importBundleNew(file);
      await OfflineDbModule.init();
      await getAllPages();
      await refreshPendingCount();
      await OfflineDbModule.logAudit(
          action: "DB_IMPORT_SUCCESS",
          remarks: "User successfully imported and remapped a bundle.");
      _confirm(
        title: "Success",
        message:
            "Database restored and remapped successfully. A backup of your previous data was saved automatically. "
            "Please ensure you are logged in as the correct user.",
        okText: "Done",
      );
    } catch (e) {
      Get.snackbar("Import Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////
  //////////////CACHED_SAVE//////////////////////
  ////////////////////////////////////////////////////////

  Future<bool> validateSession() async {
    try {
      final Map<String, dynamic> payload = {
        "ARMSessionId": await AppStorage().retrieveValue(AppStorage.SESSIONID)
      };

      final dynamic res = await ServerConnections().postDsToServer(
        strictAuth: false,
        url: Const.getFullARMUrl(ServerConnections.API_VALIDATE_SESSION),
        body: jsonEncode(payload),
        isBearer: true,
        show_errorSnackbar: false,
      );
      await Future.delayed(Duration(seconds: 2));
      bool isSuccess = false;
      if (res != null && res.isNotEmpty) {
        final decoded = jsonDecode(res);
        if (decoded is Map && decoded['result']['success'] == true) {
          isSuccess = true;
        }
      }
      return isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<void> actionRefreshQueues() async {
    const tag = "[OFFLINE_ACTION_REFRESH_PENDING]";
    if (!await _isInternetAvailable()) {
      _showNeedInternetDialog();
      return;
    }

    var rows = await OfflineDbModule.getPendigQueuesToRefresh();

    if (rows.length == 0) {
      await _confirm(
        title: "No Pending Queues",
        message:
            "There is no pending Queues available.\n\nYou can try uploading new Queues to use this feature",
        okText: "Okay",
        icon: Icons.indeterminate_check_box_outlined,
        confirmColor: const Color.fromARGB(255, 235, 103, 37),
      );
      return;
    }
    final ok = await _confirm(
      title: "Refresh Pending Queues",
      message:
          "This will refresh ${rows.length} pendind queues from the server.\n\nAre you sure you want to continue?",
      okText: "Refresh Now",
      icon: Icons.cloud_upload_rounded,
      confirmColor: const Color(0xFF2563EB),
    );

    if (!ok) return;

    try {
      final sessionResult = await Get.dialog<CachedSessionValidationResult>(
        PopScope(canPop: false, child: const CachedSessionValidationDialog()),
        barrierDismissible: false,
      );

      if (sessionResult != CachedSessionValidationResult.valid) {
        final login = await _confirm(
          title: "Invalid Session",
          message:
              "Your session has expired. Log back in to sync your pending data and access your forms.",
          okText: "Okay",
          icon: Icons.indeterminate_check_box_outlined,
          confirmColor: const Color.fromARGB(255, 235, 103, 37),
        );

        cachedSaveUpdateMessage.value = "Invalid Session";

        if (login) {
          Get.offAll(LoginPage());
        }

        return;
      }

      final refreshResult = await Get.dialog<CachedRefreshResult>(
        CachedRefreshDialogWidget(
          refreshQueueRows: rows,
        ),
        barrierDismissible: false,
      );

      if (refreshResult != CachedRefreshResult.refreshed) {
        return;
      }
    } catch (e) {
    } finally {
      refreshPendingCount();
    }
  }

  Future<void> actionPushPendingByCachedSave() async {
    const tag = "[OFFLINE_ACTION_PUSH_PENDING_BY_CACHED_SAVE]";

    if (!await _isInternetAvailable()) {
      _showNeedInternetDialog();
      return;
    }

    final pendingCount = await OfflineDbModule.getPendingCount();

    if (pendingCount == 0) {
      await _confirm(
        title: "No Pending Data",
        message:
            "There is no pending data available.\n\nYou can try saving new forms offline to use this feature",
        okText: "Okay",
        icon: Icons.indeterminate_check_box_outlined,
        confirmColor: const Color.fromARGB(255, 235, 103, 37),
      );
      return;
    }

    final ok = await _confirm(
      title: "Upload Pending Data",
      message:
          "This will upload $pendingCount locally saved records to the server.\n\nAre you sure you want to continue?",
      okText: "Upload Now",
      icon: Icons.cloud_upload_rounded,
      confirmColor: const Color(0xFF2563EB),
    );

    if (!ok) return;

    cachedSaveUpdateMessage.value = "Starting Process";
    isCachedSaveActive.value = true;

    try {
      /// ----------------------------------------------------------
      /// STEP 1 : Validate Session
      /// ----------------------------------------------------------
      final sessionResult = await Get.dialog<CachedSessionValidationResult>(
        PopScope(canPop: false, child: const CachedSessionValidationDialog()),
        barrierDismissible: false,
      );

      if (sessionResult != CachedSessionValidationResult.valid) {
        final login = await _confirm(
          title: "Invalid Session",
          message:
              "Your session has expired. Log back in to sync your pending data and access your forms.",
          okText: "Okay",
          icon: Icons.indeterminate_check_box_outlined,
          confirmColor: const Color.fromARGB(255, 235, 103, 37),
        );

        cachedSaveUpdateMessage.value = "Invalid Session";

        if (login) {
          Get.offAll(LoginPage());
        }

        return;
      }

      /// ----------------------------------------------------------
      /// STEP 2 : Check Pending Queue Refresh Count
      /// ----------------------------------------------------------
      final refreshQueueRows = await OfflineDbModule.getPendigQueuesToRefresh();

      /// ----------------------------------------------------------
      /// STEP 3 : Refresh Queue (only if required)
      /// ----------------------------------------------------------
      if (refreshQueueRows.length > 0) {
        final refreshResult = await Get.dialog<CachedRefreshResult>(
          CachedRefreshDialogWidget(
            refreshQueueRows: refreshQueueRows,
          ),
          barrierDismissible: false,
        );

        if (refreshResult != CachedRefreshResult.refreshed) {
          return;
        }

        var newPendingCount = await OfflineDbModule.getPendingCount();
        if (newPendingCount == 0) {
          await Get.dialog(AllRecordsDoneDialog());
          return;
        }
      }

      /// ----------------------------------------------------------
      /// STEP 4 : Upload Pending Data
      /// ----------------------------------------------------------
      cachedSaveUpdateMessage.value = "Uploading Pending Data";

      Get.dialog(
        CachedSaveDialogWidget(),
        barrierDismissible: false,
      );

      await OfflineDbModule.startCachedSave(
        controller: Get.find<OfflineFormController>(),
      );
    } catch (e, st) {
      LogService.writeLog(
        message: "$tag [FAILED]\n$e\n$st",
      );

      Get.snackbar(
        "Upload Error",
        "Failed to process queue. Check logs.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        icon: const Icon(
          Icons.warning,
          color: Colors.white,
        ),
      );
    } finally {
      isCachedSaveActive.value = false;
      isLoading.value = false;
      refreshPendingCount();
    }
  }

//////////////////////////////////////////////////////////////////////////////
  //////// Cached save progress update items/////////////////////////////////
////////////////////////////////////////////////////////////////////////////
  var isSessionCheckingForCachedSave = false.obs;
  var isPendingQuesRefreshing = false.obs;
  var pendingQueResolveResults = <QueueResolveResultModel>[].obs;
  var isPendingQueResolveComplete = false.obs;
  var isCachedSaveActive = false.obs;
  final cachedSaveQueItems = <Rx<CachedSaveItemModel>>[].obs;
  var cachedSaveUpdateMessage = ''.obs;
  final RxSet<String> sentQueueIds = <String>{}.obs;
  final RxSet<String> receivedQueueIds = <String>{}.obs;
  var totalExpectedRecords = 0.obs;
  var totalExpectedBatches = 0.obs;
  void registerSentQueueId(String queueId) {
    sentQueueIds.add(queueId);
    LogService.writeLog(
      message: "[QUEUE_TRACKING] SENT queue_id=$queueId | "
          "sent_total=${sentQueueIds.length} received_total=${receivedQueueIds.length}",
    );
  }

  void registerReceivedQueueId(String queueId) {
    receivedQueueIds.add(queueId);
    LogService.writeLog(
      message: "[QUEUE_TRACKING] RECEIVED queue_id=$queueId | "
          "sent_total=${sentQueueIds.length} received_total=${receivedQueueIds.length}",
    );
    _checkIfAllQueuesResolved();
  }

  void _checkIfAllQueuesResolved() {
    if (sentQueueIds.isEmpty) return;

    final bool allResolved = sentQueueIds.every(receivedQueueIds.contains);

    if (allResolved) {
      cachedSaveUpdateMessage.value =
          "Server confirmation received for all ${sentQueueIds.length} batch${sentQueueIds.length == 0 ? '' : "es"}.\nSync is complete.";
    }
  }

  void resetQueueTracking() {
    sentQueueIds.clear();
    receivedQueueIds.clear();
    totalExpectedRecords.value = 0;
    totalExpectedBatches.value = 0;
    LogService.writeLog(message: "[QUEUE_TRACKING] RESET for new run");
  }

  static const Map<QueueSubmissionStatus, int> _statusPriority = {
    QueueSubmissionStatus.refetch: 0,
    QueueSubmissionStatus.error: 1,
    QueueSubmissionStatus.partial: 2,
    QueueSubmissionStatus.success: 3,
    QueueSubmissionStatus.pending: 4,
    QueueSubmissionStatus.sending: 5,
    QueueSubmissionStatus.created: 6,
  };
  void _sortQueueItems() {
    cachedSaveQueItems.sort((a, b) {
      final priorityA = _statusPriority[a.value.submissionStatus]!;
      final priorityB = _statusPriority[b.value.submissionStatus]!;

      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }

      return 0;
    });
  }

  void addQueue(CachedSaveItemModel item) {
    registerSentQueueId(item.qId);
    cachedSaveQueItems.add(item.obs);
  }

  void updateQueueItem(
    String qId,
    CachedSaveItemModel Function(CachedSaveItemModel) updater,
  ) {
    final index = cachedSaveQueItems.indexWhere(
      (e) => e.value.qId == qId,
    );

    if (index == -1) return;

    cachedSaveQueItems[index].value = updater(cachedSaveQueItems[index].value);
    _sortQueueItems();
  }
}
