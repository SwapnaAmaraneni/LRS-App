import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/cluster_wise_appl_list_request.dart';
import 'package:lrsofficer/models/cluster_wise_appl_list_response.dart';
import 'package:lrsofficer/repository/phase2_shortfall_repo/phase2_shortfall_villagewise_list_repo.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';

class Phase2ShortfallClusterWiseApplicationListViewModel with ChangeNotifier {
  bool isLoaderVisible = false;
  List<ClusterwiseApplListResponseDetails> clusterwiseAppliListResponse = [];
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  Future<void> getClusterwiseApplicationListCount(
      BuildContext context, String clusterID) async {
    try {
      if (await internetCheck()) {
        clusterwiseAppliListResponse.clear();
        setLoaderVisibleStatus(true);
        ClusterwiseApplicationListRequest request =
            ClusterwiseApplicationListRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.vILLAGEID =
            await sharedpref.readTheData(SharedPrefConstants.villageId);
        request.clusterID = clusterID;
        request.isLayoutPlot = AppConstants.isLayoutPlot;
        if (!context.mounted) return;
        ClusterwiseApplicationListResponse? response =
            await Phase2ShortfallVillagewiseListRepository()
                .getClusterwiseList(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          List<ClusterwiseApplListResponseDetails> applicationsCount =
              response.clusterwiseApplicationListDetails ?? [];
          if (applicationsCount.isNotEmpty) {
            clusterwiseAppliListResponse =
                response.clusterwiseApplicationListDetails ?? [];
          }
          setLoaderVisibleStatus(false);
        } else if (response?.statusCode == ApiErrorCodes.badRequest) {
          if (!context.mounted) return;
          setLoaderVisibleStatus(false);
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        } else if (response?.statusCode == ApiErrorCodes.sessionExpired) {
          if (!context.mounted) return;
          setLoaderVisibleStatus(false);
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          );
        } else {
          if (!context.mounted) return;
          setLoaderVisibleStatus(false);
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert().showAlert(
          context,
          message: "internetCheck".tr(),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        );
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
}
