class FifpApplicationsListResponse {
  int? statusCode;
  String? statusMsg;
  String? downloadUrl;
  List<FifpApplications>? fifpApplications;

  FifpApplicationsListResponse(
      {this.statusCode, this.statusMsg, this.fifpApplications});

  FifpApplicationsListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    downloadUrl = json['download_url'];
    if (json['fee_paid_applications'] != null) {
      fifpApplications = <FifpApplications>[];
      json['fee_paid_applications'].forEach((v) {
        fifpApplications!.add(FifpApplications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    data['download_url'] = downloadUrl;
    if (fifpApplications != null) {
      data['fee_paid_applications'] =
          fifpApplications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FifpApplications {
  String? aPPLICATIONID;
  String? lAYOUTOWNERNAME;
  String? oWNERMOBILENUMBER;
  String? vILLAGENAME;
  String? sURVEYNUMBER;
  String? pLOTEXTENT;
  String? sTATUSID;
  String? sTATUS;
  String? rEBATEAMOUNT;
  String? tOTLAMOUNT;
  String? tOBEPAIDAMOUNT;
  String? paidAmount;
  String? l1Remarks;

  FifpApplications(
      {this.aPPLICATIONID,
      this.lAYOUTOWNERNAME,
      this.oWNERMOBILENUMBER,
      this.vILLAGENAME,
      this.sURVEYNUMBER,
      this.pLOTEXTENT,
      this.sTATUSID,
      this.sTATUS,
      this.rEBATEAMOUNT,
      this.tOTLAMOUNT,
      this.tOBEPAIDAMOUNT,
      this.paidAmount,
      this.l1Remarks});

  FifpApplications.fromJson(Map<String, dynamic> json) {
    aPPLICATIONID = json['APPLICATION_ID'];
    lAYOUTOWNERNAME = json['LAYOUTOWNERNAME'];
    oWNERMOBILENUMBER = json['OWNERMOBILENUMBER'];
    vILLAGENAME = json['VILLAGE_NAME'];
    sURVEYNUMBER = json['SURVEY_NUMBER'];
    pLOTEXTENT = json['PLOT_EXTENT'];
    sTATUSID = json['STATUS_ID'];
    sTATUS = json['STATUS'];
    rEBATEAMOUNT = json['REBATE_AMOUNT'];
    tOTLAMOUNT = json['TOTL_AMOUNT'];
    tOBEPAIDAMOUNT = json['TO_BE_PAID_AMOUNT'];
    paidAmount = json['PAID_AMOUNT'];
    l1Remarks = json['L1_REMARKS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['APPLICATION_ID'] = aPPLICATIONID;
    data['LAYOUTOWNERNAME'] = lAYOUTOWNERNAME;
    data['OWNERMOBILENUMBER'] = oWNERMOBILENUMBER;
    data['VILLAGE_NAME'] = vILLAGENAME;
    data['SURVEY_NUMBER'] = sURVEYNUMBER;
    data['PLOT_EXTENT'] = pLOTEXTENT;
    data['STATUS_ID'] = sTATUSID;
    data['STATUS'] = sTATUS;
    data['REBATE_AMOUNT'] = rEBATEAMOUNT;
    data['TOTL_AMOUNT'] = tOTLAMOUNT;
    data['TO_BE_PAID_AMOUNT'] = tOBEPAIDAMOUNT;
    data['PAID_AMOUNT'] = paidAmount;
    data['L1_REMARKS'] = l1Remarks;
    return data;
  }
}
