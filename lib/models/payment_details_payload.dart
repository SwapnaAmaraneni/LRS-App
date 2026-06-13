class PaymentDetailsPayload {
  String? userID;
  String? empID;
  String? tokenID;
  String? mPIN;
  String? applicationID;
  String? totalAreaExtent;
  String? mVRATE2020;
  String? mVRATEDOCUMET;
  String? isLayoutPlot;

  PaymentDetailsPayload(
      {this.userID,
      this.empID,
      this.tokenID,
      this.mPIN,
      this.applicationID,
      this.totalAreaExtent,
      this.mVRATE2020,
      this.mVRATEDOCUMET,
      this.isLayoutPlot});

  PaymentDetailsPayload.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    mPIN = json['MPIN'];
    applicationID = json['ApplicationID'];
    totalAreaExtent = json['TotalAreaExtent'];
    mVRATE2020 = json['MV_RATE_2020'];
    mVRATEDOCUMET = json['MV_RATE_DOCUMET'];
    isLayoutPlot = json['IS_Layout_Plot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['MPIN'] = mPIN;
    data['ApplicationID'] = applicationID;
    data['TotalAreaExtent'] = totalAreaExtent;
    data['MV_RATE_2020'] = mVRATE2020;
    data['MV_RATE_DOCUMET'] = mVRATEDOCUMET;
    data['IS_Layout_Plot'] = isLayoutPlot;
    return data;
  }
}
