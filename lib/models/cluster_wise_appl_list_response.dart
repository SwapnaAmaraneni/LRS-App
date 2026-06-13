class ClusterwiseApplicationListResponse {
  int? statusCode;
  String? statusMsg;
  List<ClusterwiseApplListResponseDetails>? clusterwiseApplicationListDetails;

  ClusterwiseApplicationListResponse(
      {this.statusCode,
      this.statusMsg,
      this.clusterwiseApplicationListDetails});

  ClusterwiseApplicationListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['applications'] != null) {
      clusterwiseApplicationListDetails =
          <ClusterwiseApplListResponseDetails>[];
      json['applications'].forEach((v) {
        clusterwiseApplicationListDetails!
            .add(ClusterwiseApplListResponseDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (clusterwiseApplicationListDetails != null) {
      data['applications'] =
          clusterwiseApplicationListDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClusterwiseApplListResponseDetails {
  String? vILLAGEID;
  String? cLUSTERID;
  String? aPPLICATIONID;
  String? vILLAGENAME;
  String? sURVEYNUMBER;
  String? aPPCOUNT;
  String? pLOTEXTENT;
  String? plotNo;
  String? applicantName;
  String? tpFlag;
  String? irFlag;
  String? reFlag;
  String? mobileNumber;

  ClusterwiseApplListResponseDetails({
    this.vILLAGEID,
    this.cLUSTERID,
    this.aPPLICATIONID,
    this.vILLAGENAME,
    this.sURVEYNUMBER,
    this.aPPCOUNT,
    this.pLOTEXTENT,
    this.plotNo,
    this.applicantName,
    this.tpFlag,
    this.irFlag,
    this.reFlag,
    this.mobileNumber,
  });

  ClusterwiseApplListResponseDetails.fromJson(Map<String, dynamic> json) {
    vILLAGEID = json['VILLAGE_ID'];
    cLUSTERID = json['CLUSTER_ID'];
    aPPLICATIONID = json['APPLICATION_ID'];
    vILLAGENAME = json['VILLAGE_NAME'];
    sURVEYNUMBER = json['SURVEY_NUMBER'];
    aPPCOUNT = json['APPCOUNT'];
    pLOTEXTENT = json['PLOT_EXTENT'];
    plotNo = json['PLOT_NO'];
    applicantName = json['ApplicantName'];
    tpFlag = json['TP_FLAG'];
    irFlag = json['IR_FLAG'];
    reFlag = json['RE_FLAG'];
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
    data['PLOT_NO'] = plotNo;
    data['ApplicantName'] = applicantName;
    data['TP_FLAG'] = tpFlag;
    data['IR_FLAG'] = irFlag;
    data['RE_FLAG'] = reFlag;
    data['Mobile_Number'] = mobileNumber;
    return data;
  }
}
