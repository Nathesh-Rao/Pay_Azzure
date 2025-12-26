class OffDaysModel {
  final String date;
  final String event;

  OffDaysModel({
    required this.date,
    required this.event,
  });

  factory OffDaysModel.fromJson(Map<String, dynamic> json) {
    return OffDaysModel(
      date: json['date'] ?? '',
      event: json['event'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'event': event,
    };
  }

  DateTime toDateTime() {
    final parts = date.split('-');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }
}
