class ResendOTPResponse {
  int? statusCode;
  String? statusMsg;
  String? oTP;

  ResendOTPResponse({this.statusCode, this.statusMsg, this.oTP});

  ResendOTPResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    oTP = json['OTP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    data['OTP'] = oTP;
    return data;
  }
}
