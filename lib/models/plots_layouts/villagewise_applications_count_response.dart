class VillageWiseSurveyNumbersResponse {
  int? statusCode;
  String? statusMsg;
  List<VillageWiseSurveyNumbers>? applications;

  VillageWiseSurveyNumbersResponse(
      {this.statusCode, this.statusMsg, this.applications});

  VillageWiseSurveyNumbersResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['applications'] != null) {
      applications = <VillageWiseSurveyNumbers>[];
      json['applications'].forEach((v) {
        applications!.add(VillageWiseSurveyNumbers.fromJson(v));
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

class VillageWiseSurveyNumbers {
  String? vILLAGEID;
  String? vILLAGENAME;
  String? sURVEYNUMBER;
  String? aPPCOUNT;
  String? pLOTEXTENT;

  VillageWiseSurveyNumbers({
    this.vILLAGEID,
    this.vILLAGENAME,
    this.sURVEYNUMBER,
    this.aPPCOUNT,
    this.pLOTEXTENT,
  });

  VillageWiseSurveyNumbers.fromJson(Map<String, dynamic> json) {
    vILLAGEID = json['VILLAGE_ID'];
    vILLAGENAME = json['VILLAGE_NAME'];
    sURVEYNUMBER = json['SURVEY_NUMBER'];
    aPPCOUNT = json['APPCOUNT'];
    pLOTEXTENT = json['PLOT_EXTENT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VILLAGE_ID'] = vILLAGEID;
    data['VILLAGE_NAME'] = vILLAGENAME;
    data['SURVEY_NUMBER'] = sURVEYNUMBER;
    data['APPCOUNT'] = aPPCOUNT;
    data['PLOT_EXTENT'] = pLOTEXTENT;
    return data;
  }
}
