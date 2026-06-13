class VersionCheckResponse {
  int? statusCode;
  String? statusMsg;
  String? versionID;
  String? dateTime;
  String? deleteFlag;

  VersionCheckResponse(
      {this.statusCode,
      this.statusMsg,
      this.versionID,
      this.dateTime,
      this.deleteFlag});

  VersionCheckResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    versionID = json['VersionID'];
    dateTime = json['DateTime'];
    deleteFlag = json['Delete_Flg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    data['VersionID'] = versionID;
    data['DateTime'] = dateTime;
    data['Delete_Flg'] = deleteFlag;
    return data;
  }
}
