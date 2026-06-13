import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/view_gis_coordinates.dart';
import 'package:lrsofficer/models/view_gis_coordinates_response.dart';
import 'package:lrsofficer/repository/view_polygon_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewPolygonViewModel extends ChangeNotifier {
  final ViewPolygonRepository _polygonRepository = ViewPolygonRepository();
  List<LatLng> latlongList = [];
  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  String formatLatLng(LatLng latLng) {
    return 'LatLng(${latLng.latitude}, ${latLng.longitude})';
  }

  Future<void> getPolygons(BuildContext context, String appId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String empId = prefs.getString(SharedPrefConstants.empID) ?? "";
      String token = prefs.getString(SharedPrefConstants.token) ?? "";
      String userId = prefs.getString(SharedPrefConstants.userID) ?? "";
      ViewGISCoOrdinatesRequest request = ViewGISCoOrdinatesRequest(
          empID: empId,
          tokenID: token,
          applicationID: appId,
          /* "M/SIDD/005943/2020", */
          userID: userId,
          isLayoutPlot: AppConstants.isLayoutPlot);

      AppLogger().logDebug("getPolygons:isLayoutPlot${request.toJson()}");
      if (await internetCheck()) {
        if (!context.mounted) return;
        ViewGISCoOrdinatesResponse? response =
            await _polygonRepository.viewPolygonDetailsRepo(context, request);
        setLoaderVisibleStatus(false);
        if (response != null && response.statusCode == ApiErrorCodes.success) {
          setLoaderVisibleStatus(false);
          if (response.gISLocationCoordinates != null &&
              response.gISLocationCoordinates != "") {
            try {
              // Decode the string to a List<dynamic>
              List<dynamic> jsonList =
                  jsonDecode(response.gISLocationCoordinates ?? "");

              // Check if the decoded list is empty
              if (jsonList.isEmpty) {
                latlongList = [];
              }

              // Convert the decoded list to LatLng
              latlongList = jsonList.map((e) => LatLng(e[1], e[0])).toList();
            } catch (e) {
              latlongList = [];
            }

            notifyListeners();
          } else {
            if (!context.mounted) return;
            ErrorCustomCupertinoAlert().showAlert(
              context,
              message: "noPolygonData".tr(),
              onPressed: () async {
                Navigator.popUntil(context,
                    ModalRoute.withName(AppRoutes.revenueApplicationDetails));
              },
            );
          }
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
    notifyListeners();
  }
}
