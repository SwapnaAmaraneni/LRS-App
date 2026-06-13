class ListofClusterCountResponse {
  int? statusCode;
  String? statusMsg;
  List<ClusterCountApplications>? clusterCountApplications;

  ListofClusterCountResponse(
      {this.statusCode, this.statusMsg, this.clusterCountApplications});

  ListofClusterCountResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['applications'] != null) {
      clusterCountApplications = <ClusterCountApplications>[];
      json['applications'].forEach((v) {
        clusterCountApplications!.add(ClusterCountApplications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (clusterCountApplications != null) {
      data['applications'] =
          clusterCountApplications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClusterCountApplications {
  String? vILLAGEID;
  String? cLUSTERID;
  String? aPPLICATIONID;
  String? vILLAGENAME;
  String? sURVEYNUMBER;
  String? aPPCOUNT;
  String? pLOTEXTENT;

  ClusterCountApplications({
    this.vILLAGEID,
    this.cLUSTERID,
    this.aPPLICATIONID,
    this.vILLAGENAME,
    this.sURVEYNUMBER,
    this.aPPCOUNT,
    this.pLOTEXTENT,
  });

  ClusterCountApplications.fromJson(Map<String, dynamic> json) {
    vILLAGEID = json['VILLAGE_ID'];
    cLUSTERID = json['CLUSTER_ID'];
    aPPLICATIONID = json['APPLICATION_ID'];
    vILLAGENAME = json['VILLAGE_NAME'];
    sURVEYNUMBER = json['SURVEY_NUMBER'];
    aPPCOUNT = json['APPCOUNT'];
    pLOTEXTENT = json['PLOT_EXTENT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VILLAGE_ID'] = vILLAGEID;
    data['CLUSTER_ID'] = cLUSTERID;
    data['APPLICATION_ID'] = aPPLICATIONID;
    data['VILLAGE_NAME'] = vILLAGENAME;
    data['SURVEY_NUMBER'] = sURVEYNUMBER;
    data['APPCOUNT'] = aPPCOUNT;
    data['PLOT_EXTENT'] = pLOTEXTENT;
    return data;
  }
}
