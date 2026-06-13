class DashboardResponse {
  int? statusCode;
  String? statusMsg;
  List<DashboardData>? dashboardData;
  List<DashboardData>? newDashboardData;

  DashboardResponse({this.statusCode, this.statusMsg, this.dashboardData});

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['Dynamic'] != null) {
      dashboardData = <DashboardData>[];
      json['Dynamic'].forEach((v) {
        dashboardData!.add(DashboardData.fromJson(v));
      });
    }
    if (json['Dynamic_New'] != null) {
      newDashboardData = <DashboardData>[];
      json['Dynamic_New'].forEach((v) {
        newDashboardData!.add(DashboardData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (dashboardData != null) {
      data['Dynamic'] = dashboardData!.map((v) => v.toJson()).toList();
    }
    if (dashboardData != null) {
      data['Dynamic_New'] = newDashboardData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DashboardData {
  String? iD;
  String? wEBLINK;
  String? wEBLINKFLAG;
  String? dISPLAYFLAG;
  String? dISPLAYORDER;
  String? iMAGEPATH;
  String? mENUNAME;

  DashboardData(
      {this.iD,
      this.wEBLINK,
      this.wEBLINKFLAG,
      this.dISPLAYFLAG,
      this.dISPLAYORDER,
      this.iMAGEPATH,
      this.mENUNAME});

  DashboardData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    wEBLINK = json['WEBLINK'];
    wEBLINKFLAG = json['WEBLINKFLAG'];
    dISPLAYFLAG = json['DISPLAYFLAG'];
    dISPLAYORDER = json['DISPLAYORDER'];
    iMAGEPATH = json['IMAGEPATH'];
    mENUNAME = json['MENUNAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['WEBLINK'] = wEBLINK;
    data['WEBLINKFLAG'] = wEBLINKFLAG;
    data['DISPLAYFLAG'] = dISPLAYFLAG;
    data['DISPLAYORDER'] = dISPLAYORDER;
    data['IMAGEPATH'] = iMAGEPATH;
    data['MENUNAME'] = mENUNAME;
    return data;
  }
}
