import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/models/individual_plots_new_flow/layout_dynamic_menu_payload.dart';
import 'package:lrsofficer/models/individual_plots_new_flow/layout_dynamic_menu_response.dart';
import 'package:lrsofficer/res/constants/api_constants.dart';

class LayoutDynamicMenuRepository {
  final _baseClient = BaseApiClient();
  Future<LayoutDynamicSubMenuResponse?> menuRepo(
      BuildContext context, LayoutDynamicSubMenuPayload request) async {
    try {
      final token = CancelToken();
      final response = await _baseClient.postCall(
           ApiConstants.layoutDynamicSubMenu, request.toJson(), token);
      return LayoutDynamicSubMenuResponse.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
