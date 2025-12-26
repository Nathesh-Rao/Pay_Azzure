class EmployeeData {
  final double arvEmpmaidn;
  final String arvEmpidc;
  final String arvCorporatecodec;
  final String arvCorporatec;
  final String arvCompanycodec;
  final String arvCompanyc;
  final double arvCompaidn;
  final String arvBranchc;
  final double arvBranchidn;
  final String arvPayperiodc;
  final String arvPayStartDated;
  final String arvFinyrcodec;
  final String arvSpayperiodc;
  final String arvSpayStartDated;
  final String arvSfinyrcodec;
  final String arvInvestmentTypec;
  final String arvClientSchemac;
  final String arvClientSchemacName;

  EmployeeData({
    required this.arvEmpmaidn,
    required this.arvEmpidc,
    required this.arvCorporatecodec,
    required this.arvCorporatec,
    required this.arvCompanycodec,
    required this.arvCompanyc,
    required this.arvCompaidn,
    required this.arvBranchc,
    required this.arvBranchidn,
    required this.arvPayperiodc,
    required this.arvPayStartDated,
    required this.arvFinyrcodec,
    required this.arvSpayperiodc,
    required this.arvSpayStartDated,
    required this.arvSfinyrcodec,
    required this.arvInvestmentTypec,
    required this.arvClientSchemac,
    required this.arvClientSchemacName,
  });

  // Helper to safely parse any numeric JSON into double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      arvEmpmaidn: _parseDouble(json["arv_empmaidn"]),
      arvEmpidc: json["arv_empidc"]?.toString() ?? "",
      arvCorporatecodec: json["arv_corporatecodec"]?.toString() ?? "",
      arvCorporatec: json["arv_corporatec"]?.toString() ?? "",
      arvCompanycodec: json["arv_companycodec"]?.toString() ?? "",
      arvCompanyc: json["arv_companyc"]?.toString() ?? "",
      arvCompaidn: _parseDouble(json["arv_compaidn"]),
      arvBranchc: json["arv_branchc"]?.toString() ?? "",
      arvBranchidn: _parseDouble(json["arv_branchidn"]),
      arvPayperiodc: json["arv_payperiodc"]?.toString() ?? "",
      arvPayStartDated: json["arv_pay_start_dated"]?.toString() ?? "",
      arvFinyrcodec: json["arv_finyrcodec"]?.toString() ?? "",
      arvSpayperiodc: json["arv_spayperiodc"]?.toString() ?? "",
      arvSpayStartDated: json["arv_spay_start_dated"]?.toString() ?? "",
      arvSfinyrcodec: json["arv_sfinyrcodec"]?.toString() ?? "",
      arvInvestmentTypec: json["arv_investment_typec"]?.toString() ?? "",
      arvClientSchemac: json["arv_client_schemac"]?.toString() ?? "",
      arvClientSchemacName: json["arv_client_schemac_name"]?.toString() ?? "",
    );
  }
}
