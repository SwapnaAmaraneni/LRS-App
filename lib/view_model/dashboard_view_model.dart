import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/dashboard/dashboard_payload.dart';
import 'package:lrsofficer/models/dashboard/dashboard_response.dart';
import 'package:lrsofficer/models/login/login_response.dart';
import 'package:lrsofficer/repository/dashboard_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/internet_check_alert.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import '../res/constants/app_constants.dart';
import '../utils/shared_pref_constants.dart';

class DashboardViewModel extends ChangeNotifier {
  List<DashboardData> dashboardInfo = [];
  List<DashboardData>? newDashboardMenu;
  bool _isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => _isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    _isLoaderVisible = status;
    notifyListeners();
  }

  LoginDtls loginData = LoginDtls();
  LoginDtls get getLoginData => loginData;
  Future<void> getResponseDetails() async {
    final userType =
        await LocalStoreHelper().readTheData(SharedPrefConstants.userType);
    AppConstants.userType = userType;

    final loginDetails =
        await LocalStoreHelper().readTheData(SharedPrefConstants.loginResponse);
    final data = jsonDecode(loginDetails);
    loginData = LoginDtls.fromJson(data);
    notifyListeners();
  }

  void navigationsThroughIcons(String navigatorApproute, BuildContext context) {
    Navigator.pushNamed(context, navigatorApproute);
  }

  Future<void> getDashboardDetails(BuildContext context) async {
    try {
      dashboardInfo.clear();
      newDashboardMenu?.clear();
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        if (!context.mounted) return;
        final payload = DashboardPayload(
          empID: loginData.empID,
          tokenID: loginData.tokenID,
          userID: loginData.userID,
        );
        DashboardResponse? dashboardMenuResponse =
            await DashboardRepository().dashboardRepo(context, payload);
        if (dashboardMenuResponse != null) {
          if (dashboardMenuResponse.statusCode == ApiErrorCodes.success) {
            newDashboardMenu = dashboardMenuResponse.newDashboardData ?? [];
            dashboardInfo = dashboardMenuResponse.dashboardData ?? [];
            // Print before sorting
            if (!kReleaseMode) {
              debugPrint(
                  "Before sorting: ${dashboardInfo.map((item) => item.dISPLAYORDER).toList()}");
            }

            // Sort the list
            dashboardInfo.sort((a, b) {
              final orderA = int.tryParse(a.dISPLAYORDER ?? "0") ?? 0;
              final orderB = int.tryParse(b.dISPLAYORDER ?? "0") ?? 0;
              return orderA.compareTo(orderB);
            });
            newDashboardMenu?.sort((a, b) {
              final orderA = int.tryParse(a.dISPLAYORDER ?? "0") ?? 0;
              final orderB = int.tryParse(b.dISPLAYORDER ?? "0") ?? 0;
              return orderA.compareTo(orderB);
            });

            //Print after sorting
            if (!kReleaseMode) {
              debugPrint(
                  "After sorting: ${dashboardInfo.map((item) => item.dISPLAYORDER).toList()}");
            }

            if (!kReleaseMode) {
              debugPrint(
                  "dashboardInfo::::::::::: ${dashboardMenuResponse.toJson()}");
            }
            setLoaderVisibleStatus(false);
            notifyListeners();
          } else if (dashboardMenuResponse.statusCode ==
              ApiErrorCodes.badRequest) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: dashboardMenuResponse.statusMsg.toString(),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          } else if (dashboardMenuResponse.statusCode ==
              ApiErrorCodes.sessionExpired) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: dashboardMenuResponse.statusMsg.toString(),
              onPressed: () async {
                await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            );
          } else {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: dashboardMenuResponse.statusMsg ?? "",
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          }
        } else {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: "somethingWentWrong".tr(),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        if (!context.mounted) return;
        InternetCheckAlert().showAlert(context);
      }
    } on DioException catch (dioError) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(dioError, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } catch (error) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } finally {
      setLoaderVisibleStatus(false);
    }
  }

  void navigations(
    BuildContext context,
    DashboardData dashboardData,
  ) {
    if ((dashboardData.mENUNAME ?? "").toLowerCase().contains("plot")) {
      AppConstants.isLayoutPlot = "P";
    } else if ((dashboardData.mENUNAME ?? "")
        .toLowerCase()
        .contains("layout")) {
      AppConstants.isLayoutPlot = "L";
    } else {
      AppConstants.isLayoutPlot = "";
    }
    if ((dashboardData.mENUNAME ?? "").toLowerCase().contains("save")) {
      AppConstants.isSavedApplication = "yes";
    } else {
      AppConstants.isSavedApplication = "";
    }
    switch (dashboardData.iD) {
      case "1":
        Navigator.pushNamed(context, AppRoutes.villagewiseSurveyNumbersList);
        break;
      case "2":
        Navigator.pushNamed(context, AppRoutes.layoutApplicationsDashboard);
        // Navigator.pushNamed(context, AppRoutes.clusterwiseVillageCount);
        break;
      case "3":
        Navigator.pushNamed(context, AppRoutes.savedApplicationList);
        break;
      case "4":
        Navigator.pushNamed(context, AppRoutes.savedApplicationList);
        break;
      case "5":
        Navigator.pushNamed(context, AppRoutes.prohibitedApplicationList);
        break;
      case "6":
        Navigator.pushNamed(context, AppRoutes.prohibitedApplicationList);
        break;
      case "7":
        Navigator.pushNamed(context, AppRoutes.processedApplicationList);
        break;
      case "8":
        Navigator.pushNamed(context, AppRoutes.processedApplicationList);
        break;
      case "9":
        Navigator.pushNamed(context, AppRoutes.processedPLbyOfficerList);
        break;
      case "10":
        Navigator.pushNamed(context, AppRoutes.processedPLbyOfficerList);
        break;
      case "11":
        Navigator.pushNamed(context, AppRoutes.shortfallVillagewiseList);
        break;
      case "12":
        Navigator.pushNamed(context, AppRoutes.shortfallVillagewiseList);
        break;
      case "13":
        Navigator.pushNamed(context, AppRoutes.phase1VillageWiseList);
        break;
      case "14":
        Navigator.pushNamed(context, AppRoutes.phase1VillageWiseList);
        break;
      case "15":
        Navigator.pushNamed(context, AppRoutes.phase2ShortfallVillageWiseList);
        break;
      case "16":
        Navigator.pushNamed(context, AppRoutes.phase2ShortfallVillageWiseList);
        break;
      case "17":
        Navigator.pushNamed(context, AppRoutes.phase2RevertedVillageWiseList);
        break;
      case "18":
        Navigator.pushNamed(context, AppRoutes.phase2RevertedVillageWiseList);
        break;
      case "19":
        AppConstants.fifpFlag = "FP";
        Navigator.pushNamed(context, AppRoutes.feePaidApplications);
        break;
      case "20":
        Navigator.pushNamed(context, AppRoutes.slaBreachesApplications);
        break;
      case "21":
        AppConstants.fifpFlag = "FI";
        Navigator.pushNamed(context, AppRoutes.feeInitimatedUnpaid);
        break;
      case "24":
        Navigator.pushNamed(context, AppRoutes.igrsApplicationList);
        break;
      default:
    }
  }
}
