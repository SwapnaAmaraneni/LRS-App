class DashboardPayload {
  String? userID;
  String? empID;
  String? tokenID;

  DashboardPayload({this.userID, this.empID, this.tokenID});

  DashboardPayload.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    return data;
  }
}
