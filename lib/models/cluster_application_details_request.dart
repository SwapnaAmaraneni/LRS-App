class ClusterApplicationDetailsRequest {
  String? userID;
  String? empID;
  String? tokenID;
  String? applicationID;
  String? isLayoutPlot;

  ClusterApplicationDetailsRequest(
      {this.userID,
      this.empID,
      this.tokenID,
      this.applicationID,
      this.isLayoutPlot});

  ClusterApplicationDetailsRequest.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    applicationID = json['Application_ID'];
    isLayoutPlot = json['IS_Layout_Plot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['Application_ID'] = applicationID;
    data['IS_Layout_Plot'] = isLayoutPlot;
    return data;
  }
}
