class GetGlobalSearchMastersResponse {
  int? statusCode;
  String? statusMsg;
  List<Districts>? districts;
  List<Mandals>? mandals;
  List<Villages>? villages;

  GetGlobalSearchMastersResponse(
      {this.statusCode,
      this.statusMsg,
      this.districts,
      this.mandals,
      this.villages});

  GetGlobalSearchMastersResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['Districts'] != null) {
      districts = <Districts>[];
      json['Districts'].forEach((v) {
        districts!.add(Districts.fromJson(v));
      });
    }
    if (json['Mandals'] != null) {
      mandals = <Mandals>[];
      json['Mandals'].forEach((v) {
        mandals!.add(Mandals.fromJson(v));
      });
    }
    if (json['Villages'] != null) {
      villages = <Villages>[];
      json['Villages'].forEach((v) {
        villages!.add(Villages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (districts != null) {
      data['Districts'] = districts!.map((v) => v.toJson()).toList();
    }
    if (mandals != null) {
      data['Mandals'] = mandals!.map((v) => v.toJson()).toList();
    }
    if (villages != null) {
      data['Villages'] = villages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Districts {
  int? dISTRICTID;
  String? dISTRICTNAME;

  Districts({this.dISTRICTID, this.dISTRICTNAME});

  Districts.fromJson(Map<String, dynamic> json) {
    dISTRICTID = json['DISTRICT_ID'];
    dISTRICTNAME = json['DISTRICT_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DISTRICT_ID'] = dISTRICTID;
    data['DISTRICT_NAME'] = dISTRICTNAME;
    return data;
  }
}

class Mandals {
  int? dISTRICTID;
  int? mANDALID;
  String? mANDALNAME;

  Mandals({this.dISTRICTID, this.mANDALID, this.mANDALNAME});

  Mandals.fromJson(Map<String, dynamic> json) {
    dISTRICTID = json['DISTRICT_ID'];
    mANDALID = json['MANDAL_ID'];
    mANDALNAME = json['MANDAL_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DISTRICT_ID'] = dISTRICTID;
    data['MANDAL_ID'] = mANDALID;
    data['MANDAL_NAME'] = mANDALNAME;
    return data;
  }
}

class Villages {
  int? dISTRICTID;
  int? mANDALID;
  int? vILLAGEID;
  String? vILLAGENAME;

  Villages({this.dISTRICTID, this.mANDALID, this.vILLAGEID, this.vILLAGENAME});

  Villages.fromJson(Map<String, dynamic> json) {
    dISTRICTID = json['DISTRICT_ID'];
    mANDALID = json['MANDAL_ID'];
    vILLAGEID = json['VILLAGE_ID'];
    vILLAGENAME = json['VILLAGE_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DISTRICT_ID'] = dISTRICTID;
    data['MANDAL_ID'] = mANDALID;
    data['VILLAGE_ID'] = vILLAGEID;
    data['VILLAGE_NAME'] = vILLAGENAME;
    return data;
  }
}
