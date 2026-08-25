import 'dart:convert';
import 'dart:io';

import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/offline_form_controller.dart';
import '../models/form_field_model.dart';

class OfflineFormField extends GetView<OfflineFormController> {
  final OfflineFormFieldModel field;

  const OfflineFormField({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    if (field.hidden) return const SizedBox.shrink();

    return GetBuilder<OfflineFormController>(
      id: field.fldName,
      builder: (_) {
        switch (field.fldType) {
          case 'c':
          case 'n':
            return _textField();

          case 'm':
            return _memoField();

          case 'd':
            return _dateField(context);

          case 'cb':
            return _checkBox();

          case 'cl':
            return _checkList();

          case 'rb':
          case 'rl':
            return _radioList();

          case 'dd':
            return _dropdown(context);

          case 'image':
            return _imageField(context);

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  // ---------------- COMMON ----------------

  Widget _label() {
    return Row(
      children: [
        Text(
          field.fldCaption,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (!field.allowEmpty)
          const Text(" *", style: TextStyle(color: Colors.red)),
      ],
    );
  }

  InputDecoration _decoration({Widget? suffix}) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      errorText: field.errorText,
      errorStyle: GoogleFonts.poppins(fontSize: 9),
      suffixIcon: suffix,
      // suffixIconConstraints: BoxConstraints.expand(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // ---------------- TEXT ----------------

  Widget _textField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: field.value,
          readOnly: field.readOnly,
          keyboardType:
              field.fldType == 'n' ? TextInputType.number : TextInputType.text,
          inputFormatters: field.fldType == 'n'
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          decoration: _decoration(),
          style: GoogleFonts.poppins(fontSize: 13),
          onChanged: (v) => controller.updateFieldValue(field, v),
        ),
      ],
    );
  }

  // ---------------- MEMO ----------------

  Widget _memoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: field.value,
          readOnly: field.readOnly,
          maxLines: 3,
          decoration: _decoration(),
          style: GoogleFonts.poppins(fontSize: 13),
          onChanged: (v) => controller.updateFieldValue(field, v),
        ),
      ],
    );
  }

  // ---------------- DATE ----------------
  Widget _dateField(BuildContext context) {
    final controllerText = TextEditingController(text: field.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(),
        const SizedBox(height: 4),
        TextFormField(
          controller: controllerText,
          readOnly: true,
          decoration: _decoration(
            suffix: const Icon(Icons.calendar_month, size: 18),
          ),
          style: GoogleFonts.poppins(fontSize: 13),
          onTap: field.readOnly
              ? null
              : () async {
                  final d = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDate:
                        DateTime.tryParse(field.value) ?? DateTime.now(),
                  );
                  if (d != null) {
                    controller.updateFieldValue(
                      field,
                      d.toIso8601String().split('T').first,
                    );
                  }
                },
        ),
      ],
    );
  }

  // ---------------- CHECKBOX ----------------

  Widget _checkBox() {
    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      value: field.value.toLowerCase() == 'true',
      title: Text(
        field.fldCaption,
        style: GoogleFonts.poppins(fontSize: 13),
      ),
      onChanged:
          field.readOnly ? null : (v) => controller.updateFieldValue(field, v),
    );
  }

  // ---------------- CHECKLIST ----------------
  Widget _checkList() {
    final List<dynamic> selected =
        field.value == null || field.value.toString().isEmpty
            ? []
            : (field.value is List
                ? field.value
                : field.value.toString().split(','));

    if (field.options.isEmpty) {
      return _emptyHint();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          children: field.options.map((o) {
            final key = o[field.fldName];
            final isSel = selected.contains(key);

            return FilterChip(
              label: Text(o[field.fldName],
                  style: GoogleFonts.poppins(fontSize: 12)),
              selected: isSel,
              onSelected: field.readOnly
                  ? null
                  : (_) {
                      final next = [...selected];
                      isSel ? next.remove(key) : next.add(key);
                      controller.updateFieldValue(field, next);
                    },
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------------- RADIO ----------------

  // Widget _radioList() {
  //   if (field.options.isEmpty) {
  //     return _emptyHint();
  //   }

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _label(),
  //       const SizedBox(height: 4),
  //       RadioGroup<String>(
  //         groupValue: field.value.isEmpty ? null : field.value,
  //         onChanged: (val) {
  //           if (field.readOnly) return;
  //           if (val != null) {
  //             controller.updateFieldValue(field, val);
  //           }
  //         },
  //         child: Column(
  //           children: field.options.map((o) {
  //             return RadioListTile<String>(
  //               dense: true,
  //               contentPadding: EdgeInsets.zero,
  //               value: o,
  //               title: Text(o, style: GoogleFonts.poppins(fontSize: 12)),
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _radioList() {
    if (field.options.isEmpty) {
      return _emptyHint();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(),
        const SizedBox(height: 4),
        Column(
          children: field.options.map((o) {
            final isSelected = field.value == o[field.fldName];

            return RadioListTile<dynamic>(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: o[field.fldName],
              groupValue: field.value,
              title: Text(o[field.fldName],
                  style: GoogleFonts.poppins(fontSize: 12)),
              onChanged: field.readOnly
                  ? null
                  : (val) {
                      if (val != null) {
                        controller.updateFieldValue(field, val);
                      }
                    },
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------------- DROPDOWN ----------------
  // Widget _dropdown(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _label(),
  //       const SizedBox(height: 4),
  //       InkWell(
  //         onTap: field.readOnly ? null : () => _openDropdownSheet(context),
  //         child: IgnorePointer(
  //           child: TextFormField(
  //             initialValue: field.value.isEmpty ? 'Select' : field.value,
  //             decoration: _decoration(
  //               suffix: const Icon(Icons.arrow_drop_down),
  //             ),
  //             style: GoogleFonts.poppins(fontSize: 13),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _dropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(),
        const SizedBox(height: 4),
        InkWell(
          onTap: field.readOnly ? null : () => _openDropdownSheet(context),
          child: IgnorePointer(
            child: TextFormField(
              initialValue: _getDisplayText(),
              decoration: _decoration(
                suffix: const Icon(Icons.arrow_drop_down),
              ),
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- EMPTY OPTIONS ----------------

  Widget _emptyHint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(),
        const SizedBox(height: 4),
        Text(
          'No options available',
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  // void _openDropdownSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (_) {
  //       if (field.options.isEmpty) {
  //         return Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Center(
  //             child: Text(
  //               'No options available',
  //               style: GoogleFonts.poppins(
  //                 fontSize: 13,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //           ),
  //         );
  //       }

  //       return ListView(
  //         children: field.options
  //             .map(
  //               (o) => ListTile(
  //                 title: Text(o),
  //                 onTap: () {
  //                   Get.back();
  //                   controller.updateFieldValue(field, o);
  //                 },
  //               ),
  //             )
  //             .toList(),
  //       );
  //     },
  //   );
  // }
  void _openDropdownSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        if (field.options.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'No options available',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }

        return ListView(
          children: field.options.map((o) {
            return ListTile(
              title: Text(o[field.fldName] ?? ""),
              onTap: () {
                Get.back();

                // if (_isDataSourceField) {
                //   // 👇 store ID
                //   controller.updateFieldValue(field, o.id);
                // } else {
                //   // 👇 static dropdown, store value
                //   controller.updateFieldValue(field, o.value);
                // }

                controller.updateFieldValue(field, o[field.fldName]);
              },
            );
          }).toList(),
        );
      },
    );
  }

  // ---------------- IMAGE ----------------
  Widget _imageField(BuildContext context) {
    final hasImage = field.value.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(),
        const SizedBox(height: 4),
        InkWell(
          onTap: field.readOnly ? null : () => _openImageSheet(context),
          child: Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: hasImage
                    ? MyColors.AXMDark
                    : field.errorText != null
                        ? Colors.red
                        : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey.shade100,
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.memory(
                      base64Decode(field.value),
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image, size: 32, color: Colors.grey),
                      const SizedBox(height: 6),
                      Text(
                        'Tap to upload image',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (hasImage && !field.readOnly)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () => _openImageSheet(context),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Replace'),
                ),
                TextButton.icon(
                  onPressed: () => controller.removeImage(field),
                  icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                  label: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        if (field.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              field.errorText!,
              style: GoogleFonts.poppins(fontSize: 9, color: Colors.red),
            ),
          ),
      ],
    );
  }

  void _openImageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (field.isCamera)
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: MyColors.AXMDark,
                  ),
                  title: Text(
                    'Camera',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    controller.pickImage(
                      field: field,
                      source: ImageSource.camera,
                    );
                  },
                ),
              if (field.isGallery)
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: MyColors.blue1,
                  ),
                  title: Text(
                    'Gallery',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    controller.pickImage(
                      field: field,
                      source: ImageSource.gallery,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  bool get _isDataSourceField =>
      field.datasource != null && field.datasource!.isNotEmpty;

  String _getDisplayText() {
    if (!_isDataSourceField) {
      return field.value?.toString() ?? '';
    }

    if (field.value == null || field.value.toString().isEmpty) {
      return 'Select';
    }

    final match = field.options.firstWhereOrNull(
      (e) => e[field.fldName] == field.value,
    );

    return match?[field.fldName] ?? 'Select';
  }
}

// class InwardEntryStaticFields {
//   static List<OfflineFormFieldModel> fields = [
//     OfflineFormFieldModel(
//       order: 1,
//       fldName: 'unit',
//       fldCaption: 'Unit',
//       fldType: 'c',
//       dataType: 's',
//       hidden: false,
//       readOnly: true,
//       allowEmpty: false,
//       defValue: 'AUTO',
//       value: '',
//     ),
//     OfflineFormFieldModel(
//       order: 2,
//       fldName: 'ub_ge_no',
//       fldCaption: 'UB G.E. No',
//       fldType: 'c',
//       dataType: 's',
//       hidden: false,
//       readOnly: false,
//       allowEmpty: false,
//       defValue: '',
//       value: '',
//     ),
//     OfflineFormFieldModel(
//       order: 3,
//       fldName: 'receipt_date',
//       fldCaption: 'Receipt Date',
//       fldType: 'd',
//       dataType: 'd',
//       hidden: false,
//       readOnly: false,
//       allowEmpty: false,
//       defValue: '',
//       value: '',
//     ),
//     OfflineFormFieldModel(
//       order: 4,
//       fldName: 'vehicle_no',
//       fldCaption: 'Vehicle No',
//       fldType: 'c',
//       dataType: 's',
//       hidden: false,
//       readOnly: false,
//       allowEmpty: false,
//       defValue: '',
//       value: '',
//     ),
//     OfflineFormFieldModel(
//       order: 5,
//       fldName: 'bottle_type',
//       fldCaption: 'Bottle Type',
//       fldType: 'dd',
//       dataType: 's',
//       hidden: false,
//       readOnly: false,
//       allowEmpty: false,
//       options: [],
//       defValue: '',
//       value: '',
//     ),
//     OfflineFormFieldModel(
//       order: 6,
//       fldName: 'bottle_capacity',
//       fldCaption: 'Bottle Capacity',
//       fldType: 'dd',
//       dataType: 's',
//       hidden: false,
//       readOnly: false,
//       allowEmpty: false,
//       options: [],
//       defValue: '',
//       value: '',
//     ),
//     OfflineFormFieldModel(
//       order: 7,
//       fldName: 'loaded_weight',
//       fldCaption: 'Loaded Truck Weight',
//       fldType: 'n',
//       dataType: 'n',
//       hidden: false,
//       readOnly: false,
//       allowEmpty: false,
//       defValue: '',
//       value: '',
//     ),
//     OfflineFormFieldModel(
//       order: 8,
//       fldName: 'empty_weight',
//       fldCaption: 'Empty Truck Weight',
//       fldType: 'n',
//       dataType: 'n',
//       hidden: false,
//       readOnly: false,
//       allowEmpty: false,
//       defValue: '',
//       value: '',
//     ),
//     OfflineFormFieldModel(
//       order: 9,
//       fldName: 'bottle_image',
//       fldCaption: 'Bottle Image',
//       fldType: 'image',
//       dataType: 'b',
//       hidden: false,
//       readOnly: false,
//       allowEmpty: false,
//       isCamera: true,
//       isGallery: true,
//       defValue: '',
//       value: '',
//     ),
//   ];
// }
