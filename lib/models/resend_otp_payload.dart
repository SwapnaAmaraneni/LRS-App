class ResendOTPPayload {
  String? mobileNo;
 
  ResendOTPPayload({this.mobileNo,});

  ResendOTPPayload.fromJson(Map<String, dynamic> json) {
    mobileNo = json['MobileNumber'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MobileNumber'] = mobileNo;
  
    return data;
  }
}
