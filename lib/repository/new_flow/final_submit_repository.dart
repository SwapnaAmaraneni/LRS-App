import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/villagewise_cluster_inspection_submit/final_submit_payload.dart';
import 'package:lrsofficer/models/villagewise_cluster_inspection_submit/final_submit_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class FifpFinalSubmit {
  final _baseApiClinet = BaseApiClient();
  Future<FinalSubmitResponse?> finalSubmitApi(
      BuildContext context, FinalSubmitPayload payload) async {
    try {
      final payloadJson = payload.toJson();
      final strJson = jsonEncode(payloadJson);

      AppLogger().logDebug("FIFP Final Submit Payload: $strJson");
      final token = CancelToken();
      final response = await _baseApiClinet.postCall(
          ApiConstants.fifpFinalSubmit, payload.toJson(), token);
      return FinalSubmitResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
