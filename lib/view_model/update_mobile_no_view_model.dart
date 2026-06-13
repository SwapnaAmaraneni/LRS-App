import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/update_mobile_no_request.dart';
import 'package:lrsofficer/models/update_mobile_no_response.dart';
import 'package:lrsofficer/repository/update_mobile_no_repo.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_success_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/get_device_ip_address.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_application_details_view_model.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_layout_application_details_view_model.dart';
import 'package:lrsofficer/view_model/plots_layouts/cluster_application_details_view_model.dart';
import 'package:lrsofficer/view_model/igrs_inspection/igrs_application_details_view_model.dart';
import 'package:lrsofficer/view_model/plots_layouts/layout_cluster_application_details_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_layout_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_layout_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_layout_application_details_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_application_details_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_layout_app_details_view_model.dart';
import 'package:provider/provider.dart';

class UpdateMobileNoViewModel extends ChangeNotifier {
  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  Future<void> updateMobileApi(BuildContext context, String oldNumber,
      String newNumber, String applID) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        UpdateMobileNoRequest request = UpdateMobileNoRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.oLDMOBILENO = oldNumber;
        request.nEWMOBILENO = newNumber;
        request.cREATEDBY =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.aPPLICATIONID = applID;
        request.iPADDRESS = await GetDeviceIpAddress().getIp();
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        UpdateMobileNoResponse? response =
            await UpdateMobileNoRepository().updateMobileRepo(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          SuccessCustomCupertinoAlert().showAlert(
            context: context,
            title: response.statusMsg ?? "",
            onPressed: () {
              Navigator.pop(context);
              final clusterwiseApplDetailsProvider =
                  Provider.of<ClusterApplicationDetailsViewModel>(context,
                      listen: false);
              final layoutwiseAppDetailsProvider =
                  Provider.of<LayoutClusterApplicationDetailsViewModel>(context,
                      listen: false);
              AppConstants.isLayoutPlot == "P"
                  ? clusterwiseApplDetailsProvider
                      .getClusterApplDetails(context)
                  : layoutwiseAppDetailsProvider.getClusterApplDetails(context);
            },
          );
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

  Future<void> updateMobileProhibitedAppApi(BuildContext context,
      String oldNumber, String newNumber, String applID) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        UpdateMobileNoRequest request = UpdateMobileNoRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.oLDMOBILENO = oldNumber;
        request.nEWMOBILENO = newNumber;
        request.cREATEDBY =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.aPPLICATIONID = applID;
        request.iPADDRESS = await GetDeviceIpAddress().getIp();
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        UpdateMobileNoResponse? response =
            await UpdateMobileNoRepository().updateMobileRepo(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          SuccessCustomCupertinoAlert().showAlert(
            context: context,
            title: response.statusMsg ?? "",
            onPressed: () {
              Navigator.pop(context);
              final prohibitedApplDetailsProvider =
                  Provider.of<ProhibitedApplicationDetailsViewModel>(context,
                      listen: false);
              final prohibitedLayoutwiseAppDetailsProvider =
                  Provider.of<ProhibitedLayoutApplicationDetailsViewModel>(
                      context,
                      listen: false);
              AppConstants.isLayoutPlot == "P"
                  ? prohibitedApplDetailsProvider.getClusterApplDetails(context)
                  : prohibitedLayoutwiseAppDetailsProvider
                      .getClusterApplDetails(context);
            },
          );
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

  Future<void> updateShortfallMobileApi(BuildContext context, String oldNumber,
      String newNumber, String applID) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        UpdateMobileNoRequest request = UpdateMobileNoRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.oLDMOBILENO = oldNumber;
        request.nEWMOBILENO = newNumber;
        request.cREATEDBY =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.aPPLICATIONID = applID;
        request.iPADDRESS = await GetDeviceIpAddress().getIp();
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        UpdateMobileNoResponse? response =
            await UpdateMobileNoRepository().updateMobileRepo(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          SuccessCustomCupertinoAlert().showAlert(
            context: context,
            title: response.statusMsg ?? "",
            onPressed: () {
              Navigator.pop(context);
              final clusterwiseApplDetailsProvider =
                  Provider.of<ShortfallApplicationDetailsViewModel>(context,
                      listen: false);
              final layoutwiseAppDetailsProvider =
                  Provider.of<ShortfallLayoutApplicationDetailsViewModel>(
                      context,
                      listen: false);
              AppConstants.isLayoutPlot == "P"
                  ? clusterwiseApplDetailsProvider
                      .getClusterApplDetails(context)
                  : layoutwiseAppDetailsProvider.getClusterApplDetails(context);
            },
          );
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

  Future<void> updatePhase1MobileApi(BuildContext context, String oldNumber,
      String newNumber, String applID) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        UpdateMobileNoRequest request = UpdateMobileNoRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.oLDMOBILENO = oldNumber;
        request.nEWMOBILENO = newNumber;
        request.cREATEDBY =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.aPPLICATIONID = applID;
        request.iPADDRESS = await GetDeviceIpAddress().getIp();
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        UpdateMobileNoResponse? response =
            await UpdateMobileNoRepository().updateMobileRepo(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          SuccessCustomCupertinoAlert().showAlert(
            context: context,
            title: response.statusMsg ?? "",
            onPressed: () {
              Navigator.pop(context);
              final clusterwiseApplDetailsProvider =
                  Provider.of<Phase1ApplicationDetailsViewModel>(context,
                      listen: false);
              final layoutwiseAppDetailsProvider =
                  Provider.of<Phase1LayoutApplicationDetailsViewModel>(context,
                      listen: false);
              AppConstants.isLayoutPlot == "P"
                  ? clusterwiseApplDetailsProvider
                      .getClusterApplDetails(context)
                  : layoutwiseAppDetailsProvider.getClusterApplDetails(context);
            },
          );
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

  Future<void> updatePhase2ShortfallMobileApi(BuildContext context,
      String oldNumber, String newNumber, String applID) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        UpdateMobileNoRequest request = UpdateMobileNoRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.oLDMOBILENO = oldNumber;
        request.nEWMOBILENO = newNumber;
        request.cREATEDBY =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.aPPLICATIONID = applID;
        request.iPADDRESS = await GetDeviceIpAddress().getIp();
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        UpdateMobileNoResponse? response =
            await UpdateMobileNoRepository().updateMobileRepo(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          SuccessCustomCupertinoAlert().showAlert(
            context: context,
            title: response.statusMsg ?? "",
            onPressed: () {
              Navigator.pop(context);
              final clusterwiseApplDetailsProvider =
                  Provider.of<Phase2ShortfallApplicationDetailsViewModel>(
                      context,
                      listen: false);
              final layoutwiseAppDetailsProvider =
                  Provider.of<Phase2ShortfallLayoutApplicationDetailsViewModel>(
                      context,
                      listen: false);
              AppConstants.isLayoutPlot == "P"
                  ? clusterwiseApplDetailsProvider
                      .getClusterApplDetails(context)
                  : layoutwiseAppDetailsProvider.getClusterApplDetails(context);
            },
          );
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

  Future<void> updatePhase2RevertedMobileApi(BuildContext context,
      String oldNumber, String newNumber, String applID) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        UpdateMobileNoRequest request = UpdateMobileNoRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.oLDMOBILENO = oldNumber;
        request.nEWMOBILENO = newNumber;
        request.cREATEDBY =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.aPPLICATIONID = applID;
        request.iPADDRESS = await GetDeviceIpAddress().getIp();
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        UpdateMobileNoResponse? response =
            await UpdateMobileNoRepository().updateMobileRepo(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          SuccessCustomCupertinoAlert().showAlert(
            context: context,
            title: response.statusMsg ?? "",
            onPressed: () {
              Navigator.pop(context);
              final clusterwiseApplDetailsProvider =
                  Provider.of<Phase2RevertedApplicationDetailsViewModel>(
                      context,
                      listen: false);
              final layoutwiseAppDetailsProvider =
                  Provider.of<Phase2RevertedLayoutApplicationDetailsViewModel>(
                      context,
                      listen: false);
              AppConstants.isLayoutPlot == "P"
                  ? clusterwiseApplDetailsProvider
                      .getClusterApplDetails(context)
                  : layoutwiseAppDetailsProvider.getClusterApplDetails(context);
            },
          );
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

  Future<void> updateFifpMobile(BuildContext context, String oldNumber,
      String newNumber, String applID) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        UpdateMobileNoRequest request = UpdateMobileNoRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.oLDMOBILENO = oldNumber;
        request.nEWMOBILENO = newNumber;
        request.cREATEDBY =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.aPPLICATIONID = applID;
        request.iPADDRESS = await GetDeviceIpAddress().getIp();
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        UpdateMobileNoResponse? response =
            await UpdateMobileNoRepository().updateMobileRepo(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          SuccessCustomCupertinoAlert().showAlert(
            context: context,
            title: response.statusMsg ?? "",
            onPressed: () {
              Navigator.pop(context);
              final clusterwiseApplDetailsProvider =
                  Provider.of<FifpApplicationDetailsViewModel>(context,
                      listen: false);

              clusterwiseApplDetailsProvider.getClusterApplDetails(context);
            },
          );
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

  Future<void> updateIGRSMobile(BuildContext context, String oldNumber,
      String newNumber, String applID) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        UpdateMobileNoRequest request = UpdateMobileNoRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.oLDMOBILENO = oldNumber;
        request.nEWMOBILENO = newNumber;
        request.cREATEDBY =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.aPPLICATIONID = applID;
        request.iPADDRESS = await GetDeviceIpAddress().getIp();
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        UpdateMobileNoResponse? response =
            await UpdateMobileNoRepository().updateMobileRepo(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          setLoaderVisibleStatus(false);
          if (!context.mounted) return;
          SuccessCustomCupertinoAlert().showAlert(
            context: context,
            title: response.statusMsg ?? "",
            onPressed: () {
              Navigator.pop(context);
              final clusterwiseApplDetailsProvider =
                  Provider.of<IGRSApplicationDetailsViewModel>(context,
                      listen: false);

              clusterwiseApplDetailsProvider.getClusterApplDetails(context);
            },
          );
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
