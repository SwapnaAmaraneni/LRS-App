class FinalSubmitResponse {
  int? statusCode;
  String? statusMsg;

  FinalSubmitResponse({this.statusCode, this.statusMsg});

  FinalSubmitResponse.fromJson(Map<String, dynamic> json) {
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
