import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/data_source_model.dart';

class OfflineFormFieldModel {
  final int order;
  final String fldName;
  final String fldCaption;
  final String fldType;
  final String dataType;

  final String datetime_format;

  final bool hidden;
  final bool readOnly;
  final bool allowEmpty;

  final String defValue;
  final String? datasource;

  // image specific
  final bool isCamera;
  final bool isGallery;

  /// runtime
  dynamic value;
  String? errorText;

  List<Map<String, dynamic>> options;
  List<String> dependencies;

  OfflineFormFieldModel({
    required this.order,
    required this.fldName,
    required this.fldCaption,
    required this.fldType,
    required this.dataType,
    required this.hidden,
    required this.readOnly,
    required this.allowEmpty,
    required this.defValue,
    required this.value,
    this.datetime_format = "",
    this.datasource,
    this.isCamera = false,
    this.isGallery = false,
    this.options = const [],
    this.dependencies = const [],
    this.errorText,
  });

  factory OfflineFormFieldModel.fromJson(Map<String, dynamic> json) {
    final def = json['def_value']?.toString() ?? '';

    return OfflineFormFieldModel(
      order: int.tryParse(json['order']?.toString() ?? '0') ?? 0,
      fldName: json['fld_name'],
      fldCaption: json['fld_caption'],
      fldType: json['fld_type'],
      dataType: json['data_type'],
      datetime_format: (json['datetime_format'] ?? ""),
      hidden: (json['hidden'] ?? 'F') == 'T',
      readOnly: (json['readonly'] ?? 'F') == 'T',
      allowEmpty: (json['allowempty'] ?? 'F') == 'T',
      defValue: def,
      value: def,
      datasource: json['datasource'],
      isCamera: (json['is_camera'] ?? 'F') == 'T',
      isGallery: (json['is_gallery'] ?? 'F') == 'T',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
      dependencies: (json["dep_field"] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
