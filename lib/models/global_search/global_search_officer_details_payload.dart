class GlobalSearchOfficerDetailsPayload {
  String? userID;
  String? empID;
  String? tokenID;
  String? aPPLICATIONID;

  GlobalSearchOfficerDetailsPayload(
      {this.userID, this.empID, this.tokenID, this.aPPLICATIONID});

  GlobalSearchOfficerDetailsPayload.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    aPPLICATIONID = json['APPLICATIONID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['APPLICATIONID'] = aPPLICATIONID;
    return data;
  }
}
