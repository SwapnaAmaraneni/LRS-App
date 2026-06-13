class LayoutDynamicSubMenuResponse {
  int? statusCode;
  String? statusMsg;
  List<Dynamic>? menu;

  LayoutDynamicSubMenuResponse({this.statusCode, this.statusMsg, this.menu});

  LayoutDynamicSubMenuResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMsg = json['StatusMsg'];
    if (json['Dynamic'] != null) {
      menu = <Dynamic>[];
      json['Dynamic'].forEach((v) {
        menu!.add(Dynamic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['StatusMsg'] = statusMsg;
    if (menu != null) {
      data['Dynamic'] = menu!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dynamic {
  String? iD;
  String? wEBLINK;
  String? wEBLINKFLAG;
  String? dISPLAYFLAG;
  String? dISPLAYORDER;
  String? iMAGEPATH;
  String? mENUNAME;
  String? mENUID;
  String? pROCESSTYPE;

  Dynamic(
      {this.iD,
      this.wEBLINK,
      this.wEBLINKFLAG,
      this.dISPLAYFLAG,
      this.dISPLAYORDER,
      this.iMAGEPATH,
      this.mENUNAME,
      this.mENUID,
      this.pROCESSTYPE});

  Dynamic.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    wEBLINK = json['WEBLINK'];
    wEBLINKFLAG = json['WEBLINKFLAG'];
    dISPLAYFLAG = json['DISPLAYFLAG'];
    dISPLAYORDER = json['DISPLAYORDER'];
    iMAGEPATH = json['IMAGEPATH'];
    mENUNAME = json['MENUNAME'];
    mENUID = json['MENUID'];
    pROCESSTYPE = json['PROCESS_TYPE'];
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
    data['MENUID'] = mENUID;
    data['PROCESS_TYPE'] = pROCESSTYPE;
    return data;
  }
}
