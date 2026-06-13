import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_ip_address/get_ip_address.dart';

class GetDeviceIpAddress {
  var deviceInfo = DeviceInfoPlugin();
  Future<String?> getIp() async {
    final networkList = await NetworkInterface.list();
    if (networkList.isNotEmpty) {
      try {
        for (var interface in networkList) {
          for (var addr in interface.addresses) {
            if (!kReleaseMode) {
              debugPrint(
                  'IP::::: ${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
            }
            // Check if it's an IPv4 address and not a loopback address
            if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
              return addr.address;
            }
          }
        }
      } catch (e) {
        var ipAddress = IpAddress(type: RequestType.text);

        /// Get the IpAddress based on requestType.
        dynamic data = await ipAddress.getIpAddress();
        if (!kReleaseMode) debugPrint(data.toString());
        return data.toString();
      }
    } else {
      var ipAddress = IpAddress(type: RequestType.text);

      /// Get the IpAddress based on requestType.
      dynamic data = await ipAddress.getIp();
      if (!kReleaseMode) debugPrint(data.toString());
      return data.toString();
    }
    return null;
  }
}
