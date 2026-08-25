import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/form_field_model.dart';

class OfflineFormPageModel {
  final String transId;
  final String caption;
  final bool visible;
  final bool attachments;
  final String pageType;
  final List<OfflineFormFieldModel> fields;
  Map<String, dynamic> schema;

  OfflineFormPageModel({
    required this.transId,
    required this.caption,
    required this.visible,
    required this.attachments,
    required this.fields,
    required this.schema,
    required this.pageType,
  });

  factory OfflineFormPageModel.fromJson(Map<String, dynamic> json) {
    List<OfflineFormFieldModel> parsedFields = [];
    if (json['fields'] != null && json['fields'] is List) {
      parsedFields = (json['fields'] as List<dynamic>)
          .map((e) => OfflineFormFieldModel.fromJson(e))
          .toList()
        ..sort(
          (a, b) => a.order.compareTo(b.order),
        );
    }

    return OfflineFormPageModel(
      transId: json['transid'] ?? '',
      caption: json['caption'] ?? '',
      visible: json['visible'] ?? true,
      attachments: json['attachments'] ?? false,
      pageType: json['page_type'] ?? 'form',
      fields: parsedFields,
      schema: json,
    );
  }
}
