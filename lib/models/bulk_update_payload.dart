import 'package:lrsofficer/models/villagewise_cluster_inspection_submit/final_submit_payload.dart';

class BulkUpdatePayload {
  String? addNotes;
  String? approvalFlag;
  String? clusterId;
  String? conditions;
  String? createdBy;
  String? createdIp;
  String? designationCode;
  String? isActive;
  String? termConditions;
  String? updatedBy;
  String? updatedIp;
  String? username;
  String? userId;
  String? ip;
  List<CHECKLIST>? checklist;
  String? roadAreaExtent;
  String? empID;
  String? tokenID;
  String? iSLayoutPlot;

  BulkUpdatePayload(
      {this.addNotes,
      this.approvalFlag,
      this.clusterId,
      this.conditions,
      this.createdBy,
      this.createdIp,
      this.designationCode,
      this.isActive,
      this.termConditions,
      this.updatedBy,
      this.updatedIp,
      this.username,
      this.userId,
      this.ip,
      this.checklist,
      this.roadAreaExtent,
      this.empID,
      this.tokenID,
      this.iSLayoutPlot});

  BulkUpdatePayload.fromJson(Map<String, dynamic> json) {
    addNotes = json['AddNotes'];
    approvalFlag = json['ApprovalFlag'];
    clusterId = json['ClusterId'];
    conditions = json['Conditions'];
    createdBy = json['CreatedBy'];
    createdIp = json['CreatedIp'];
    designationCode = json['DesignationCode'];
    isActive = json['IsActive'];
    termConditions = json['TermConditions'];
    updatedBy = json['UpdatedBy'];
    updatedIp = json['UpdatedIp'];
    username = json['Username'];
    userId = json['UserId'];
    ip = json['Ip'];
    if (json['Checklist'] != null) {
      checklist = <CHECKLIST>[];
      json['Checklist'].forEach((v) {
        checklist!.add(CHECKLIST.fromJson(v));
      });
    }
    roadAreaExtent = json['RoadAreaExtent'];
    empID = json['EmpID'];
    tokenID = json['TokenID'];
    iSLayoutPlot = json['IS_Layout_Plot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AddNotes'] = addNotes;
    data['ApprovalFlag'] = approvalFlag;
    data['ClusterId'] = clusterId;
    data['Conditions'] = conditions;
    data['CreatedBy'] = createdBy;
    data['CreatedIp'] = createdIp;
    data['DesignationCode'] = designationCode;
    data['IsActive'] = isActive;
    data['TermConditions'] = termConditions;
    data['UpdatedBy'] = updatedBy;
    data['UpdatedIp'] = updatedIp;
    data['Username'] = username;
    data['UserId'] = userId;
    data['Ip'] = ip;
    if (checklist != null) {
      data['Checklist'] = checklist!.map((v) => v.toJson()).toList();
    }
    data['RoadAreaExtent'] = roadAreaExtent;
    data['EmpID'] = empID;
    data['TokenID'] = tokenID;
    data['IS_Layout_Plot'] = iSLayoutPlot;
    return data;
  }
}
