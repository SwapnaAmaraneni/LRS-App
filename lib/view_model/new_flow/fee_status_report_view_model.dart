import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/dashboard/dashboard_payload.dart';
import 'package:lrsofficer/models/login/login_response.dart';
import 'package:lrsofficer/models/new_flow/fee_status_report_response.dart';
import 'package:lrsofficer/repository/new_flow/fee_status_reports_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/internet_check_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';

class FeeStatusReportViewModel with ChangeNotifier {
  LoginDtls loginData = LoginDtls();
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

  FeeStatusReportResponse? reportData;
  FeeStatusReportResponse? get getReportData => reportData;
  Future<void> feeStatusApi(BuildContext context) async {
    try {
      if (await internetCheck()) {
        await getResponseDetails();
        setLoaderVisibleStatus(true);
        if (!context.mounted) return;
        final payload = DashboardPayload(
          empID: loginData.empID,
          tokenID: loginData.tokenID,
          userID: loginData.userID,
        );
        FeeStatusReportResponse? response =
            await FeeStatusReportsRepository().feeStatusApi(context, payload);
        if (response != null) {
          if (response.statusCode == ApiErrorCodes.success) {
            reportData = response;
            if (!kReleaseMode) {
              debugPrint("dashboardInfo::::::::::: ${response.toJson()}");
            }
            setLoaderVisibleStatus(false);
          } else if (response.statusCode == ApiErrorCodes.badRequest) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response.statusMsg.toString(),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          } else if (response.statusCode == ApiErrorCodes.sessionExpired) {
            setLoaderVisibleStatus(false);
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response.statusMsg.toString(),
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
              message: response.statusMsg ?? "",
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

  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }
}
