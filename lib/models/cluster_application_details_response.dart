import 'package:lrsofficer/models/villagewise_cluster_inspection_submit/final_submit_payload.dart';

class ClusterApplicationDetailsResponse {
  int? statusCode;
  String? statusMsg;
  List<ClusterApplicationDetails>? clusterApplicationDetails;

  ClusterApplicationDetailsResponse(
      {this.statusCode, this.statusMsg, this.clusterApplicationDetails});

  ClusterApplicationDetailsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['applications'] != null) {
      clusterApplicationDetails = <ClusterApplicationDetails>[];
      json['applications'].forEach((v) {
        clusterApplicationDetails!.add(ClusterApplicationDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (clusterApplicationDetails != null) {
      data['applications'] =
          clusterApplicationDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClusterApplicationDetails {
  String? aPPLICATIONID;
  String? dISTRICTID;
  String? dISTRICTNAME;
  String? cATETORY;
  String? cORPMUNGPID;
  String? aUTHORITYNAME;
  String? lAYOUTOWNERNAME;
  String? lAYOUTNAME;
  String? oWNERMOBILENUMBER;
  String? pLOTLAYOUTUNDER;
  String? lAYOUTDOC;
  String? eCDOC;
  String? oWNERSHIPDOC;
  String? tOTALLAYOUTSQMTRS;
  String? tOTALNOOFPLOTS;
  String? nOOFPLOTSOLD;
  String? nOOFPLOTUNSOLD;
  String? lRSAMOUNT;
  String? pHOTO1;
  String? pHOTO2;
  String? pHOTO3;
  String? pHOTO4;
  String? pHOTO5;
  String? dOC1;
  String? dOC2;
  String? dOC3;
  String? iNITIALPAYMENTAMOUNT;
  String? iSLAYOUTPLOT;
  String? aREAEXTENT;
  String? pLOTAREAEXTENT;
  String? rOADAREAEXTENT;
  String? pLOTNO;
  String? mASTERPLANZDP;
  String? sLAYOUTDOC;
  String? sECDOC;
  String? sOWNERSHIPDOC;
  String? latitude;
  String? longitude;
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
  String? uNIREFID;
  String? strCHECKLIST;
  String? empID;
  String? sTATUSID;
  String? gISCORDINATE;
  String? gISCOUNT;
  String? tokenID;
  String? fATHERHUSBANDNAME;
  String? gENDER;
  String? hNODOORNO;
  String? sTREETCOLONY;
  String? lOCALITY;
  String? pINCODE;
  String? eMAILID;
  String? aLTERMOBILENO;
  String? vILLAGENAME;
  String? sROCODEFOURDIGITS;
  String? sALEDEEDNUMBER;
  String? sALEDEEDYEAR;
  String? aADHARNUMBER;
  String? sURVEYNUMBER;
  String? oWNERSHIPDOCUMENT;
  String? sALEDEEDEC;
  String? oTHERSDOC;
  String? cOPYOFLAYOUT;
  String? lAYOUTPLAN;
  String? aPPLICANTADDRESS;
  String? isLayoutPlot;
  String? totalNoPlots;
  String? totalNoOfSoldPlots;
  String? totalNoOfUnSoldPlots;
  String? totalNoAreaExtent;
  String? prohibitedDoc1;
  String? prohibitedDoc2;
  String? prohibitedDoc3;
  String? prohibitedDoc4;
  String? prohibitedDoc5;
  String? prohibitedDoc6;
  String? prohibittedAdditionalDoc1;
  String? prohibittedAdditionalDoc2;
  String? mvEditFlag;
  String? maxCoordinatesCount;
  String? minCoordinatesCount;
  String? sDocOthers;
  String? sroCodeEdit;
  String? l1Remarks;
  String? l2Remarks;
  String? l3Remarks;
  List<CHECKLIST>? checkList;
  List<OfficersComments>? officersComments;
  List<UnSoldPlots>? unSoldPlotsList;
  List<ListSaveData>? listSaveDatas;

  ClusterApplicationDetails({
    this.aPPLICATIONID,
    this.dISTRICTID,
    this.dISTRICTNAME,
    this.cATETORY,
    this.cORPMUNGPID,
    this.aUTHORITYNAME,
    this.lAYOUTOWNERNAME,
    this.lAYOUTNAME,
    this.oWNERMOBILENUMBER,
    this.pLOTLAYOUTUNDER,
    this.lAYOUTDOC,
    this.eCDOC,
    this.oWNERSHIPDOC,
    this.tOTALLAYOUTSQMTRS,
    this.tOTALNOOFPLOTS,
    this.nOOFPLOTSOLD,
    this.nOOFPLOTUNSOLD,
    this.lRSAMOUNT,
    this.pHOTO1,
    this.pHOTO2,
    this.pHOTO3,
    this.pHOTO4,
    this.pHOTO5,
    this.dOC1,
    this.dOC2,
    this.dOC3,
    this.iNITIALPAYMENTAMOUNT,
    this.iSLAYOUTPLOT,
    this.aREAEXTENT,
    this.pLOTAREAEXTENT,
    this.rOADAREAEXTENT,
    this.pLOTNO,
    this.mASTERPLANZDP,
    this.sLAYOUTDOC,
    this.sECDOC,
    this.sOWNERSHIPDOC,
    this.latitude,
    this.longitude,
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
    this.uNIREFID,
    this.strCHECKLIST,
    this.empID,
    this.sTATUSID,
    this.gISCORDINATE,
    this.gISCOUNT,
    this.tokenID,
    this.fATHERHUSBANDNAME,
    this.gENDER,
    this.hNODOORNO,
    this.sTREETCOLONY,
    this.lOCALITY,
    this.pINCODE,
    this.eMAILID,
    this.aLTERMOBILENO,
    this.vILLAGENAME,
    this.sROCODEFOURDIGITS,
    this.sALEDEEDNUMBER,
    this.sALEDEEDYEAR,
    this.aADHARNUMBER,
    this.sURVEYNUMBER,
    this.oWNERSHIPDOCUMENT,
    this.sALEDEEDEC,
    this.oTHERSDOC,
    this.cOPYOFLAYOUT,
    this.lAYOUTPLAN,
    this.aPPLICANTADDRESS,
    this.isLayoutPlot,
    this.totalNoPlots,
    this.totalNoOfSoldPlots,
    this.totalNoOfUnSoldPlots,
    this.totalNoAreaExtent,
    this.prohibitedDoc1,
    this.prohibitedDoc2,
    this.prohibitedDoc3,
    this.prohibitedDoc4,
    this.prohibitedDoc5,
    this.prohibitedDoc6,
    this.prohibittedAdditionalDoc1,
    this.prohibittedAdditionalDoc2,
    this.mvEditFlag,
    this.maxCoordinatesCount,
    this.minCoordinatesCount,
    this.sroCodeEdit,
    this.l1Remarks,
    this.l2Remarks,
    this.l3Remarks,
    this.checkList,
    this.unSoldPlotsList,
    this.officersComments,
    this.sDocOthers,
  });

  ClusterApplicationDetails.fromJson(Map<String, dynamic> json) {
    aPPLICATIONID = json['APPLICATION_ID'];
    dISTRICTID = json['DISTRICT_ID'];
    dISTRICTNAME = json['DISTRICT_NAME'];
    cATETORY = json['CATETORY'];
    cORPMUNGPID = json['CORP_MUN_GP_ID'];
    aUTHORITYNAME = json['AUTHORITYNAME'];
    lAYOUTOWNERNAME = json['LAYOUTOWNERNAME'];
    lAYOUTNAME = json['LAYOUTNAME'];
    oWNERMOBILENUMBER = json['OWNERMOBILENUMBER'];
    pLOTLAYOUTUNDER = json['PLOT_LAYOUT_UNDER'];
    lAYOUTDOC = json['LAYOUT_DOC'];
    eCDOC = json['EC_DOC'];
    oWNERSHIPDOC = json['OWNERSHIP_DOC'];
    tOTALLAYOUTSQMTRS = json['TOTAL_LAYOUT_SQMTRS'];
    tOTALNOOFPLOTS = json['TOTALNOOFPLOTS'];
    nOOFPLOTSOLD = json['NOOFPLOTSOLD'];
    nOOFPLOTUNSOLD = json['NOOFPLOTUNSOLD'];
    lRSAMOUNT = json['LRS_AMOUNT'];
    pHOTO1 = json['PHOTO1'];
    pHOTO2 = json['PHOTO2'];
    pHOTO3 = json['PHOTO3'];
    pHOTO4 = json['PHOTO4'];
    pHOTO5 = json['PHOTO5'];
    dOC1 = json['DOC1'];
    dOC2 = json['DOC2'];
    dOC3 = json['DOC3'];
    iNITIALPAYMENTAMOUNT = json['INITIAL_PAYMENT_AMOUNT'];
    iSLAYOUTPLOT = json['IS_LAYOUT_PLOT'];
    aREAEXTENT = json['AREA_EXTENT'];
    pLOTAREAEXTENT = json['PLOT_AREA_EXTENT'];
    rOADAREAEXTENT = json['ROAD_AREA_EXTENT'];
    pLOTNO = json['PLOT_NO'];
    mASTERPLANZDP = json['MASTERPLAN_ZDP'];
    sLAYOUTDOC = json['S_LAYOUT_DOC'];
    sECDOC = json['S_EC_DOC'];
    sOWNERSHIPDOC = json['S_OWNERSHIP_DOC'];
    sDocOthers = json['S_DOC_OTHERS'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
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
    uNIREFID = json['UNIREFID'];
    strCHECKLIST = json['strCHECKLIST'];
    empID = json['EmpID'];
    sTATUSID = json['STATUS_ID'];
    gISCORDINATE = json['GIS_CORDINATE'];
    gISCOUNT = json['GIS_COUNT'];
    tokenID = json['TokenID'];
    fATHERHUSBANDNAME = json['FATHER_HUSBAND_NAME'];
    gENDER = json['GENDER'];
    hNODOORNO = json['HNO_DOORNO'];
    sTREETCOLONY = json['STREET_COLONY'];
    lOCALITY = json['LOCALITY'];
    pINCODE = json['PINCODE'];
    eMAILID = json['EMAIL_ID'];
    aLTERMOBILENO = json['ALTER_MOBILE_NO'];
    vILLAGENAME = json['VILLAGE_NAME'];
    sROCODEFOURDIGITS = json['SRO_CODE_FOUR_DIGITS'];
    sALEDEEDNUMBER = json['SALE_DEED_NUMBER'];
    sALEDEEDYEAR = json['SALEDEED_YEAR'];
    aADHARNUMBER = json['AADHAR_NUMBER'];
    sURVEYNUMBER = json['SURVEY_NUMBER'];
    oWNERSHIPDOCUMENT = json['OWNERSHIP_DOCUMENT'];
    sALEDEEDEC = json['SALE_DEED_EC'];
    oTHERSDOC = json['OTHERS_DOC'];
    cOPYOFLAYOUT = json['COPY_OF_LAYOUT'];
    lAYOUTPLAN = json['LAYOUT_PLAN'];
    aPPLICANTADDRESS = json['APPLICANT_ADDRESS'];
    isLayoutPlot = json['IS_Layout_Plot'];
    totalNoPlots = json['Total_No_Plots'];
    totalNoOfSoldPlots = json['Total_No_Sold_Plots'];
    totalNoOfUnSoldPlots = json['Total_No_UnSold_Plots'];
    totalNoAreaExtent = json['Total_No_AreaExtent'];
    prohibitedDoc1 = json['PROHIBITED_DOC1'];
    prohibitedDoc2 = json['PROHIBITED_DOC2'];
    prohibitedDoc3 = json['PROHIBITED_DOC3'];
    prohibitedDoc4 = json['PROHIBITED_DOC4'];
    prohibitedDoc5 = json['PROHIBITED_DOC5'];
    prohibitedDoc6 = json['PROHIBITED_DOC6'];
    prohibittedAdditionalDoc1 = json['PROHIBITED_ADDITIONAL_DOC1'];
    prohibittedAdditionalDoc2 = json['PROHIBITED_ADDITIONAL_DOC2'];
    mvEditFlag = json['mv_editFlag'];
    maxCoordinatesCount = json['max_coordinatesCount'];
    minCoordinatesCount = json['min_coordinatesCount'];
    sroCodeEdit = json['SROCODEEDIT'];
    l1Remarks = json['L1_REMARKS'];
    l2Remarks = json['L2_REMARKS'];
    l3Remarks = json['L3_REMARKS'];
    if (json['CHECKLIST'] != null) {
      checkList = <CHECKLIST>[];
      json['CHECKLIST'].forEach((v) {
        checkList!.add(CHECKLIST.fromJson(v));
      });
    }
    if (json['listUnsoldPlots'] != null) {
      unSoldPlotsList = <UnSoldPlots>[];
      json['listUnsoldPlots'].forEach((v) {
        unSoldPlotsList!.add(UnSoldPlots.fromJson(v));
      });
    }
    if (json['OfficersComments'] != null) {
      officersComments = <OfficersComments>[];
      json['OfficersComments'].forEach((v) {
        officersComments!.add(OfficersComments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['APPLICATION_ID'] = aPPLICATIONID;
    data['DISTRICT_ID'] = dISTRICTID;
    data['DISTRICT_NAME'] = dISTRICTNAME;
    data['CATETORY'] = cATETORY;
    data['CORP_MUN_GP_ID'] = cORPMUNGPID;
    data['AUTHORITYNAME'] = aUTHORITYNAME;
    data['LAYOUTOWNERNAME'] = lAYOUTOWNERNAME;
    data['LAYOUTNAME'] = lAYOUTNAME;
    data['OWNERMOBILENUMBER'] = oWNERMOBILENUMBER;
    data['PLOT_LAYOUT_UNDER'] = pLOTLAYOUTUNDER;
    data['LAYOUT_DOC'] = lAYOUTDOC;
    data['EC_DOC'] = eCDOC;
    data['OWNERSHIP_DOC'] = oWNERSHIPDOC;
    data['TOTAL_LAYOUT_SQMTRS'] = tOTALLAYOUTSQMTRS;
    data['TOTALNOOFPLOTS'] = tOTALNOOFPLOTS;
    data['NOOFPLOTSOLD'] = nOOFPLOTSOLD;
    data['NOOFPLOTUNSOLD'] = nOOFPLOTUNSOLD;
    data['LRS_AMOUNT'] = lRSAMOUNT;
    data['PHOTO1'] = pHOTO1;
    data['PHOTO2'] = pHOTO2;
    data['PHOTO3'] = pHOTO3;
    data['PHOTO4'] = pHOTO4;
    data['PHOTO5'] = pHOTO5;
    data['DOC1'] = dOC1;
    data['DOC2'] = dOC2;
    data['DOC3'] = dOC3;
    data['INITIAL_PAYMENT_AMOUNT'] = iNITIALPAYMENTAMOUNT;
    data['IS_LAYOUT_PLOT'] = iSLAYOUTPLOT;
    data['AREA_EXTENT'] = aREAEXTENT;
    data['PLOT_AREA_EXTENT'] = pLOTAREAEXTENT;
    data['ROAD_AREA_EXTENT'] = rOADAREAEXTENT;
    data['PLOT_NO'] = pLOTNO;
    data['MASTERPLAN_ZDP'] = mASTERPLANZDP;
    data['S_LAYOUT_DOC'] = sLAYOUTDOC;
    data['S_EC_DOC'] = sECDOC;
    data['S_OWNERSHIP_DOC'] = sOWNERSHIPDOC;
    data['S_DOC_OTHERS'] = sDocOthers;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
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
    data['UNIREFID'] = uNIREFID;
    data['strCHECKLIST'] = strCHECKLIST;
    data['EmpID'] = empID;
    data['STATUS_ID'] = sTATUSID;
    data['GIS_CORDINATE'] = gISCORDINATE;
    data['GIS_COUNT'] = gISCOUNT;
    data['TokenID'] = tokenID;
    data['FATHER_HUSBAND_NAME'] = fATHERHUSBANDNAME;
    data['GENDER'] = gENDER;
    data['HNO_DOORNO'] = hNODOORNO;
    data['STREET_COLONY'] = sTREETCOLONY;
    data['LOCALITY'] = lOCALITY;
    data['PINCODE'] = pINCODE;
    data['EMAIL_ID'] = eMAILID;
    data['ALTER_MOBILE_NO'] = aLTERMOBILENO;
    data['VILLAGE_NAME'] = vILLAGENAME;
    data['SRO_CODE_FOUR_DIGITS'] = sROCODEFOURDIGITS;
    data['SALE_DEED_NUMBER'] = sALEDEEDNUMBER;
    data['SALEDEED_YEAR'] = sALEDEEDYEAR;
    data['AADHAR_NUMBER'] = aADHARNUMBER;
    data['SURVEY_NUMBER'] = sURVEYNUMBER;
    data['OWNERSHIP_DOCUMENT'] = oWNERSHIPDOCUMENT;
    data['SALE_DEED_EC'] = sALEDEEDEC;
    data['OTHERS_DOC'] = oTHERSDOC;
    data['COPY_OF_LAYOUT'] = cOPYOFLAYOUT;
    data['LAYOUT_PLAN'] = lAYOUTPLAN;
    data['APPLICANT_ADDRESS'] = aPPLICANTADDRESS;
    data['IS_Layout_Plot'] = isLayoutPlot;
    data['Total_No_Plots'] = totalNoPlots;
    data['Total_No_Sold_Plots'] = totalNoOfSoldPlots;
    data['Total_No_UnSold_Plots'] = totalNoOfUnSoldPlots;
    data['Total_No_AreaExtent'] = totalNoAreaExtent;
    data['PROHIBITED_DOC1'] = prohibitedDoc1;
    data['PROHIBITED_DOC2'] = prohibitedDoc2;
    data['PROHIBITED_DOC3'] = prohibitedDoc3;
    data['PROHIBITED_DOC4'] = prohibitedDoc4;
    data['PROHIBITED_DOC5'] = prohibitedDoc5;
    data['PROHIBITED_DOC6'] = prohibitedDoc6;
    data['PROHIBITED_ADDITIONAL_DOC1'] = prohibittedAdditionalDoc1;
    data['PROHIBITED_ADDITIONAL_DOC2'] = prohibittedAdditionalDoc2;
    data['mv_editFlag'] = mvEditFlag;
    data['max_coordinatesCount'] = maxCoordinatesCount;
    data['min_coordinatesCount'] = minCoordinatesCount;
    data['SROCODEEDIT'] = sroCodeEdit;
    data['L1_REMARKS'] = l1Remarks;
    data['L2_REMARKS'] = l2Remarks;
    data['L3_REMARKS'] = l3Remarks;
    if (checkList != null) {
      data['CHECKLIST'] = checkList!.map((v) => v.toJson()).toList();
    }
    if (unSoldPlotsList != null) {
      data['listUnsoldPlots'] =
          unSoldPlotsList!.map((v) => v.toJson()).toList();
    }
    if (officersComments != null) {
      data['OfficersComments'] =
          officersComments!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class OfficersComments {
  String? cREATEDBY;
  String? aDDNOTES;
  String? aPPROVALFLAG;

  OfficersComments({this.cREATEDBY, this.aDDNOTES, this.aPPROVALFLAG});

  OfficersComments.fromJson(Map<String, dynamic> json) {
    cREATEDBY = json['CREATED_BY'];
    aDDNOTES = json['ADD_NOTES'];
    aPPROVALFLAG = json['APPROVAL_FLAG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CREATED_BY'] = cREATEDBY;
    data['ADD_NOTES'] = aDDNOTES;
    data['APPROVAL_FLAG'] = aPPROVALFLAG;
    return data;
  }
}

class ListSaveData {
  String? cHECKLISTID;
  String? cREATEDON;
  String? sTATUSID;
  String? aPPLICATIONID;
  String? sUBCHECKID;
  String? cHECKDOC;
  String? rEMARKS;

  ListSaveData(
      {this.cHECKLISTID,
      this.cREATEDON,
      this.sTATUSID,
      this.aPPLICATIONID,
      this.sUBCHECKID,
      this.cHECKDOC,
      this.rEMARKS});

  ListSaveData.fromJson(Map<String, dynamic> json) {
    cHECKLISTID = json['CHECKLIST_ID'];
    cREATEDON = json['CREATEDON'];
    sTATUSID = json['STATUS_ID'];
    aPPLICATIONID = json['APPLICATION_ID'];
    sUBCHECKID = json['SUB_CHECK_ID'] ?? json['CheckDRopDown'];
    cHECKDOC = json['CHECK_DOC'] ?? json['Docment'];
    rEMARKS = json['REMARKS'] ?? json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CHECKLIST_ID'] = cHECKLISTID;
    data['CREATEDON'] = cREATEDON;
    data['STATUS_ID'] = sTATUSID;
    data['APPLICATION_ID'] = aPPLICATIONID;
    data['SUB_CHECK_ID'] = sUBCHECKID;
    data['CHECK_DOC'] = cHECKDOC;
    data['REMARKS'] = rEMARKS;
    return data;
  }
}
