class IGRSApplicationResponseModel {
  int? statusCode;
  String? statusMsg;
  List<IGRSApplicationList>? iGRSApplicationList;

  IGRSApplicationResponseModel(
      {this.statusCode, this.statusMsg, this.iGRSApplicationList});

  IGRSApplicationResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['IGRS_Application_List'] != null) {
      iGRSApplicationList = <IGRSApplicationList>[];
      json['IGRS_Application_List'].forEach((v) {
        iGRSApplicationList!.add(IGRSApplicationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (iGRSApplicationList != null) {
      data['IGRS_Application_List'] =
          iGRSApplicationList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IGRSApplicationList {
  String? aPPLICATIONID;
  String? aPPLICANTNAME;
  String? mOBILENO;
  String? dISTRICTNAME;
  String? mANDALNAME;
  String? vILLAGENAME;
  String? sURVEYNUMBER;
  String? tOTALREGCHARGES;
  String? fEEPAID;
  String? rEBATEAMTCAL;
  String? iNITIALCHARGES;
  String? tOTFEEPAID;

  IGRSApplicationList(
      {this.aPPLICATIONID,
      this.aPPLICANTNAME,
      this.mOBILENO,
      this.dISTRICTNAME,
      this.mANDALNAME,
      this.vILLAGENAME,
      this.sURVEYNUMBER,
      this.tOTALREGCHARGES,
      this.fEEPAID,
      this.rEBATEAMTCAL,
      this.iNITIALCHARGES,
      this.tOTFEEPAID});

  IGRSApplicationList.fromJson(Map<String, dynamic> json) {
    aPPLICATIONID = json['APPLICATION_ID'];
    aPPLICANTNAME = json['APPLICANT_NAME'];
    mOBILENO = json['MOBILE_NO'];
    dISTRICTNAME = json['DISTRICT_NAME'];
    mANDALNAME = json['MANDAL_NAME'];
    vILLAGENAME = json['VILLAGE_NAME'];
    sURVEYNUMBER = json['SURVEY_NUMBER'];
    tOTALREGCHARGES = json['TOTAL_REG_CHARGES'];
    fEEPAID = json['FEE_PAID'];
    rEBATEAMTCAL = json['REBATE_AMT_CAL'];
    iNITIALCHARGES = json['INITIAL_CHARGES'];
    tOTFEEPAID = json['TOT_FEE_PAID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['APPLICATION_ID'] = aPPLICATIONID;
    data['APPLICANT_NAME'] = aPPLICANTNAME;
    data['MOBILE_NO'] = mOBILENO;
    data['DISTRICT_NAME'] = dISTRICTNAME;
    data['MANDAL_NAME'] = mANDALNAME;
    data['VILLAGE_NAME'] = vILLAGENAME;
    data['SURVEY_NUMBER'] = sURVEYNUMBER;
    data['TOTAL_REG_CHARGES'] = tOTALREGCHARGES;
    data['FEE_PAID'] = fEEPAID;
    data['REBATE_AMT_CAL'] = rEBATEAMTCAL;
    data['INITIAL_CHARGES'] = iNITIALCHARGES;
    data['TOT_FEE_PAID'] = tOTFEEPAID;
    return data;
  }
}
