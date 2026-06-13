import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/arcgis_model/add_feature_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArcGisRepository {
  final _baseClient = BaseApiClient();
  Future<AddFeatureResponse?> arcGisRepo(BuildContext context, dynamic request,
      String? payloadtoken, String? coordinatsCount) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final applicationId = prefs.getString(SharedPrefConstants.applicationNo);
      final features = {
        "geometry": {
          "rings": [request],
          "spatialReference": {"wkid": 4326}
        },
        "attributes": {
          "appid": "$applicationId",
          "coordinatecount": coordinatsCount
        }
      };
      final featuresString = jsonEncode(features);

      AppLogger().logDebug("applicationId:: $applicationId");

      final Map<String, dynamic> requestData = {
        'f': 'json',
        'features': [featuresString],
        'Token': payloadtoken
      };

      AppLogger().logDebug("coordinatsCount $coordinatsCount");

      AppLogger().logDebug("final payload $requestData");

      String payload = convertToFormData(requestData);
      if (!context.mounted) return null;
      final token = CancelToken();
      final response = await _baseClient.postCallWithFormdata(
          ApiConstants.addFteature, payload, false, token);

      return AddFeatureResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<String?> generateToken(BuildContext context, dynamic request) async {
    try {
      String payload = convertToFormData(request);
      final token = CancelToken();
      final response = await _baseClient.postCallWithFormdata(
          ApiConstants.generateToken, payload, true, token);
      return response.toString();
    } catch (e) {
      return Future.error(e);
    }
  }

  String convertToFormData(Map<String, dynamic> data) {
    return data.entries.map((entry) {
      final key = Uri.encodeQueryComponent(entry.key);
      final value = Uri.encodeQueryComponent(entry.value.toString());
      return '$key=$value';
    }).join('&');
  }
}
