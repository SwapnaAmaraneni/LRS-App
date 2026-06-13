class GlobalSearchResponse {
  int? statusCode;
  String? statusMsg;
  List<GlobalSearchList>? globalSearchList;

  GlobalSearchResponse(
      {this.statusCode, this.statusMsg, this.globalSearchList});

  GlobalSearchResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['globalSearch_List'] != null) {
      globalSearchList = <GlobalSearchList>[];
      json['globalSearch_List'].forEach((v) {
        globalSearchList!.add(GlobalSearchList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (globalSearchList != null) {
      data['globalSearch_List'] =
          globalSearchList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GlobalSearchList {
  String? applicationId;
  String? layoutownername;
  String? fatherHusbandName;
  String? ownermobilenumber;
  String? surveyNumber;
  String? plotNo;
  String? isLayoutPlot;
  String? statusId;
  String? sTATUS;
  String? fEESTATUS;

  GlobalSearchList(
      {this.applicationId,
      this.layoutownername,
      this.fatherHusbandName,
      this.ownermobilenumber,
      this.surveyNumber,
      this.plotNo,
      this.isLayoutPlot,
      this.statusId,
      this.sTATUS,
      this.fEESTATUS});

  GlobalSearchList.fromJson(Map<String, dynamic> json) {
    applicationId = json['application_id'];
    layoutownername = json['layoutownername'];
    fatherHusbandName = json['father_husband_name'];
    ownermobilenumber = json['ownermobilenumber'];
    surveyNumber = json['survey_number'];
    plotNo = json['plot_no'];
    isLayoutPlot = json['is_layout_plot'];
    statusId = json['status_id'];
    sTATUS = json['STATUS'];
    fEESTATUS = json['FEESTATUS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['application_id'] = applicationId;
    data['layoutownername'] = layoutownername;
    data['father_husband_name'] = fatherHusbandName;
    data['ownermobilenumber'] = ownermobilenumber;
    data['survey_number'] = surveyNumber;
    data['plot_no'] = plotNo;
    data['is_layout_plot'] = isLayoutPlot;
    data['status_id'] = statusId;
    data['STATUS'] = sTATUS;
    data['FEESTATUS'] = fEESTATUS;
    return data;
  }
}
