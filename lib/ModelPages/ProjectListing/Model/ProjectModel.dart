import 'dart:convert';

class ProjectModel {
  String id = '';
  String projectCaption = '';
  String projectname = '';
  String url = '';
  String scripts_uri = '';
  String dbtype = '';
  String expirydate = '';
  String notify_uri = '';
  String web_url = '';
  String arm_url = '';

  ProjectModel(this.id, this.projectname, this.web_url, this.arm_url, this.projectCaption);

  // Convert a Project object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectCaption': projectCaption,
      'projectname': projectname,
      'url': url,
      'scripts_uri': scripts_uri,
      'dbtype': dbtype,
      'expirydate': expirydate,
      'notify_uri': notify_uri,
      'web_url': web_url,
      'arm_url': arm_url,
    };
  }

  // Create a Project object from a Map
  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      map['id'],
      map['projectname'],
      map['web_url'],
      map['arm_url'],
      map['projectCaption'] ?? map['projectname'],
    );
  }

  ProjectModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        projectname = json['projectname'],
        projectCaption = json['projectCaption'] ?? json['projectname'],
        url = json['url'],
        scripts_uri = json['scripts_uri'],
        dbtype = json['dbtype'],
        expirydate = json['expirydate'],
        notify_uri = json['notify_uri'],
        web_url = json['web_url'],
        arm_url = json['arm_url'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectCaption': projectCaption,
        'projectname': projectname,
        'url': url,
        'scripts_uri': scripts_uri,
        'dbtype': dbtype,
        'expirydate': expirydate,
        'notify_uri': notify_uri,
        'web_url': web_url,
        'arm_url': arm_url,
      };

  // Encode list to JSON
  static String encode(List<ProjectModel> projects) {
    return json.encode(projects.map((p) => p.toMap()).toList());
  }

  // Decode JSON to list
  static List<ProjectModel> decode(String projectsJson) {
    return (json.decode(projectsJson) as List<dynamic>).map<ProjectModel>((p) => ProjectModel.fromMap(p)).toList();
  }
}
