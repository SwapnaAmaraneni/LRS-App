class ViewGISCoOrdinatesResponse {
  int? statusCode;
  String? statusMsg;
  String? gISLocationCoordinates;

  ViewGISCoOrdinatesResponse(
      {this.statusCode, this.statusMsg, this.gISLocationCoordinates});

  ViewGISCoOrdinatesResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    gISLocationCoordinates = json['GISLocation_Coordinates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    data['GISLocation_Coordinates'] = gISLocationCoordinates;
    return data;
  }
}
