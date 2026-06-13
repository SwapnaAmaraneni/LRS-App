import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/base_api_client.dart';
import '../models/generate_mpin_payload.dart';
import '../models/generate_mpin_response.dart';
import '../res/constants/api_constants.dart';

class GenerateMPINRepository {
  final _baseApiClinet = BaseApiClient();
  Future<GenerateMPINResponse?> generateMpinRepo(
      BuildContext context, GenerateMPINPayLoad generateMpinPayLoad) async {
    try {
      final token = CancelToken();
      final response = await _baseApiClinet.postCall(
          ApiConstants.generateMpinEndPoint,
          generateMpinPayLoad.toJson(),
          token);
      return GenerateMPINResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
