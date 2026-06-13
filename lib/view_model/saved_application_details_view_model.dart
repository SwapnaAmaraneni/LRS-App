import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_request.dart';
import 'package:lrsofficer/models/list_of_master_plan_zdp_response.dart';
import 'package:lrsofficer/models/saved_applications/saved_application_details_payload.dart';
import 'package:lrsofficer/models/saved_applications/saved_application_details_response.dart';
import 'package:lrsofficer/repository/list_of_master_plan_zdp_repo.dart';
import 'package:lrsofficer/repository/saved_applications_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedApplicationDetailsViewModel extends ChangeNotifier {
  TextEditingController plotNoController = TextEditingController();
  TextEditingController plotAreaExtentController = TextEditingController();
  TextEditingController roadEffectedAreaExtentController =
      TextEditingController();
  TextEditingController totalPlotAreaController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController alternateMobileNoController = TextEditingController();
  TextEditingController totalNoOfLayoutPlotsController =
      TextEditingController();
  TextEditingController soldLayoutPlotsController = TextEditingController();
  TextEditingController unSoldLayoutPlotsController = TextEditingController();
 
  clearAll() {
    plotNoController.clear();
    plotAreaExtentController.clear();
    roadEffectedAreaExtentController.clear();
    totalPlotAreaController.clear();
    emailIdController.clear();
    alternateMobileNoController.clear();
    totalNoOfLayoutPlotsController.clear();
    soldLayoutPlotsController.clear();
    unSoldLayoutPlotsController.clear();
    selectedListMasterPlansZDP = null;
    notifyListeners();
  }

  List<ApplicationDetails> savedApplicationDetails = [];
  List<ApplicationDetails> get getSavedApplicationDetails =>
      savedApplicationDetails;
  bool isLoaderVisible = false;
  List<ListMasterPlansZDP> listMasterPlansZDP = [];
  ListMasterPlansZDP? selectedListMasterPlansZDP;
  String? selectedUnsoldPlotDetails;

  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  bool isSroEdited = false;
  void setSroEdited(bool isEdited) {
    isSroEdited = isEdited;
    notifyListeners();
  }

  void changeUnsoldPlotDetails(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    selectedUnsoldPlotDetails = value;
    await prefs.setString(SharedPrefConstants.selectedUnsoldPlotKey,
            selectedUnsoldPlotDetails ?? "");
    notifyListeners();
  }

  Future<void> getSavedApplicationDetailsApi(BuildContext context) async {
    try {
      savedApplicationDetails.clear();
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        SavedApplicationDetailsPayload request =
            SavedApplicationDetailsPayload();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.iSLayoutPlot = AppConstants.isLayoutPlot;
        request.applicationID =
            await sharedpref.readTheData(SharedPrefConstants.applicationNo);
        if (!context.mounted) return;
        SavedApplicationDetailsResponse? response =
            await SavedApplicationsRepository()
                .getSavedApplicationDetails(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          List<ApplicationDetails> applicationsCount =
              response.applications ?? [];
          if (applicationsCount.isNotEmpty) {
            savedApplicationDetails = response.applications ?? [];
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

  Future<void> getListOfMasterPlansZDPDetails(BuildContext context) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        ListOfMasterPlanZDPRequest request = ListOfMasterPlanZDPRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        ListOfMasterPlanZDPResponse? response =
            await ListMasterPlanZDPRepository()
                .getListMasterPlanZDPDetails(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          List<ListMasterPlansZDP>? applicationsCount =
              response.listMasterPlansZDP ?? [];
          if (applicationsCount.isNotEmpty) {
            listMasterPlansZDP = response.listMasterPlansZDP ?? [];
            selectedListMasterPlansZDP = listMasterPlansZDP.first;
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

  Future<void> navigateToUploadDocsScreen(BuildContext context,
      {required String applicationId,
      required String plotNo,
      required String areaExtent,
      required String plotAreaExtent,
      required String roadAreaExtent,
      required String masterplanZdp,
      required ApplicationDetails applicationDetails,
      required String totalNoOfPlots,
      required String soldPlots,
      required String unsoldPlots,
      required totalUnsoldPlotArea,
      required String layoutName,
      required String sroCode}) async {
    if (AppConstants.isLayoutPlot == "P") {
      if (isSroEdited == true && sroCode.length != 4) {
        ValidationIoSAlert()
            .showAlert(context, description: "Please enter valid SRO code.");
      } else if (plotNo.isEmpty || plotNo == "") {
        ValidationIoSAlert()
            .showAlert(context, description: "Please enter plot no.");
      } else if (plotNo == "0") {
        ValidationIoSAlert()
            .showAlert(context, description: "Please enter valid plot no.");
      } else if (plotAreaExtent.isEmpty || plotAreaExtent == "") {
        ValidationIoSAlert()
            .showAlert(context, description: "Please enter plot area");
      } else if (roadAreaExtent.isEmpty) {
        ValidationIoSAlert()
            .showAlert(context, description: "Please enter road effected area");
      } else if (masterplanZdp.isEmpty ||
          masterplanZdp.toLowerCase() == "please select") {
        ValidationIoSAlert().showAlert(context,
            description: "Please select land use as per Master Plan/ZDP");
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(SharedPrefConstants.applicationNo, applicationId);
        // await prefs.setString(SharedPrefConstants.layoutNameKey, layoutName);
        await prefs.setString(SharedPrefConstants.plotNoKey, plotNo);
        await prefs.setString(SharedPrefConstants.areaExtentKey, areaExtent);
        await prefs.setString(
            SharedPrefConstants.plotAreaExtentKey, plotAreaExtent);
        await prefs.setString(
            SharedPrefConstants.roadAreaExtentKey, roadAreaExtent);
        await prefs.setString(
            SharedPrefConstants.masterplanZdpKey, masterplanZdp);
        if (!context.mounted) return;
        Navigator.pushNamed(context, AppRoutes.savedUploadPlotDetails);
      }
    } else {
      if (isSroEdited == true && sroCode.length != 4) {
        ValidationIoSAlert()
            .showAlert(context, description: "Please enter valid SRO code.");
      } else if (selectedUnsoldPlotDetails == '' ||
          selectedUnsoldPlotDetails == null) {
        ValidationIoSAlert().showAlert(context,
            description:
                "Please select do you want to enter Unsold plot Details");
      } else if (totalNoOfPlots.isEmpty) {
        ValidationIoSAlert()
            .showAlert(context, description: "Please enter total no of plots");
      } else if (soldPlots.isEmpty) {
        ValidationIoSAlert()
            .showAlert(context, description: "Please enter sold plots");
      } else if (selectedUnsoldPlotDetails == 'N' &&
          totalUnsoldPlotArea.isEmpty) {
        ValidationIoSAlert().showAlert(context,
            description: "Please enter total unsold plot area");
      } else if (masterplanZdp.isEmpty ||
          masterplanZdp.toLowerCase() == "please select") {
        ValidationIoSAlert().showAlert(context,
            description: "Please select land use as per Master Plan/ZDP");
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(SharedPrefConstants.applicationNo, applicationId);
        await prefs.setString(SharedPrefConstants.layoutNameKey, layoutName);
        await prefs.setString(SharedPrefConstants.selectedUnsoldPlotKey,
            selectedUnsoldPlotDetails ?? "");
        await prefs.setString(
            SharedPrefConstants.totalNoOfPlotsKey, totalNoOfPlots);
        await prefs.setString(SharedPrefConstants.soldPlotsKey, soldPlots);
        await prefs.setString(SharedPrefConstants.unsoldPlotsKey, unsoldPlots);
        await prefs.setString(
            SharedPrefConstants.totalunsoldPlotAreakey, totalUnsoldPlotArea);
        await prefs.setString(
            SharedPrefConstants.masterplanZdpKey, masterplanZdp);
        // await prefs.setString(SharedPrefConstants.latitudeKey, latitude);
        // await prefs.setString(SharedPrefConstants.longitudeKey, longitude);
        if (!context.mounted) return;
        if (AppConstants.isLayoutPlot == "L" &&
            selectedUnsoldPlotDetails == 'Y' &&
            unsoldPlots != "0") {
          final unsoldPlotStr =
              jsonEncode(applicationDetails.listUnsoldPlots ?? []);
          prefs.setString(SharedPrefConstants.unsoldPlotListKey, unsoldPlotStr);
          Navigator.pushNamed(context, AppRoutes.savedAddUnsoldPlotsList);
        } else if (AppConstants.isLayoutPlot == "L" &&
            selectedUnsoldPlotDetails == 'Y' &&
            unsoldPlots == "0") {
          ValidationIoSAlert()
              .showAlert(context, description: "unable to process");
        } else {
          Navigator.pushNamed(context, AppRoutes.savedUploadPlotDetails);
        }
      }
    }
  }

  void changeMasterPlanZDP(ListMasterPlansZDP? newValue) {
    selectedListMasterPlansZDP = newValue;
    notifyListeners();
  }
}
