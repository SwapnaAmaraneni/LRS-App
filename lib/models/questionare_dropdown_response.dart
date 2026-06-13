class QuestionareDropdownResponse {
  int? statusCode;
  String? statusMsg;
  List<QuesDROPDOWNs>? dROPDOWNs;

  QuestionareDropdownResponse(
      {this.statusCode, this.statusMsg, this.dROPDOWNs});

  QuestionareDropdownResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['DROPDOWNs'] != null) {
      dROPDOWNs = <QuesDROPDOWNs>[];
      json['DROPDOWNs'].forEach((v) {
        dROPDOWNs!.add(QuesDROPDOWNs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (dROPDOWNs != null) {
      data['DROPDOWNs'] = dROPDOWNs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuesDROPDOWNs {
  String? dDLID;
  String? dDLNAME;

  QuesDROPDOWNs({this.dDLID, this.dDLNAME});

  QuesDROPDOWNs.fromJson(Map<String, dynamic> json) {
    dDLID = json['DDL_ID'];
    dDLNAME = json['DDL_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DDL_ID'] = dDLID;
    data['DDL_NAME'] = dDLNAME;
    return data;
  }
}
