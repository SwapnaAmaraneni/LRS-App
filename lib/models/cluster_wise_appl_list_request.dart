class ClusterwiseApplicationListRequest {
  String? userID;
  String? empID;
  String? tokenID;
  String? clusterID;
  String? vILLAGEID;
  String? isLayoutPlot;

  ClusterwiseApplicationListRequest(
      {this.userID,
      this.empID,
      this.tokenID,
      this.clusterID,
      this.vILLAGEID,
      this.isLayoutPlot});

  ClusterwiseApplicationListRequest.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    clusterID = json['Cluster_ID'];
    vILLAGEID = json['VILLAGE_ID'];
    isLayoutPlot = json['IS_Layout_Plot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['Cluster_ID'] = clusterID;
    data['VILLAGE_ID'] = vILLAGEID;
    data['IS_Layout_Plot'] = isLayoutPlot;
    return data;
  }
}
