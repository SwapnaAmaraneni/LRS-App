import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/individual_plots_new_flow/layout_dynamic_menu_payload.dart';
import 'package:lrsofficer/models/individual_plots_new_flow/layout_dynamic_menu_response.dart';
import 'package:lrsofficer/repository/individual_plots_new_flow_repository/layout_dynamic_menu_repo.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';

class LayoutApplicationDashboardViewmodel extends ChangeNotifier {
  //Api call for clutterwise village count
  List<Dynamic> menu = [];
  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  Future<void> getLayoutMenu(BuildContext context) async {
    try {
      menu.clear();
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        LayoutDynamicSubMenuPayload request = LayoutDynamicSubMenuPayload();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.mPIN = await sharedpref.readTheData(SharedPrefConstants.mpin);
        request.iSLayoutPlot = AppConstants.isLayoutPlot;
        if (!context.mounted) return;
        LayoutDynamicSubMenuResponse? response =
            await LayoutDynamicMenuRepository().menuRepo(context, request);

        if (response != null && response.statusCode == ApiErrorCodes.success) {
          List<Dynamic> applicationsCount = response.menu ?? [];
          if (applicationsCount.isNotEmpty) {
            menu = response.menu ?? [];
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
