class ListofClusterCountResquest {
  String? userID;
  String? empID;
  String? tokenID;
  String? villageID;
  String? isLayoutPlot;

  ListofClusterCountResquest(
      {this.userID,
      this.empID,
      this.tokenID,
      this.villageID,
      this.isLayoutPlot});

  ListofClusterCountResquest.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    villageID = json['Village_ID'];
    isLayoutPlot = json['IS_Layout_Plot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['Village_ID'] = villageID;
    data['IS_Layout_Plot'] = isLayoutPlot;
    return data;
  }
}
