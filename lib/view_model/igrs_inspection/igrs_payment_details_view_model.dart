import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/payment_details_payload.dart';
import 'package:lrsofficer/models/payment_details_resposne.dart';
import 'package:lrsofficer/repository/payment_details_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/internet_check_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IGRSPaymentDetailsViewModel extends ChangeNotifier {
  TextEditingController editedMv = TextEditingController();
  TextEditingController editedMvDateOfRegstn = TextEditingController();
  TextEditingController roadEffectedArea = TextEditingController();
  TextEditingController netPlotArea = TextEditingController();
  TextEditingController plotAreaExtent = TextEditingController();
  bool _isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => _isLoaderVisible;
  void setLoaderVisibleStatus(bool isLoaderVisible) {
    _isLoaderVisible = isLoaderVisible;
    notifyListeners();
  }

  bool? isChecked;
  Future<void> onChangeOfCheckBox(
    bool? value,
  ) async {
    isChecked = value ?? false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        SharedPrefConstants.marketValueFlag, isChecked ?? false);
    if (isChecked == false) {
      editedMv.clear();
      editedMvDateOfRegstn.clear();
      plotAreaExtent.clear();
      netPlotArea.clear();
      roadEffectedArea.clear();
    }
    notifyListeners();
  }

  void resetCheckbox() {
    isChecked = false;
    editedMv.clear();
    editedMvDateOfRegstn.clear();
    plotAreaExtent.clear();
    netPlotArea.clear();
    roadEffectedArea.clear();
    notifyListeners();
  }

  bool paymentDetailsValidation(String conversionCharges, String mv,
      String mvDateOFRegstn, BuildContext context) {
    if (conversionCharges.isEmpty || conversionCharges == '') {
      ValidationIoSAlert().showAlert(
        context,
        description: "enterConversionChargers".tr(),
      );
      return false;
    } else if (mv.isEmpty || mv == '') {
      ValidationIoSAlert().showAlert(
        context,
        description: "movOn26082020".tr(),
      );
      return false;
    } else if (mvDateOFRegstn.isEmpty || mvDateOFRegstn == '') {
      ValidationIoSAlert().showAlert(
        context,
        description: "mvDateOFRegistration".tr(),
      );
      return false;
    } else {
      return true;
    }
  }

  List<CalulationDetails>? clusterCalulationDetails;
  List<CalulationDetails>? get getClusterPayDetails => clusterCalulationDetails;
  bool chargesFlag = false;
  bool get getchargesFlag => chargesFlag;
  void setchargesFlag(bool ischargesVisible) {
    chargesFlag = ischargesVisible;
    notifyListeners();
  }

  Future<void> paymentDetalsCalc(String conversionCharges, String mVRATE2020,
      String mVRATEDOCUMET, BuildContext context) async {
    try {
      LocalStoreHelper sharedpref = LocalStoreHelper();
      String userID = await sharedpref.readTheData(SharedPrefConstants.userID);
      String empID = await sharedpref.readTheData(SharedPrefConstants.empID);
      String tokenID = await sharedpref.readTheData(SharedPrefConstants.token);
      String mpin = await sharedpref.readTheData(SharedPrefConstants.mpin);
      String applicationNo =
          await sharedpref.readTheData(SharedPrefConstants.applicationNo);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? totalAreaExtent = AppConstants.isLayoutPlot == "P"
          ? prefs.getString(SharedPrefConstants.areaExtentKey)
          : prefs.getString(SharedPrefConstants.totalunsoldPlotAreakey);
      //if (!context.mounted) return;
      setchargesFlag(false);
      final connection = await internetCheck();
      if (connection) {
        final paymentDetailsPayload = PaymentDetailsPayload(
            applicationID: applicationNo,
            empID: empID,
            mPIN: mpin,
            mVRATE2020: mVRATE2020,
            mVRATEDOCUMET: mVRATEDOCUMET,
            tokenID: tokenID,
            totalAreaExtent: totalAreaExtent ?? "",
            userID: userID,
            isLayoutPlot: AppConstants.isLayoutPlot);

        AppLogger().logDebug(
            "paymentDetailsPayload ${paymentDetailsPayload.toJson()}");

        setLoaderVisibleStatus(true);
        if (!context.mounted) return;
        PaymentDetailsResponse? response = await PaymentDetailsRepository()
            .clusterPaymentDetailsRepo(context, paymentDetailsPayload);

        if (response != null && response.statusCode == ApiErrorCodes.success) {
          clusterCalulationDetails = response.calulationDetails;
          await prefs.setBool(SharedPrefConstants.isCalculate, true);
          setchargesFlag(true);
          setLoaderVisibleStatus(false);
          notifyListeners();
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

  Future<void> navigateToRecommendations(
      String conversionCharges,
      String mvRate2020,
      String mvDateOfRegstn,
      CalulationDetails? clusterCalulationDetail,
      BuildContext context) async {
    //save
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        SharedPrefConstants.vltKey, clusterCalulationDetail?.vLTCharges ?? "");

    await prefs.setString(SharedPrefConstants.plotOpenspaceKey,
        clusterCalulationDetail?.openSpaceCharges ?? "");
    await prefs.setString(SharedPrefConstants.trcKey,
        clusterCalulationDetail?.totalRegCharges ?? "");

    await prefs.setString(
        SharedPrefConstants.conversionChargesKey, conversionCharges);

    await prefs.setString(SharedPrefConstants.mvRate2020Key, mvRate2020);

    await prefs.setString(
        SharedPrefConstants.mvRateDocumentKey, mvDateOfRegstn);
    await prefs.setString(
        SharedPrefConstants.rcKey, clusterCalulationDetail?.regCharges ?? "");
    if (!context.mounted) return;
    if (await validateFields(context)) {
      if (!context.mounted) return;
      Navigator.pushNamed(context, AppRoutes.igrsRecommendations);
    }
  }

  Future<bool> validateFields(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? marketValueFlag = prefs.getBool(SharedPrefConstants.marketValueFlag);
    if (marketValueFlag ?? false) {
      // Validate Market Value
      final mvText = editedMv.text.trim();
      if (mvText.isEmpty) {
        if (!context.mounted) return false;
        ValidationIoSAlert().showAlert(
          context,
          description: "movOn26082020".tr(),
        );
        return false;
      } else if (_isInvalidNumeric(mvText)) {
        if (!context.mounted) return false;
        ValidationIoSAlert().showAlert(
          context,
          description: "Enter valid Market Value",
        );
        return false;
      }

      // Validate Date of Registration
      final mvDateText = editedMvDateOfRegstn.text.trim();
      if (mvDateText.isEmpty) {
        if (!context.mounted) return false;
        ValidationIoSAlert().showAlert(
          context,
          description: "mvDateOFRegistration".tr(),
        );
        return false;
      } else if (_isInvalidNumeric(mvDateText)) {
        if (!context.mounted) return false;
        ValidationIoSAlert().showAlert(
          context,
          description: "Enter valid market value as on Date of Registration",
        );
        return false;
      }

      // Validate Plot Area Extent
      final plotAreaText = plotAreaExtent.text.trim();
      if (plotAreaText.isEmpty) {
        if (!context.mounted) return false;
        ValidationIoSAlert().showAlert(
          context,
          description: "plotAreaExtent".tr(),
        );
        return false;
      } else if (_isInvalidNumeric(plotAreaText)) {
        if (!context.mounted) return false;
        ValidationIoSAlert().showAlert(
          context,
          description: "Enter valid Plot Area Extent",
        );
        return false;
      }

      // Validate Road Effected Area
      final roadAreaText = roadEffectedArea.text.trim();
      if (roadAreaText.isEmpty) {
        if (!context.mounted) return false;
        ValidationIoSAlert().showAlert(
          context,
          description: "roadEffectedArea".tr(),
        );
        return false;
      } else if (_isInvalidNumeric(roadAreaText)) {
        if (!context.mounted) return false;
        ValidationIoSAlert().showAlert(
          context,
          description: "Enter valid Road Effected Area",
        );
        return false;
      }

      // Validate Net Plot Area
      final netPlotAreaText = netPlotArea.text.trim();
      if (netPlotAreaText.isEmpty) {
        if (!context.mounted) return false;
        ValidationIoSAlert().showAlert(
          context,
          description: "netplotAreaExtent".tr(),
        );
        return false;
      } else if (_isInvalidNumeric(netPlotAreaText)) {
        if (!context.mounted) return false;
        ValidationIoSAlert().showAlert(
          context,
          description: "Enter valid Net Plot Area",
        );
        return false;
      }
    }
    return true; // All validations passed
  }

  // bool _isInvalidNumeric(String text) {
  //   final trimmed = text.trim();
  //   if (trimmed.isEmpty) return false; // Handle empty separately
  //   if (trimmed.endsWith('.')) return true;
  //   final value = double.tryParse(trimmed);
  //   return value == 0;
  // }
  bool _isInvalidNumeric(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false; // empty is handled elsewhere
    if (trimmed.endsWith('.')) return true; // incomplete decimal
    final value = double.tryParse(trimmed);
    return value == null; // invalid if not a number at all
  }
}
