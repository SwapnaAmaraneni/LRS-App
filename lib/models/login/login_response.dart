class OfficerLoginResponse {
  int? statusCode;
  String? statusMsg;
  LoginDtls? loginDtls;

  OfficerLoginResponse({this.statusCode, this.statusMsg, this.loginDtls});

  OfficerLoginResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    loginDtls = json['loginDtls'] != null
        ? LoginDtls.fromJson(json['loginDtls'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (loginDtls != null) {
      data['loginDtls'] = loginDtls!.toJson();
    }
    return data;
  }
}

class LoginDtls {
  String? userID;
  String? empID;
  String? username;
  String? officeId;
  String? type;
  String? authorityName;
  String? typeID;
  String? tokenID;
  String? mPIN;
  String? oTP;
  String? mOBILENO;
  String? uSERTYPE;
  String? mandalID;
  String? villageID;
  String? surveyNO;

  LoginDtls(
      {this.userID,
      this.empID,
      this.username,
      this.officeId,
      this.type,
      this.authorityName,
      this.typeID,
      this.tokenID,
      this.mPIN,
      this.oTP,
      this.mOBILENO,
      this.uSERTYPE,
      this.mandalID,
      this.villageID,
      this.surveyNO});

  LoginDtls.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    username = json['Username'];
    officeId = json['OfficeId'];
    type = json['Type'];
    authorityName = json['AuthorityName'];
    typeID = json['TypeID'];
    tokenID = json['TokenID'];
    mPIN = json['MPIN'];
    oTP = json['OTP'];
    mOBILENO = json['MOBILE_NO'];
    uSERTYPE = json['USERTYPE'];
    mandalID = json['MandalID'];
    villageID = json['VillageID'];
    surveyNO = json['SurveyNO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['Username'] = username;
    data['OfficeId'] = officeId;
    data['Type'] = type;
    data['AuthorityName'] = authorityName;
    data['TypeID'] = typeID;
    data['TokenID'] = tokenID;
    data['MPIN'] = mPIN;
    data['OTP'] = oTP;
    data['MOBILE_NO'] = mOBILENO;
    data['USERTYPE'] = uSERTYPE;
    data['MandalID'] = mandalID;
    data['VillageID'] = villageID;
    data['SurveyNO'] = surveyNO;
    return data;
  }
}
