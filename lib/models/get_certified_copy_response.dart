class GetCertifiedCopyResponse {
  int? responseCode;
  String? responseMsg;
  String? pdfBas64;
  String? pdfBytes;

  GetCertifiedCopyResponse(
      {this.responseCode, this.responseMsg, this.pdfBas64, this.pdfBytes});

  GetCertifiedCopyResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseMsg = json['response_msg'];
    pdfBas64 = json['pdf_bas64'];
    pdfBytes = json['pdf_bytes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['response_msg'] = responseMsg;
    data['pdf_bas64'] = pdfBas64;
    data['pdf_bytes'] = pdfBytes;
    return data;
  }
}
