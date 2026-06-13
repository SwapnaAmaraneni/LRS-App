import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/dashboard/dashboard_payload.dart';
import 'package:lrsofficer/models/global_search/global_search_masters_response.dart';
import 'package:lrsofficer/models/global_search/global_search_officer_details_payload.dart';
import 'package:lrsofficer/models/global_search/global_search_officer_details_response.dart';
import 'package:lrsofficer/models/global_search/global_search_payload.dart';
import 'package:lrsofficer/models/global_search/global_search_response.dart';
import 'package:lrsofficer/repository/global_search_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';

class GlobalSearchViewModel with ChangeNotifier {
  TextEditingController applicationNoController = TextEditingController();
  TextEditingController surveyNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String?
      selectedSearchType; // "y" for Application Number, "n" for Other Details
  List<GlobalSearchList>? searchedData;
  List<OfficersList>? officersList;
  void onSearchTypeChange(String? val) {
    searchedData = null;
    applicationNoController.clear();
    surveyNoController.clear();
    nameController.clear();
    selectedDistrict = null;
    selectedMandal = null;
    selectedVillage = null;
    selectedSearchType = val;
    officersList = null;
    notifyListeners();
  }

  List<Districts> dropdownDistricts = [];
  Districts? selectedDistrict;

  Mandals? selectedMandal;
  List<Mandals> dropdownMandals = [];

  Villages? selectedVillage;
  List<Villages> dropdownVillages = [];

  void clearAll() {
    searchedData = null;
    applicationNoController.clear();
    surveyNoController.clear();
    nameController.clear();
    selectedDistrict = null;
    selectedMandal = null;
    selectedVillage = null;
    selectedSearchType = null;
    officersList = null;
    notifyListeners();
  }

  void onChangeDistrict(Districts? val) {
    selectedDistrict = val;
    searchedData = null;
    selectedMandal = null;
    selectedVillage = null;
    dropdownMandals.clear();
    dropdownVillages.clear();
    List<Mandals> filteredMandals =
        getMandalsByDistrictId(selectedDistrict?.dISTRICTID ?? 0);
    dropdownMandals.addAll(filteredMandals);
    notifyListeners();
  }

  List<Mandals> getMandalsByDistrictId(int? districtId) {
    return searchMastersResponse?.mandals
            ?.where((mandal) => mandal.dISTRICTID == districtId)
            .toList() ??
        [];
  }

  void onChangeMandal(Mandals? val) {
    selectedMandal = val;
    selectedVillage = null;
    searchedData = null;
    dropdownVillages.clear();
    List<Villages> filteredVillages =
        getVillagesByMandalId(selectedMandal?.mANDALID ?? 0);
    dropdownVillages.addAll(filteredVillages);
    notifyListeners();
  }

  List<Villages> getVillagesByMandalId(int? mandalId) {
    return searchMastersResponse?.villages
            ?.where((villages) => villages.mANDALID == mandalId)
            .toList() ??
        [];
  }

  void onChangeVillage(Villages? val) {
    selectedVillage = val;
    notifyListeners();
  }

