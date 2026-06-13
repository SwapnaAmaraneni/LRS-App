class GenerateMPINPayLoad {
  String? userID;
  String? empID;
  String? tokenID;
  String? mPIN;

  GenerateMPINPayLoad({this.userID, this.empID, this.tokenID, this.mPIN});

  GenerateMPINPayLoad.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    mPIN = json['MPIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['MPIN'] = mPIN;
    return data;
  }
}
