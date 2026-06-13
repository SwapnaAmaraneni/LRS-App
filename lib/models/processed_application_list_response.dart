class ProcessedApplicationListResponse {
  int? statusCode;
  String? statusMsg;
  List<Proceesed>? proceesed;

  ProcessedApplicationListResponse(
      {this.statusCode, this.statusMsg, this.proceesed});

  ProcessedApplicationListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['Proceesed'] != null) {
      proceesed = <Proceesed>[];
      json['Proceesed'].forEach((v) {
        proceesed!.add(Proceesed.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (proceesed != null) {
      data['Proceesed'] = proceesed!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Proceesed {
  String? aPPLICATIONID;
  String? pROCESSED;
  String? iSLAYOUTPLOT;

  Proceesed({this.aPPLICATIONID, this.pROCESSED, this.iSLAYOUTPLOT});

  Proceesed.fromJson(Map<String, dynamic> json) {
    aPPLICATIONID = json['APPLICATION_ID'];
    pROCESSED = json['PROCESSED'];
    iSLAYOUTPLOT = json['IS_LAYOUT_PLOT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['APPLICATION_ID'] = aPPLICATIONID;
    data['PROCESSED'] = pROCESSED;
    data['IS_LAYOUT_PLOT'] = iSLAYOUTPLOT;
    return data;
  }
}
