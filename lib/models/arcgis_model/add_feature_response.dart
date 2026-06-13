class AddFeatureResponse {
  List<AddResults>? addResults;

  AddFeatureResponse({this.addResults});

  AddFeatureResponse.fromJson(Map<String, dynamic> json) {
    if (json['addResults'] != null) {
      addResults = <AddResults>[];
      json['addResults'].forEach((v) {
        addResults!.add(AddResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (addResults != null) {
      data['addResults'] = addResults!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddResults {
  int? objectId;
  bool? success;

  AddResults({this.objectId, this.success});

  AddResults.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['success'] = success;
    return data;
  }
}