  GetGlobalSearchMastersResponse? searchMastersResponse;

  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  Future<void> globalSearchMastersService(
    BuildContext context,
  ) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        LocalStoreHelper sharedpref = LocalStoreHelper();
        final mastersPayload = DashboardPayload();
        mastersPayload.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        mastersPayload.empID =
            await sharedpref.readTheData(SharedPrefConstants.empID);
        mastersPayload.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        searchMastersResponse = null;
        if (!context.mounted) return;
        final response = await GlobalSearchRepository()
            .getGlobalSearchMastersApi(context, mastersPayload);
        setLoaderVisibleStatus(false);
        if (response?.statusCode == ApiErrorCodes.success) {
          searchMastersResponse = response;
          dropdownDistricts = response?.districts ?? [];
          notifyListeners();
        } else if (response?.statusCode == ApiErrorCodes.badRequest) {
          if (!context.mounted) return;
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        } else if (response?.statusCode == ApiErrorCodes.sessionExpired) {
          if (!context.mounted) return;
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

  Future<void> globalSearchService(
    BuildContext context,
  ) async {
    try {
      if (selectedSearchType == null) {
        ValidationIoSAlert().showAlert(context,
            description:
                "Please select whether you want to search using the application number or other details.");
      } else if ((selectedSearchType == "1" ||
              selectedSearchType?.toLowerCase() == "y") &&
          applicationNoController.text.trim().isEmpty) {
        ValidationIoSAlert().showAlert(context,
            description: "Please enter application number.");
      } else if ((selectedSearchType == "2" ||
              selectedSearchType?.toLowerCase() == "n") &&
          selectedDistrict?.dISTRICTID == null) {
        ValidationIoSAlert()
            .showAlert(context, description: "Please select district.");
      } else if ((selectedSearchType == "2" ||
              selectedSearchType?.toLowerCase() == "n") &&
          selectedDistrict?.dISTRICTID != null &&
          selectedMandal?.mANDALID == null) {
        ValidationIoSAlert()
            .showAlert(context, description: "Please select mandal.");
      } else if ((selectedSearchType == "2" ||
              selectedSearchType?.toLowerCase() == "n") &&
          selectedDistrict?.dISTRICTID != null &&
          selectedMandal?.mANDALID != null &&
          selectedVillage?.vILLAGEID == null) {
        ValidationIoSAlert()
            .showAlert(context, description: "Please select village.");
      } else if ((selectedSearchType == "2" ||
              selectedSearchType?.toLowerCase() == "n") &&
          selectedDistrict?.dISTRICTID != null &&
          selectedMandal?.mANDALID != null &&
          selectedVillage?.vILLAGEID != null &&
          nameController.text.trim().isEmpty) {
        ValidationIoSAlert()
            .showAlert(context, description: "Please enter name.");
      } else {
        if (await internetCheck()) {
          setLoaderVisibleStatus(true);
          LocalStoreHelper sharedpref = LocalStoreHelper();
          GlobalSearchPayload searchPayload = GlobalSearchPayload();
          final userID =
              await sharedpref.readTheData(SharedPrefConstants.userID);
          final empID = await sharedpref.readTheData(SharedPrefConstants.empID);
          final tokenID =
              await sharedpref.readTheData(SharedPrefConstants.token);
          searchPayload = GlobalSearchPayload(
              userID: userID,
              empID: empID,
              tokenID: tokenID,
              aPPLICATIONID: applicationNoController.text.trim(),
              dISTRICTID: selectedDistrict?.dISTRICTID,
              mANDALID: selectedMandal?.mANDALID,
              vILLAGEID: selectedVillage?.vILLAGEID,
              nAME: nameController.text.trim(),
              sEARCHTYPE: selectedSearchType,
              sURVEYNO: surveyNoController.text.trim());
          if (!context.mounted) return;
          searchedData = null;
          final response = await GlobalSearchRepository()
              .globalSearchApi(context, searchPayload);
          setLoaderVisibleStatus(false);
          if (response?.statusCode == ApiErrorCodes.success) {
            searchedData = response?.globalSearchList;
            notifyListeners();
          } else if (response?.statusCode == ApiErrorCodes.badRequest) {
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: response?.statusMsg ?? "",
              onPressed: () async {
                Navigator.of(context).pop();
              },
            );
          } else if (response?.statusCode == ApiErrorCodes.sessionExpired) {
            if (!context.mounted) return;
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

  Future<void> getOfficerList(
    BuildContext context,
  ) async {
    try {
      officersList?.clear();
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        LocalStoreHelper sharedpref = LocalStoreHelper();
        GlobalSearchOfficerDetailsPayload officersListPayload =
            GlobalSearchOfficerDetailsPayload();
        final userID = await sharedpref.readTheData(SharedPrefConstants.userID);
        final empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        final tokenID = await sharedpref.readTheData(SharedPrefConstants.token);
        officersListPayload = GlobalSearchOfficerDetailsPayload(
          userID: userID,
          empID: empID,
          tokenID: tokenID,
          aPPLICATIONID: applicationNoController.text.trim(),
        );
        if (!context.mounted) return;
        final response = await GlobalSearchRepository()
            .globalSearchOfficerListApi(context, officersListPayload);
        setLoaderVisibleStatus(false);
        if (response?.statusCode == ApiErrorCodes.success) {
          officersList = response?.officersList;
          notifyListeners();
        } else if (response?.statusCode == ApiErrorCodes.badRequest) {
          if (!context.mounted) return;
          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        } else if (response?.statusCode == ApiErrorCodes.sessionExpired) {
          if (!context.mounted) return;
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
