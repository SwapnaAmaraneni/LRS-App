class PaymentDetailsResponse {
  int? statusCode;
  String? statusMsg;
  List<CalulationDetails>? calulationDetails;

  PaymentDetailsResponse(
      {this.statusCode, this.statusMsg, this.calulationDetails});

  PaymentDetailsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['calulationDetails'] != null) {
      calulationDetails = <CalulationDetails>[];
      json['calulationDetails'].forEach((v) {
        calulationDetails!.add(CalulationDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (calulationDetails != null) {
      data['calulationDetails'] =
          calulationDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CalulationDetails {
  int? statusCode;
  String? statusMsg;
  String? totalAmount;
  String? regCharges;
  String? vLTCharges;
  String? openSpaceCharges;
  String? intitalAmount;
  String? totalRegCharges;
  String? applicationID;
  String? cONVERSIONCHARGES;

  CalulationDetails(
      {this.statusCode,
      this.statusMsg,
      this.totalAmount,
      this.regCharges,
      this.vLTCharges,
      this.openSpaceCharges,
      this.intitalAmount,
      this.totalRegCharges,
      this.applicationID,
      this.cONVERSIONCHARGES});

  CalulationDetails.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    totalAmount = json['TotalAmount'];
    regCharges = json['Reg_Charges'];
    vLTCharges = json['VLT_Charges'];
    openSpaceCharges = json['OpenSpace_Charges'];
    intitalAmount = json['Intital_Amount'];
    totalRegCharges = json['Total_Reg_Charges'];
    applicationID = json['ApplicationID'];
    cONVERSIONCHARGES = json['CONVERSION_CHARGES'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    data['TotalAmount'] = totalAmount;
    data['Reg_Charges'] = regCharges;
    data['VLT_Charges'] = vLTCharges;
    data['OpenSpace_Charges'] = openSpaceCharges;
    data['Intital_Amount'] = intitalAmount;
    data['Total_Reg_Charges'] = totalRegCharges;
    data['ApplicationID'] = applicationID;
    data['CONVERSION_CHARGES'] = cONVERSIONCHARGES;
    return data;
  }
}
