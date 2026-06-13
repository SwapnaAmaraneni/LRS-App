class CertifiedCopyPayload {
  String? bookNo;
  String? rdoctNo;
  String? ryear;
  String? srCode;


  CertifiedCopyPayload(
      {this.bookNo, this.rdoctNo, this.ryear, this.srCode});

  CertifiedCopyPayload.fromJson(Map<String, dynamic> json) {
    bookNo = json['book_no'];
    rdoctNo = json['rdoct_no'];
    ryear = json['ryear'];
    srCode = json['sr_code'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['book_no'] = bookNo;
    data['rdoct_no'] = rdoctNo;
    data['ryear'] = ryear;
    data['sr_code'] = srCode;
 
    return data;
  }
}
