import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/cluster_wise_appl_list_response.dart';
import 'package:lrsofficer/models/search_payload.dart';
import 'package:lrsofficer/repository/search_application_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';

class SearchViewModel with ChangeNotifier {
  final serachRepo = SearchApplicationRepository();
  bool isLoaderVisible = false;
  List<ClusterwiseApplListResponseDetails> searchApplicationList = [];
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  Future<void> onSearch(TextEditingController key, BuildContext context) async {
    try {
      if ((key.text.trim()).isNotEmpty) {
        if (await internetCheck()) {
          searchApplicationList.clear();
          setLoaderVisibleStatus(true);
          SearchApplicationPayload request = SearchApplicationPayload();
          LocalStoreHelper sharedpref = LocalStoreHelper();
          request.userID =
              await sharedpref.readTheData(SharedPrefConstants.userID);
          request.empID =
              await sharedpref.readTheData(SharedPrefConstants.empID);
          request.tokenID =
              await sharedpref.readTheData(SharedPrefConstants.token);
          request.applicationID = key.text.trim();
          request.iSLayoutPlot = AppConstants.isLayoutPlot;
          if (!context.mounted) return;
          ClusterwiseApplicationListResponse? response =
              await serachRepo.serachApplicationById(context, request);
          if (response != null &&
              response.statusCode == ApiErrorCodes.success) {
            List<ClusterwiseApplListResponseDetails> applicationsCount =
                response.clusterwiseApplicationListDetails ?? [];
            if (applicationsCount.isNotEmpty) {
              searchApplicationList =
                  response.clusterwiseApplicationListDetails ?? [];
              if (!context.mounted) return;
              key.clear();
              Navigator.pushNamed(context, AppRoutes.serachApplicationList);
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
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: "internetCheck".tr(),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        ValidationIoSAlert()
            .showAlert(context, description: "Search Value is Empty ");
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
