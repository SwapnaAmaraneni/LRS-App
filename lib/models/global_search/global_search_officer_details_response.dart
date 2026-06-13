class GlobalSearchOfficerDetailsResponse {
  int? statusCode;
  String? statusMsg;
  List<OfficersList>? officersList;

  GlobalSearchOfficerDetailsResponse(
      {this.statusCode, this.statusMsg, this.officersList});

  GlobalSearchOfficerDetailsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['officers_List'] != null) {
      officersList = <OfficersList>[];
      json['officers_List'].forEach((v) {
        officersList!.add(OfficersList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (officersList != null) {
      data['officers_List'] = officersList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfficersList {
  String? uSERID;
  String? uSERNAME;
  String? mOBILENUMBER;
  String? aUTHTYPE;

  OfficersList({this.uSERID, this.uSERNAME, this.mOBILENUMBER, this.aUTHTYPE});

  OfficersList.fromJson(Map<String, dynamic> json) {
    uSERID = json['USER_ID'];
    uSERNAME = json['USER_NAME'];
    mOBILENUMBER = json['MOBILE_NUMBER'];
    aUTHTYPE = json['AUTH_TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USER_ID'] = uSERID;
    data['USER_NAME'] = uSERNAME;
    data['MOBILE_NUMBER'] = mOBILENUMBER;
    data['AUTH_TYPE'] = aUTHTYPE;
    return data;
  }
}
