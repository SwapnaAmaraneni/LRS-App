class GlobalSearchPayload {
  String? userID;
  String? empID;
  String? tokenID;
  String? sEARCHTYPE;
  String? aPPLICATIONID;
  int? dISTRICTID;
  int? mANDALID;
  int? vILLAGEID;
  String? nAME;
  String? sURVEYNO;

  GlobalSearchPayload(
      {this.userID,
      this.empID,
      this.tokenID,
      this.sEARCHTYPE,
      this.aPPLICATIONID,
      this.dISTRICTID,
      this.mANDALID,
      this.vILLAGEID,
      this.nAME,
      this.sURVEYNO});

  GlobalSearchPayload.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    sEARCHTYPE = json['SEARCHTYPE'];
    aPPLICATIONID = json['APPLICATIONID'];
    dISTRICTID = json['DISTRICTID'];
    mANDALID = json['MANDALID'];
    vILLAGEID = json['VILLAGEID'];
    nAME = json['NAME'];
    sURVEYNO = json['SURVEYNO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['SEARCHTYPE'] = sEARCHTYPE;
    data['APPLICATIONID'] = aPPLICATIONID;
    data['DISTRICTID'] = dISTRICTID;
    data['MANDALID'] = mANDALID;
    data['VILLAGEID'] = vILLAGEID;
    data['NAME'] = nAME;
    data['SURVEYNO'] = sURVEYNO;
    return data;
  }
}
