class CertifiedCopyResponse {
  int? responseCode;
  String? responseMsg;
  Result? result;

  CertifiedCopyResponse({this.responseCode, this.responseMsg, this.result});

  CertifiedCopyResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseMsg = json['response_msg'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['response_msg'] = responseMsg;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  int? srCode;
  int? rdoctNo;
  int? ryear;
  int? bookNo;
  String? fileExt;
  String? document;

  Result(
      {this.srCode,
      this.rdoctNo,
      this.ryear,
      this.bookNo,
      this.fileExt,
      this.document});

  Result.fromJson(Map<String, dynamic> json) {
    srCode = json['sr_code'];
    rdoctNo = json['rdoct_no'];
    ryear = json['ryear'];
    bookNo = json['book_no'];
    fileExt = json['file_ext'];
    document = json['document'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sr_code'] = srCode;
    data['rdoct_no'] = rdoctNo;
    data['ryear'] = ryear;
    data['book_no'] = bookNo;
    data['file_ext'] = fileExt;
    data['document'] = document;
    return data;
  }
}
