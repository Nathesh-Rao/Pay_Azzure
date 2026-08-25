import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/controller/offline_form_controller.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/form_field_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/widgets/offline_attachments_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../widgets/offline_form_field_widgets.dart';

class OfflineFormPage extends GetView<OfflineFormController> {
  const OfflineFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<OfflineFormFieldModel> fields =
        List.from(controller.page.fields);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(controller.page.caption),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                controller.validateForm();
              },
              icon: Icon(Icons.check_circle))
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      //     child: Column(
      //       spacing: 15,
      //       // children: controller.fieldMap.values
      //       //     .map((f) => OfflineFormField(field: f))
      //       //     .toList(),
      //       children: [
      //         if (controller.page.attachments)
      //           const OfflineAttachmentsSection(),
      //         ...controller.fieldMap.values
      //             .map((f) => OfflineFormField(field: f))
      //             .toList(),
      //       ],
      //     ),
      //   ),
      // ),

      body: ListView(
        children: fields
            .map((field) => _buildFieldFromSchema(context, field))
            .toList(),
      ),
      floatingActionButton: controller.page.attachments
          ? FloatingActionButton(
              backgroundColor: MyColors.blue9,
              child: Icon(CupertinoIcons.paperclip),
              onPressed: controller.pickAttachment)
          : null,
    );
  }

  Widget _buildFieldFromSchema(BuildContext context, OfflineFormFieldModel f) {
    // final String rawType = f["fld_type"];
    // final String name = f["fld_name"];
    // final String label = f["fld_caption"];
    // final bool mandatory = (f["allowempty"] == "F");
    // final bool hidden = (f["hidden"] == "T");
    // final bool readonly = (f["readonly"] == "T");
    // final String datetime_format = f["datetime_format"] = "";
    // final bool isUpper = rawType.endsWith("_upper");
    // final String type = isUpper ? rawType.replaceAll("_upper", "") : rawType;

    final String rawType = f.fldType;
    final String name = f.fldName;
    final String label = f.fldCaption;
    final bool mandatory = !f.allowEmpty;
    final bool hidden = f.hidden;
    final bool readonly = f.readOnly;
    final String datetime_format = f.datetime_format;
    final String dataSource = f.datasource ?? '';
    final bool isUpper = rawType.endsWith("_upper");
    final String type = isUpper ? rawType.replaceAll("_upper", "") : rawType;

    if (hidden) {
      return SizedBox.shrink();
    }
    switch (type) {
      case "c":
        return _text(
          label,
          readOnly: readonly,
          controller.getTextCtrl(name),
          name,
          mandatory: mandatory,
          // focusNode: name == 'ub_ge_no' ? controller.ubgeNoFocusNode : null,
        );
      case "n":
        return _number(
          label,
          controller.getTextCtrl(name),
          name,
          readOnly: readonly,
          mandatory: mandatory,
        );
      case "dd":
        final String dsKey = dataSource;
        return _dropdown(
          label,
          controller.getDropdownCtrl(name),
          name,
          dsKey,
          mandatory: mandatory,
        );

      case "date":
        return _date(
          context,
          label,
          controller.getTextCtrl(name),
          name,
          mandatory: mandatory,
          datetime_formate: datetime_format,
        );
      case "year":
        return _yearPicker(
          context,
          label,
          controller.getTextCtrl(name),
          name,
          mandatory: mandatory,
          readOnly: readonly,
          datetime_formate: datetime_format,
        );

      case "time":
        return _timePicker(
          context,
          label,
          controller.getTextCtrl(name),
          name,
          mandatory: mandatory,
          readOnly: readonly,
          datetime_formate: datetime_format,
        );
      case "datetime":
        return _dateTime(
          context,
          label,
          controller.getTextCtrl(name),
          name,
          mandatory: mandatory,
          readOnly: readonly,
          datetime_formate: datetime_format,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _text(
    String label,
    TextEditingController ctrl,
    String key, {
    bool mandatory = false,
    FocusNode? focusNode,
    bool readOnly = false,
  }) {
    return _RowWithField(
      label: label,
      mandatory: mandatory,
      errorKey: key,
      child: Obx(() {
        final hasError = controller.errors.containsKey(key);
        return TextFormField(
          readOnly: readOnly,
          controller: ctrl,
          focusNode: focusNode,
          decoration: _inputDecoration(label, hasError),
        );
      }),
    );
  }

  Widget _number(
    String label,
    TextEditingController ctrl,
    String key, {
    bool mandatory = false,
    bool readOnly = false,
  }) {
    return _RowWithField(
      label: label,
      mandatory: mandatory,
      errorKey: key,
      child: Obx(() {
        final hasError = controller.errors.containsKey(key);
        return TextFormField(
          readOnly: readOnly,
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration(label, hasError),
          onChanged: (v) {
            // if (key == "bags_sample") {
            //   controller.onBagsToSampleChanged(v);
            // }
          },
        );
      }),
    );
  }

  Widget _dropdown(
    String label,
    RxString value,
    String key,
    String datasourceKey, {
    bool mandatory = false,
  }) {
    return _RowWithField(
      label: label,
      mandatory: mandatory,
      errorKey: key,
      child: Obx(() {
        final hasError = controller.errors.containsKey(key);

        final bool isEnabled = controller.isFieldEnabled(key);

        final List<String> options =
            isEnabled ? controller.getDropdownOptions(key) : [];
        options.sort((a, b) {
          final numA = num.tryParse(a);
          final numB = num.tryParse(b);

          if (numA != null && numB != null) {
            return numB.compareTo(numA);
          } else {
            return a.toLowerCase().compareTo(b.toLowerCase());
          }
        });

        String currentRxValue = value.value;
        String? finalUiValue = currentRxValue;
        if (options.length == 1) {
          finalUiValue = options.first;
        }

        if (finalUiValue.isNotEmpty) {
          if (!options.contains(finalUiValue)) {
            finalUiValue = null;
          }
        }
        if (!isEnabled || finalUiValue == "") {
          finalUiValue = null;
        }
        final String targetRxState = finalUiValue ?? "";
        if (currentRxValue != targetRxState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            value.value = targetRxState;

            if (targetRxState.isNotEmpty) controller.errors.remove(key);
          });
        }
        // String? selectedValue;
        // if (options.length == 1) {
        //   selectedValue = options.first;
        // } else {
        //   selectedValue = value.value;
        // }

        // if (selectedValue.isEmpty || !isEnabled) {
        //   selectedValue = null;
        // } else if (!options.contains(selectedValue)) {
        //   selectedValue = null;
        // }

        return DropdownButtonFormField<String>(
          initialValue: finalUiValue,
          isExpanded: true,
          hint: Text(
            isEnabled
                ? "Select $label"
                : "Select ${dependencyLabel(key)} first",
            style: TextStyle(
                color: isEnabled ? Colors.grey : Colors.grey.shade400),
          ),
          icon: Icon(Icons.expand_more,
              size: 18, color: isEnabled ? Colors.grey : Colors.grey.shade300),
          items: options.map((String opt) {
            return DropdownMenuItem<String>(
              value: opt,
              child: Text(
                opt,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: isEnabled ? (v) => value.value = v.toString() : null,
          decoration: _inputDecoration(label, hasError),
        );
      }),
    );
  }

  String dependencyLabel(String key) {
    final field = (controller.schema['fields'] as List)
        .firstWhere((e) => e['fld_name'] == key, orElse: () => null);
    if (field != null &&
        field['dep_field'] != null &&
        (field['dep_field'] as List).isNotEmpty) {
      String parentKey = field['dep_field'][0];
      return parentKey.replaceAll("_", " ").capitalize ?? "Parent";
    }
    return "Parent";
  }

  Widget _date(
    BuildContext context,
    String label,
    TextEditingController ctrl,
    String key, {
    bool mandatory = false,
    String datetime_formate = "",
    bool readOnly = false,
  }) {
    return _RowWithField(
      label: label,
      mandatory: mandatory,
      errorKey: key,
      trailing: const Icon(Icons.calendar_month, size: 18, color: Colors.grey),
      child: Obx(() {
        final hasError = controller.errors.containsKey(key);
        return TextFormField(
          controller: ctrl,
          readOnly: readOnly,
          decoration: _inputDecoration(label, hasError),
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: DateTime.now(),
            );
            /*if (d != null) {
              ctrl.text = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
            }*/

            if (d != null) {
              final String format = (datetime_formate.isNotEmpty)
                  ? datetime_formate
                  : 'dd/MM/yyyy'; // default
              ctrl.text = DateFormat(format).format(d);
            }
          },
        );
      }),
    );
  }

  Widget _yearPicker(
    BuildContext context,
    String label,
    TextEditingController ctrl,
    String key, {
    bool mandatory = false,
    String datetime_formate = "",
    bool readOnly = false,
  }) {
    return _RowWithField(
      label: label,
      mandatory: mandatory,
      errorKey: key,
      trailing: const Icon(Icons.calendar_month, size: 18, color: Colors.grey),
      child: Obx(() {
        final hasError = controller.errors.containsKey(key);
        return TextFormField(
          controller: ctrl,
          readOnly: readOnly,
          decoration: _inputDecoration(label, hasError),
          onTap: () async {
            final now = DateTime.now();
            final d = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(now.year + 1),
              initialDate: now,
              initialDatePickerMode: DatePickerMode.year,
            );
            if (d != null) {
              ctrl.text = d.year.toString();
            }
          },
        );
      }),
    );
  }

  Widget _timePicker(
    BuildContext context,
    String label,
    TextEditingController ctrl,
    String key, {
    bool mandatory = false,
    String datetime_formate = "",
    bool readOnly = false,
  }) {
    return _RowWithField(
      label: label,
      mandatory: mandatory,
      errorKey: key,
      trailing: const Icon(Icons.access_time, size: 18, color: Colors.grey),
      child: Obx(() {
        final hasError = controller.errors.containsKey(key);

        return TextFormField(
          controller: ctrl,
          readOnly: readOnly,
          decoration: _inputDecoration(label, hasError),
          onTap: () async {
            final now = TimeOfDay.now();

            final t = await showTimePicker(
              context: context,
              initialTime: now,
            );

            /*if (t != null) {
              final hh = t.hour.toString().padLeft(2, '0');
              final mm = t.minute.toString().padLeft(2, '0');
              ctrl.text = "$hh:$mm";
            }*/

            if (t != null) {
              // Convert TimeOfDay → DateTime
              final DateTime dateTime = DateTime(
                0,
                1,
                1,
                t.hour,
                t.minute,
              );

              // Use provided format or default
              final String format =
                  (datetime_formate.isNotEmpty) ? datetime_formate : 'hh:mm a';

              ctrl.text = DateFormat(format).format(dateTime);
            }
          },
        );
      }),
    );
  }

  Widget _dateTime(
    BuildContext context,
    String label,
    TextEditingController ctrl,
    String key, {
    bool mandatory = false,
    bool readOnly = false,
    String datetime_formate = "",
  }) {
    // Set default value once
    String default_dtFormat = 'dd/MM/yyyy h:mm:ss a';
    if (ctrl.text.isEmpty) {
      ctrl.text = DateFormat(
              datetime_formate.isNotEmpty ? datetime_formate : default_dtFormat)
          .format(DateTime.now());
    }
    return _RowWithField(
      label: label,
      mandatory: mandatory,
      errorKey: key,
      trailing: const Icon(Icons.calendar_month, size: 18, color: Colors.grey),
      child: Obx(() {
        final hasError = controller.errors.containsKey(key);

        return TextFormField(
          controller: ctrl,
          readOnly: readOnly,
          decoration: _inputDecoration(label, hasError),
          onTap: readOnly
              ? null // No picker when read-only
              : () async {
                  // Pick date
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate == null) return;

                  //  Pick time
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime == null) return;

                  //  Combine date & time
                  final DateTime dateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  //  Format: 22/01/2026 6:44:24 PM
                  final formatted = DateFormat(datetime_formate.isNotEmpty
                          ? datetime_formate
                          : default_dtFormat)
                      .format(dateTime);

                  ctrl.text = formatted;
                },
        );
      }),
    );
  }

  static InputDecoration _inputDecoration(String label, bool hasError) {
    return InputDecoration(
      hintText: "Enter $label",
      hintStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.grey.shade500,
      ),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: hasError ? Colors.red : Colors.transparent,
          width: 1.2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: hasError ? Colors.red : Colors.transparent,
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: hasError ? Colors.red : const Color(0xFF2563EB),
          width: 1.2,
        ),
      ),
    );
  }
}

class _RowWithField extends GetView<OfflineFormController> {
  final String label;
  final bool mandatory;
  final Widget child;
  final Widget? trailing;
  final String errorKey;
  const _RowWithField({
    required this.label,
    required this.child,
    required this.errorKey,
    this.mandatory = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // <--- Constrain width
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEF1F6)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (mandatory)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 8),
          child,
          Obx(() {
            final err = controller.errors[errorKey];
            if (err == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                err,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.red,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
