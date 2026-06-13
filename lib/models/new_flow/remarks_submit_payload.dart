class SubmitFeeIntimatedRemarksPayload {
  String? userID;
  String? empID;
  String? tokenID;
  String? applicationID;
  String? l1REMARKS;
  String? iPAddress;

  SubmitFeeIntimatedRemarksPayload(
      {this.userID,
      this.empID,
      this.tokenID,
      this.applicationID,
      this.l1REMARKS,
      this.iPAddress});

  SubmitFeeIntimatedRemarksPayload.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    applicationID = json['Application_ID'];
    l1REMARKS = json['L1_REMARKS'];
    iPAddress = json['IPAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['Application_ID'] = applicationID;
    data['L1_REMARKS'] = l1REMARKS;
    data['IPAddress'] = iPAddress;
    return data;
  }
}
