class FeeStatusReportResponse {
  int? feeIntimated;
  int? feePaid;
  int? statusCode;
  String? statusMsg;

  FeeStatusReportResponse(
      {this.feeIntimated, this.feePaid, this.statusCode, this.statusMsg});

  FeeStatusReportResponse.fromJson(Map<String, dynamic> json) {
    feeIntimated = json['FeeIntimated'];
    feePaid = json['FeePaid'];
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FeeIntimated'] = feeIntimated;
    data['FeePaid'] = feePaid;
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    return data;
  }
}
