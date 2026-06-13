import 'package:flutter/material.dart';

class UploadPlotDetailsItemModel {
  IconData? icon;
  String? label;

  UploadPlotDetailsItemModel({this.icon, this.label});

  UploadPlotDetailsItemModel.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon;
    data['label'] = label;
    return data;
  }
}
