
class PayBreakup {
  String name;
  String addordeduct;
  double amount;

  PayBreakup({
    required this.name,
    required this.amount,
    required this.addordeduct,
  });

  factory PayBreakup.fromJson(Map<String, dynamic> json) {
    return PayBreakup(
      name: json['paycode'] ?? '',
      amount: json['amount'] ?? 0.0,
      addordeduct: json['addordeduct'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}
