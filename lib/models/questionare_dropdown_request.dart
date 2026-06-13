class QuestionareDropdownRequest {
  String? questionID;
  String? empID;
  String? tokenID;
  String? isLayoutPlot;

  QuestionareDropdownRequest(
      {this.questionID, this.empID, this.tokenID, this.isLayoutPlot});

  QuestionareDropdownRequest.fromJson(Map<String, dynamic> json) {
    questionID = json['Question_ID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    isLayoutPlot = json['IS_Layout_Plot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Question_ID'] = questionID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['IS_Layout_Plot'] = isLayoutPlot;
    return data;
  }
}
