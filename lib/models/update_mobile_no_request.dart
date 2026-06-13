class UpdateMobileNoRequest {
  String? userID;
  String? empID;
  String? tokenID;
  String? aPPLICATIONID;
  String? oLDMOBILENO;
  String? nEWMOBILENO;
  String? iPADDRESS;
  String? cREATEDBY;
  String? mOBILEUPDATEPROOF;
   String? isLayoutPlot;


  UpdateMobileNoRequest(
      {this.userID,
      this.empID,
      this.tokenID,
      this.aPPLICATIONID,
      this.oLDMOBILENO,
      this.nEWMOBILENO,
      this.iPADDRESS,
      this.cREATEDBY,
      this.mOBILEUPDATEPROOF, this.isLayoutPlot});

  UpdateMobileNoRequest.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    aPPLICATIONID = json['APPLICATION_ID'];
    oLDMOBILENO = json['OLD_MOBILENO'];
    nEWMOBILENO = json['NEW_MOBILENO'];
    iPADDRESS = json['IPADDRESS'];
    cREATEDBY = json['CREATEDBY'];
    mOBILEUPDATEPROOF = json['MOBILEUPDATEPROOF'];
    isLayoutPlot = json['IS_Layout_Plot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['APPLICATION_ID'] = aPPLICATIONID;
    data['OLD_MOBILENO'] = oLDMOBILENO;
    data['NEW_MOBILENO'] = nEWMOBILENO;
    data['IPADDRESS'] = iPADDRESS;
    data['CREATEDBY'] = cREATEDBY;
    data['MOBILEUPDATEPROOF'] = mOBILEUPDATEPROOF;
    data['IS_Layout_Plot'] = isLayoutPlot;
    return data;
  }
}
