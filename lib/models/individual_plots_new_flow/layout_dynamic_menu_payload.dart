class LayoutDynamicSubMenuPayload {
  String? userID;
  String? empID;
  String? tokenID;
  String? mPIN;
  String? iSLayoutPlot;

  LayoutDynamicSubMenuPayload(
      {this.userID, this.empID, this.tokenID, this.mPIN, this.iSLayoutPlot});

  LayoutDynamicSubMenuPayload.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    mPIN = json['MPIN'];
    iSLayoutPlot = json['IS_Layout_Plot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['MPIN'] = mPIN;
    data['IS_Layout_Plot'] = iSLayoutPlot;
    return data;
  }
}
