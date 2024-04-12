class ProjectModel {
  String projectCaption = '';
  String projectname = '';
  String url = '';
  String scripts_uri = '';
  String dbtype = '';
  String expirydate = '';
  String notify_uri = '';
  String web_url = '';
  String arm_url = '';

  ProjectModel(
      this.projectname, this.web_url, this.arm_url, this.projectCaption);

  ProjectModel.fromJson(Map<String, dynamic> json)
      : projectname = json['projectname'],
        projectCaption = json['projectCaption'] ?? json['projectname'],
        url = json['url'],
        scripts_uri = json['scripts_uri'],
        dbtype = json['dbtype'],
        expirydate = json['expirydate'],
        notify_uri = json['notify_uri'],
        web_url = json['web_url'],
        arm_url = json['arm_url'];

  Map<String, dynamic> toJson() => {
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
