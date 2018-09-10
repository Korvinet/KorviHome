class Settings {
  String homeSeerUrl;
  String homeSeerUser;
  String homeSeerPwd;

  String hassUrl;
  String hassUser;
  String hassPwd;

  Settings(this.homeSeerUrl, this.homeSeerUser, this.homeSeerPwd,
        this.hassUrl, this.hassUser, this.hassPwd);

  Settings.fromJson(Map<String, dynamic> json)
      : homeSeerUrl = json['homeSeerUrl'],
        homeSeerUser = json['homeSeerUser'],
        homeSeerPwd = json['homeSeerPwd'],

        hassUrl = json['hassUrl'],
        hassUser = json['hassUser'],
        hassPwd = json['hassPwd'];

  Map<String, dynamic> toJson() =>
    {
      'homeSeerUrl': homeSeerUrl,
      'homeSeerUser': homeSeerUser,
      'homeSeerPwd': homeSeerPwd,

      'hassUrl': hassUrl,
      'hassUser': hassUser,
      'hassPwd': hassPwd,
      
    };

}