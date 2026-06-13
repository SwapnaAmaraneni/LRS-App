class OfficerLoginPayload {
  String? username;

  OfficerLoginPayload({this.username});

  OfficerLoginPayload.fromJson(Map<String, dynamic> json) {
    username = json['Username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Username'] = username;
    return data;
  }
}
