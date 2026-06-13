import 'package:flutter/material.dart';

class IndividualPlotsDashboardViewModel with ChangeNotifier {
  //List<ClusterCountApplications> clusterListCountApplications = [];
  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }
}
