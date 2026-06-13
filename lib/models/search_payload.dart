class SearchApplicationPayload {
  String? userID;
  String? empID;
  String? tokenID;
  String? applicationID;
  String? iSLayoutPlot;

  SearchApplicationPayload(
      {this.userID,
      this.empID,
      this.tokenID,
      this.applicationID,
      this.iSLayoutPlot});

  SearchApplicationPayload.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    applicationID = json['Application_ID'];
    iSLayoutPlot = json['IS_Layout_Plot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['Application_ID'] = applicationID;
    data['IS_Layout_Plot'] = iSLayoutPlot;
    return data;
  }
}
