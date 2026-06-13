class RecommendationDetailsRequest {
  String? userID;
  String? empID;
  String? tokenID;
  String? isLayoutPlot;

  RecommendationDetailsRequest(
      {this.userID, this.empID, this.tokenID, this.isLayoutPlot});

  RecommendationDetailsRequest.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    isLayoutPlot = json['IS_Layout_Plot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['IS_Layout_Plot'] = isLayoutPlot;
    return data;
  }
}
