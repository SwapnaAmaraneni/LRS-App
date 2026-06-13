class SavedApplicationsListPayload {
  String? userID;
  String? empID;
  String? tokenID;
  String? iSLayoutPlot;

  SavedApplicationsListPayload(
      {this.userID, this.empID, this.tokenID, this.iSLayoutPlot});

  SavedApplicationsListPayload.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    iSLayoutPlot = json['IS_Layout_Plot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['IS_Layout_Plot'] = iSLayoutPlot;
    return data;
  }
}
