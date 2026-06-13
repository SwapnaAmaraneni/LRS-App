class SavedApplicationsListResponse {
  int? statusCode;
  String? statusMsg;
  List<SavedApplications>? applications;

  SavedApplicationsListResponse(
      {this.statusCode, this.statusMsg, this.applications});

  SavedApplicationsListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['applications'] != null) {
      applications = <SavedApplications>[];
      json['applications'].forEach((v) {
        applications!.add(SavedApplications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (applications != null) {
      data['applications'] = applications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SavedApplications {
  String? vILLAGEID;
  String? cLUSTERID;
  String? aPPLICATIONID;
  String? vILLAGENAME;
  String? sURVEYNUMBER;
  String? aPPCOUNT;
  String? pLOTEXTENT;
  String? applicantName;
  String? sTATUSID;
  String? iSLAYOUTPLOT;
  String? tpFlag;
  String? irFlag;
  String? reFlag;
  String? prohibitedFlag;
  String? mobileNumber;

  SavedApplications(
      {this.vILLAGEID,
      this.cLUSTERID,
      this.aPPLICATIONID,
      this.vILLAGENAME,
      this.sURVEYNUMBER,
      this.aPPCOUNT,
      this.pLOTEXTENT,
      this.applicantName,
      this.sTATUSID,
      this.iSLAYOUTPLOT,
      this.tpFlag,
      this.irFlag,
      this.reFlag,
      this.prohibitedFlag,
      this.mobileNumber});

  SavedApplications.fromJson(Map<String, dynamic> json) {
    vILLAGEID = json['VILLAGE_ID'];
    cLUSTERID = json['CLUSTER_ID'];
    aPPLICATIONID = json['APPLICATION_ID'];
    vILLAGENAME = json['VILLAGE_NAME'];
    sURVEYNUMBER = json['SURVEY_NUMBER'];
    aPPCOUNT = json['APPCOUNT'];
    pLOTEXTENT = json['PLOT_EXTENT'];
    applicantName = json['ApplicantName'];
    sTATUSID = json['STATUS_ID'];
    iSLAYOUTPLOT = json['IS_LAYOUT_PLOT'];
    tpFlag = json['TP_FLAG'];
    irFlag = json['IR_FLAG'];
    reFlag = json['RE_FLAG'];
    prohibitedFlag = json['PROHIBITED_FLAG'];
    mobileNumber = json['Mobile_Number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VILLAGE_ID'] = vILLAGEID;
    data['CLUSTER_ID'] = cLUSTERID;
    data['APPLICATION_ID'] = aPPLICATIONID;
    data['VILLAGE_NAME'] = vILLAGENAME;
    data['SURVEY_NUMBER'] = sURVEYNUMBER;
    data['APPCOUNT'] = aPPCOUNT;
    data['PLOT_EXTENT'] = pLOTEXTENT;
    data['ApplicantName'] = applicantName;
    data['STATUS_ID'] = sTATUSID;
    data['IS_LAYOUT_PLOT'] = iSLAYOUTPLOT;
    data['TP_FLAG'] = tpFlag;
    data['IR_FLAG'] = irFlag;
    data['RE_FLAG'] = reFlag;
    data['PROHIBITED_FLAG'] = prohibitedFlag;
    data['Mobile_Number'] = mobileNumber;
    return data;
  }
}
