class RecommendationDetailsResponse {
  int? statusCode;
  String? statusMsg;
  List<RecommendationsListMasterPlans>? listMasterPlans;

  RecommendationDetailsResponse(
      {this.statusCode, this.statusMsg, this.listMasterPlans});

  RecommendationDetailsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['listMasterPlans'] != null) {
      listMasterPlans = <RecommendationsListMasterPlans>[];
      json['listMasterPlans'].forEach((v) {
        listMasterPlans!.add(RecommendationsListMasterPlans.fromJson(v));
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

class RecommendationsListMasterPlans {
  String? recommendation;
  String? recommendationValue;

  RecommendationsListMasterPlans({this.recommendation, this.recommendationValue});

  RecommendationsListMasterPlans.fromJson(Map<String, dynamic> json) {
    recommendation = json['Recommendation'];
    recommendationValue = json['RecommendationValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Recommendation'] = recommendation;
    data['RecommendationValue'] = recommendationValue;
    return data;
  }
}
