/// success : true
/// message : "Success"
/// pwdauth : "T"
/// language : ""
/// pwdsettings : {"pwdminchar":0,"pwdmaxchar":20,"pwdalphanum":"F","pwdcapchar":0,"pwdsmallchar":0,"pwdnumchar":0,"pwdsplchar":0}
/// otpauth : "T"
/// otpsettings : {"otpchars":"4","otpexpiry":"2"}

class AuthUserDetailsModel {
  bool? success;
  String? message;
  bool? pwdauth;
  String? language;
  Pwdsettings? pwdsettings;
  bool? otpauth;
  Otpsettings? otpsettings;
  AuthUserDetailsModel({
    this.success,
    this.message,
    this.pwdauth,
    this.language,
    this.pwdsettings,
    this.otpauth,
    this.otpsettings,});

  AuthUserDetailsModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    pwdauth = _parseBool(json['pwdauth']);
    language = json['language'];
    pwdsettings = json['pwdsettings'] != null ? Pwdsettings.fromJson(json['pwdsettings']) : null;
    otpauth = _parseBool(json['otpauth']);
    otpsettings = json['otpsettings'] != null ? Otpsettings.fromJson(json['otpsettings']) : null;
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) return value.toUpperCase() == 'T';
    return null;
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['pwdauth'] = pwdauth;
    map['language'] = language;
    if (pwdsettings != null) {
      map['pwdsettings'] = pwdsettings?.toJson();
    }
    map['otpauth'] = otpauth;
    if (otpsettings != null) {
      map['otpsettings'] = otpsettings?.toJson();
    }
    return map;
  }

}

/// otpchars : "4"
/// otpexpiry : "2"

class Otpsettings {
  String? otpchars;
  String? otpexpiry;
  Otpsettings({
    this.otpchars,
    this.otpexpiry,});

  Otpsettings.fromJson(dynamic json) {
    otpchars = json['otpchars'];
    otpexpiry = json['otpexpiry'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otpchars'] = otpchars;
    map['otpexpiry'] = otpexpiry;
    return map;
  }

}

/// pwdminchar : 0
/// pwdmaxchar : 20
/// pwdalphanum : "F"
/// pwdcapchar : 0
/// pwdsmallchar : 0
/// pwdnumchar : 0
/// pwdsplchar : 0

class Pwdsettings {
  String? pwdminchar;
  String? pwdmaxchar;
  String? pwdalphanum;
  String? pwdcapchar;
  String? pwdsmallchar;
  String? pwdnumchar;
  String? pwdsplchar;
  Pwdsettings({
    this.pwdminchar,
    this.pwdmaxchar,
    this.pwdalphanum,
    this.pwdcapchar,
    this.pwdsmallchar,
    this.pwdnumchar,
    this.pwdsplchar,});

  Pwdsettings.fromJson(dynamic json) {
    pwdminchar = json['pwdminchar'];
    pwdmaxchar = json['pwdmaxchar'];
    pwdalphanum = json['pwdalphanum'];
    pwdcapchar = json['pwdcapchar'];
    pwdsmallchar = json['pwdsmallchar'];
    pwdnumchar = json['pwdnumchar'];
    pwdsplchar = json['pwdsplchar'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pwdminchar'] = pwdminchar;
    map['pwdmaxchar'] = pwdmaxchar;
    map['pwdalphanum'] = pwdalphanum;
    map['pwdcapchar'] = pwdcapchar;
    map['pwdsmallchar'] = pwdsmallchar;
    map['pwdnumchar'] = pwdnumchar;
    map['pwdsplchar'] = pwdsplchar;
    return map;
  }

}