
class GenerateMPINResponse {
  int? statusCode;
  String? statusMsg;

  GenerateMPINResponse({this.statusCode, this.statusMsg});

  GenerateMPINResponse.fromJson(Map<String, dynamic> json) {
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
