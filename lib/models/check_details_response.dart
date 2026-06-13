class CheckDetailsResponse {
  int? statusCode;
  String? statusMsg;
  List<ListMasterPlans>? listMasterPlans;

  CheckDetailsResponse({this.statusCode, this.statusMsg, this.listMasterPlans});

  CheckDetailsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['listMasterPlans'] != null) {
      listMasterPlans = <ListMasterPlans>[];
      json['listMasterPlans'].forEach((v) {
        listMasterPlans!.add(ListMasterPlans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (listMasterPlans != null) {
      data['listMasterPlans'] =
          listMasterPlans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListMasterPlans {
  String? sNO;
  String? pLOTQUESTIONARY;
  String? iSREMARKS;
  String? iSDROPDOWN;
  String? iSUPLOAD;

  ListMasterPlans(
      {this.sNO,
      this.pLOTQUESTIONARY,
      this.iSREMARKS,
      this.iSDROPDOWN,
      this.iSUPLOAD});

  ListMasterPlans.fromJson(Map<String, dynamic> json) {
    sNO = json['SNO'];
    pLOTQUESTIONARY = json['PLOT_QUESTIONARY'];
    iSREMARKS = json['IS_REMARKS'];
    iSDROPDOWN = json['IS_DROPDOWN'];
    iSUPLOAD = json['IS_UPLOAD'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SNO'] = sNO;
    data['PLOT_QUESTIONARY'] = pLOTQUESTIONARY;
    data['IS_REMARKS'] = iSREMARKS;
    data['IS_DROPDOWN'] = iSDROPDOWN;
    data['IS_UPLOAD'] = iSUPLOAD;
    return data;
  }
}
