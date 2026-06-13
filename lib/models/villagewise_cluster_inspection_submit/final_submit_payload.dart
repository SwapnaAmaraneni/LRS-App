class FinalSubmitPayload {
  String? aPPLICATIONID;
  String? lAYOUTNAME;
  String? pLOTNO;
  String? aREAEXTENT;
  String? pLOTAREAEXTENT;
  String? rOADAREAEXTENT;
  String? mASTERPLANZDP;
  String? latitude;
  String? longitude;
  String? lAYOUTDOC;
  String? oWNERSHIPDOC;
  String? eCDOC;
  String? pHOTO1;
  String? pHOTO2;
  String? pHOTO3;
  String? pHOTO4;
  String? pHOTO5;
  String? sRDPRDP;
  String? conversionCharges;
  String? mVRATE2020;
  String? mVRATEDOCUMET;
  String? rC;
  String? vLT;
  String? pLOTOPENSPACE;
  String? tRC;
  String? aDDITIONALCONDITION;
  String? nOTES;
  String? cONDTION;
  String? rECOMMENDATIONS;
  String? iPAddress;
  String? userID;
  String? empID;
  String? tokenID;
  String? uNIREFID;
  String? sTATUSID;
  String? gISCORDINATE;
  String? gISCOUNT;
  List<CHECKLIST>? cHECKLIST;
  String? isLayoutPlot;
  String? totalNoPlots;
  String? totalNoOfSoldPlots;
  String? totalNoOfUnSoldPlots;
  String? totalNoAreaExtent;
  String? isSaveType;
  List<UnSoldPlots>? unSoldPlotsList;
  String? updMVRate2020;

  String? updMvRateDoc;
  String? fifpFlag;

  String? updAreaExtent;
  String? updPlotAreaExtent;
  String? updRoadAreaExtent;

  FinalSubmitPayload(
      {this.aPPLICATIONID,
      this.lAYOUTNAME,
      this.pLOTNO,
      this.aREAEXTENT,
      this.pLOTAREAEXTENT,
      this.rOADAREAEXTENT,
      this.mASTERPLANZDP,
      this.latitude,
      this.longitude,
      this.lAYOUTDOC,
      this.oWNERSHIPDOC,
      this.eCDOC,
      this.pHOTO1,
      this.pHOTO2,
      this.pHOTO3,
      this.pHOTO4,
      this.pHOTO5,
      this.sRDPRDP,
      this.conversionCharges,
      this.mVRATE2020,
      this.mVRATEDOCUMET,
      this.rC,
      this.vLT,
      this.pLOTOPENSPACE,
      this.tRC,
      this.aDDITIONALCONDITION,
      this.nOTES,
      this.cONDTION,
      this.rECOMMENDATIONS,
      this.iPAddress,
      this.userID,
      this.empID,
      this.tokenID,
      this.uNIREFID,
      this.sTATUSID,
      this.gISCORDINATE,
      this.gISCOUNT,
      this.cHECKLIST,
      this.isLayoutPlot,
      this.totalNoPlots,
      this.totalNoOfSoldPlots,
      this.totalNoOfUnSoldPlots,
      this.totalNoAreaExtent,
      this.unSoldPlotsList,
      this.isSaveType,
      this.updMVRate2020,
      this.updMvRateDoc,
      this.fifpFlag,
      this.updAreaExtent,
      this.updPlotAreaExtent,
      this.updRoadAreaExtent});

  FinalSubmitPayload.fromJson(Map<String, dynamic> json) {
    aPPLICATIONID = json['APPLICATION_ID'];
    lAYOUTNAME = json['LAYOUTNAME'];
    pLOTNO = json['PLOT_NO'];
    aREAEXTENT = json['AREA_EXTENT'];
    pLOTAREAEXTENT = json['PLOT_AREA_EXTENT'];
    rOADAREAEXTENT = json['ROAD_AREA_EXTENT'];
    mASTERPLANZDP = json['MASTERPLAN_ZDP'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    lAYOUTDOC = json['LAYOUT_DOC'];
    oWNERSHIPDOC = json['OWNERSHIP_DOC'];
    eCDOC = json['EC_DOC'];
    pHOTO1 = json['PHOTO1'];
    pHOTO2 = json['PHOTO2'];
    pHOTO3 = json['PHOTO3'];
    pHOTO4 = json['PHOTO4'];
    pHOTO5 = json['PHOTO5'];
    sRDPRDP = json['SRDP_RDP'];
    conversionCharges = json['ConversionCharges'];
    mVRATE2020 = json['MV_RATE_2020'];
    mVRATEDOCUMET = json['MV_RATE_DOCUMET'];
    rC = json['RC'];
    vLT = json['VLT'];
    pLOTOPENSPACE = json['PLOT_OPENSPACE'];
    tRC = json['TRC'];
    aDDITIONALCONDITION = json['ADDITIONAL_CONDITION'];
    nOTES = json['NOTES'];
    cONDTION = json['CONDTION'];
    rECOMMENDATIONS = json['RECOMMENDATIONS'];
    iPAddress = json['IPAddress'];
    userID = json['UserID'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    uNIREFID = json['UNIREFID'];
    sTATUSID = json['STATUS_ID'];
    gISCORDINATE = json['GIS_CORDINATE'];
    gISCOUNT = json['GIS_COUNT'];
    isLayoutPlot = json['IS_Layout_Plot'];
    totalNoPlots = json['Total_No_Plots'];
    totalNoOfSoldPlots = json['Total_No_Sold_Plots'];
    totalNoOfUnSoldPlots = json['Total_No_UnSold_Plots'];
    totalNoAreaExtent = json['Total_No_AreaExtent'];
    updMVRate2020 = json['UPD_MV_RATE_2020'];
    updMvRateDoc = json['UPD_MV_RATE_DOCUMET'];
    fifpFlag = json['FIFP_FLAG'];
    updAreaExtent = json['UPD_AREA_EXTENT'];
    updPlotAreaExtent = json['UPD_PLOT_AREA_EXTENT'];
    updRoadAreaExtent = json['UPD_ROAD_AREA_EXTENT'];
    isSaveType = json['IS_SAVE_TYPE'];
    if (json['CHECKLIST'] != null) {
      cHECKLIST = <CHECKLIST>[];
      json['CHECKLIST'].forEach((v) {
        cHECKLIST!.add(CHECKLIST.fromJson(v));
      });
    }
    if (json['listUnsoldPlots'] != null) {
      unSoldPlotsList = <UnSoldPlots>[];
      json['listUnsoldPlots'].forEach((v) {
        unSoldPlotsList!.add(UnSoldPlots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['APPLICATION_ID'] = aPPLICATIONID;
    data['LAYOUTNAME'] = lAYOUTNAME;
    data['PLOT_NO'] = pLOTNO;
    data['AREA_EXTENT'] = aREAEXTENT;
    data['PLOT_AREA_EXTENT'] = pLOTAREAEXTENT;
    data['ROAD_AREA_EXTENT'] = rOADAREAEXTENT;
    data['MASTERPLAN_ZDP'] = mASTERPLANZDP;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    data['LAYOUT_DOC'] = lAYOUTDOC;
    data['OWNERSHIP_DOC'] = oWNERSHIPDOC;
    data['EC_DOC'] = eCDOC;
    data['PHOTO1'] = pHOTO1;
    data['PHOTO2'] = pHOTO2;
    data['PHOTO3'] = pHOTO3;
    data['PHOTO4'] = pHOTO4;
    data['PHOTO5'] = pHOTO5;
    data['SRDP_RDP'] = sRDPRDP;
    data['ConversionCharges'] = conversionCharges;
    data['MV_RATE_2020'] = mVRATE2020;
    data['MV_RATE_DOCUMET'] = mVRATEDOCUMET;
    data['RC'] = rC;
    data['VLT'] = vLT;
    data['PLOT_OPENSPACE'] = pLOTOPENSPACE;
    data['TRC'] = tRC;
    data['ADDITIONAL_CONDITION'] = aDDITIONALCONDITION;
    data['NOTES'] = nOTES;
    data['CONDTION'] = cONDTION;
    data['RECOMMENDATIONS'] = rECOMMENDATIONS;
    data['IPAddress'] = iPAddress;
    data['UserID'] = userID;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['UNIREFID'] = uNIREFID;
    data['STATUS_ID'] = sTATUSID;
    data['GIS_CORDINATE'] = gISCORDINATE;
    data['GIS_COUNT'] = gISCOUNT;
    data['IS_Layout_Plot'] = isLayoutPlot;
    data['Total_No_Plots'] = totalNoPlots;
    data['Total_No_Sold_Plots'] = totalNoOfSoldPlots;
    data['Total_No_UnSold_Plots'] = totalNoOfUnSoldPlots;
    data['Total_No_AreaExtent'] = totalNoAreaExtent;
    data['UPD_MV_RATE_2020'] = updMVRate2020;
    data['UPD_MV_RATE_DOCUMET'] = updMvRateDoc;
    data['IS_SAVE_TYPE'] = isSaveType;
    data['FIFP_FLAG'] = fifpFlag;
    data['UPD_AREA_EXTENT'] = updAreaExtent;
    data['UPD_PLOT_AREA_EXTENT'] = updPlotAreaExtent;
    data['UPD_ROAD_AREA_EXTENT'] = updRoadAreaExtent;
    if (cHECKLIST != null) {
      data['CHECKLIST'] = cHECKLIST!.map((v) => v.toJson()).toList();
    }
    if (unSoldPlotsList != null) {
      data['listUnsoldPlots'] =
          unSoldPlotsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CHECKLIST {
  String? cHECKLISTID;
  String? sTATUSID;
  String? docment;
  String? checkDRopDown;
  String? remarks;

  CHECKLIST(
      {this.cHECKLISTID,
      this.sTATUSID,
      this.docment,
      this.checkDRopDown,
      this.remarks});

  CHECKLIST.fromJson(Map<String, dynamic> json) {
    cHECKLISTID = json['CHECKLIST_ID'];
    sTATUSID = json['STATUS_ID'];
    docment = json['Docment'] ?? json['CHECK_DOC'];
    checkDRopDown = json['CheckDRopDown'] ?? json['SUB_CHECK_ID'];
    remarks = json['Remarks'] ?? json['REMARKS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CHECKLIST_ID'] = cHECKLISTID;
    data['STATUS_ID'] = sTATUSID;
    data['Docment'] = docment;
    data['CheckDRopDown'] = checkDRopDown;
    data['Remarks'] = remarks;
    return data;
  }
}

class UnSoldPlots {
  String? plotNo;
  String? plotAreaExtent;

  UnSoldPlots({this.plotNo, this.plotAreaExtent});

  UnSoldPlots.fromJson(Map<String, dynamic> json) {
    plotNo = json['Plot_No'];
    plotAreaExtent = json['Plot_AreaExtent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Plot_No'] = plotNo;
    data['Plot_AreaExtent'] = plotAreaExtent;
    return data;
  }
}
