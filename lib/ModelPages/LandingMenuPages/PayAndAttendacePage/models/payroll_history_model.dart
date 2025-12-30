class PayrollHistoryModel {
  final String name;
  final String date;
  final int totalAmount;
  final String downloadUrl;

  PayrollHistoryModel({
    required this.name,
    required this.date,
    required this.totalAmount,
    required this.downloadUrl,
  });

  factory PayrollHistoryModel.fromJson(Map<String, dynamic> json) {
    return PayrollHistoryModel(
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      totalAmount: json['total_amount'] ?? 0,
      downloadUrl: json['download_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date,
      'total_amount': totalAmount,
      'download_url': downloadUrl,
    };
  }

  /// sample data
  static List<PayrollHistoryModel> tempData = [
    PayrollHistoryModel.fromJson({
      "name": "Payroll – August 2025",
      "date": "2025-08-01",
      "total_amount": 80000,
      "download_url": "https://example.com/payroll/august_2025.pdf"
    }),
    PayrollHistoryModel.fromJson({
      "name": "Payroll – July 2025",
      "date": "2025-07-01",
      "total_amount": 79000,
      "download_url": "https://example.com/payroll/july_2025.pdf"
    }),
    PayrollHistoryModel.fromJson({
      "name": "Payroll – June 2025",
      "date": "2025-06-01",
      "total_amount": 78000,
      "download_url": "https://example.com/payroll/june_2025.pdf"
    }),
    PayrollHistoryModel.fromJson({
      "name": "Payroll – May 2025",
      "date": "2025-05-01",
      "total_amount": 78000,
      "download_url": "https://example.com/payroll/may_2025.pdf"
    }),
    PayrollHistoryModel.fromJson({
      "name": "Payroll – April 2025",
      "date": "2025-04-01",
      "total_amount": 77500,
      "download_url": "https://example.com/payroll/april_2025.pdf"
    }),
  ];
}
