class ListOfMasterPlanZDPResponse {
  int? statusCode;
  String? statusMsg;
  List<ListMasterPlansZDP>? listMasterPlansZDP;

  ListOfMasterPlanZDPResponse(
      {this.statusCode, this.statusMsg, this.listMasterPlansZDP});

  ListOfMasterPlanZDPResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['listMasterPlans'] != null) {
      listMasterPlansZDP = <ListMasterPlansZDP>[];
      json['listMasterPlans'].forEach((v) {
        listMasterPlansZDP!.add(ListMasterPlansZDP.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (listMasterPlansZDP != null) {
      data['listMasterPlans'] =
          listMasterPlansZDP!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListMasterPlansZDP {
  String? landUseId;
  String? landUseName;

  ListMasterPlansZDP({this.landUseId, this.landUseName});

  ListMasterPlansZDP.fromJson(Map<String, dynamic> json) {
    landUseId = json['land_use_id'];
    landUseName = json['land_use_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['land_use_id'] = landUseId;
    data['land_use_name'] = landUseName;
    return data;
  }
}
