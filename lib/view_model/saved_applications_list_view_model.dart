import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/models/saved_applications/saved_applications_list_payload.dart';
import 'package:lrsofficer/models/saved_applications/saved_applications_list_response.dart';
import 'package:lrsofficer/repository/saved_applications_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';

class SavedApplicationsListViewModel extends ChangeNotifier {
  List<SavedApplications> savedApplicationsList = [];
  List<SavedApplications> searchSavedApplicationsList = [];
  List<SavedApplications> get getSavedApplicationsList => savedApplicationsList;
  List<SavedApplications> get getSearchedApplicationsList =>
      searchSavedApplicationsList;
  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  Future<void> getSavedApplicationListApi(BuildContext context) async {
    try {
      savedApplicationsList.clear();
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        SavedApplicationsListPayload request = SavedApplicationsListPayload();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.iSLayoutPlot = AppConstants.isLayoutPlot;
        if (!context.mounted) return;
        SavedApplicationsListResponse? response =
            await SavedApplicationsRepository()
                .getSavedApplicationsRepo(context, request);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          List<SavedApplications> applicationsCount =
              response.applications ?? [];
          if (applicationsCount.isNotEmpty) {
            savedApplicationsList = response.applications ?? [];
            searchSavedApplicationsList = savedApplicationsList;
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

  TextEditingController searchQueryController = TextEditingController();

  Widget buildSearchField() {
    return TextField(
      onChanged: ((value) {
        runFilter(value);
      }),
      controller: searchQueryController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon: searchQueryController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  if (searchQueryController.text.isNotEmpty) {
                    searchQueryController.clear();
                  }
                  searchSavedApplicationsList = savedApplicationsList;
                  notifyListeners();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ))
            : null,
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        hintText: "Search by Application Id, Applicant Name, Mobile No",
        hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            overflow: TextOverflow.ellipsis),
      ),
    );
  }

  void runFilter(String enteredKeyword) {
    List<SavedApplications>? results = [];
    if (enteredKeyword.isEmpty) {
      results = savedApplicationsList;
      searchSavedApplicationsList = results;
    } else {
      if (!kReleaseMode) debugPrint(enteredKeyword);
      results = savedApplicationsList
          .where((element) =>
              element.aPPLICATIONID!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              element.mobileNumber!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              element.applicantName!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();

      searchSavedApplicationsList = results;
      if (!kReleaseMode) debugPrint("${searchSavedApplicationsList.length}");
    }
    notifyListeners();
  }
}
