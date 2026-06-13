class SubmitFeeIntimatedRemarksResponse {
  int? statusCode;
  String? statusMsg;

  SubmitFeeIntimatedRemarksResponse({this.statusCode, this.statusMsg});

  SubmitFeeIntimatedRemarksResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    return data;
  }
}
