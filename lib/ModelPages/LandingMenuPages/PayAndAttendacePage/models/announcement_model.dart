class AnnouncementModel {
  final String employee;
  final String designation;
  final String eventDate; // stored as string "30-10-2025"
  final String eventType;
  final String message;
  final String location;

  AnnouncementModel({
    required this.employee,
    required this.designation,
    required this.eventDate,
    required this.eventType,
    required this.message,
    required this.location,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      employee: json['employee'] ?? '',
      designation: json['designation'] ?? '',
      eventDate: json['event_date'] ?? '',
      eventType: json['event_type'] ?? '',
      message: json['message'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee': employee,
      'designation': designation,
      'event_date': eventDate,
      'event_type': eventType,
      'message': message,
      'location': location,
    };
  }

  DateTime get dateTime {
    final parts = eventDate.split('-');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]) ?? 1;
      final month = int.tryParse(parts[1]) ?? 1;
      final year = int.tryParse(parts[2]) ?? 1970;
      return DateTime(year, month, day);
    }
    return DateTime.now();
  }

  @override
  String toString() =>
      'EmployeeEventModel(employee: $employee, eventType: $eventType, eventDate: $eventDate)';
}

// class AnnouncementModel {
//   final String caption;
//   final String op;
//   final String opDesignation;
//   final String date;
//   final String place;
//   final String image;
//   final String description;

//   AnnouncementModel({
//     required this.caption,
//     required this.op,
//     required this.opDesignation,
//     required this.date,
//     required this.place,
//     required this.image,
//     required this.description,
//   });

//   factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
//     return AnnouncementModel(
//       caption: json['caption'] ?? '',
//       op: json['op'] ?? '',
//       opDesignation: json['op_designation'] ?? '',
//       date: json['date'] ?? '',
//       place: json['place'] ?? '',
//       image: json['image'] ?? '',
//       description: json['description'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'caption': caption,
//       'op': op,
//       'op_designation': opDesignation,
//       'date': date,
//       'place': place,
//       'image': image,
//       'description': description,
//     };
//   }

//   static List<AnnouncementModel> tempData() {
//     return [];
//   }
// }
